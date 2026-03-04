import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/services/auth/auth_services.dart';
import 'package:untitled/home_page.dart';
import 'dart:async';
import '../services/database/database_service.dart';

class OtpDialog extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;

  const OtpDialog({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  @override
  State<OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());

  bool isVerifying = false;

  Timer? _timer;
  int _start = 30;
  bool canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _start = 30;
    canResend = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
        if (mounted) {
          setState(() => canResend = true);
        }
      } else {
        if (mounted) {
          setState(() => _start--);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  // ✅ PRODUCTION READY VERIFY METHOD
  Future<void> _verifyOtp() async {
    if (isVerifying) return; // prevent double tap

    String otp = _controllers.map((e) => e.text.trim()).join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter all 6 digits")),
      );
      return;
    }

    setState(() => isVerifying = true);

    final authService = AuthService();
    final dbService = DatabaseService();

    try {
      // 1️⃣ Verify Phone OTP
      UserCredential userCredential = await authService.loginInWithOTP(otp);
      User? user = userCredential.user;
      if (user == null) throw Exception("User not found");

      // Give Firebase Auth a millisecond to "settle" its state locally
      await Future.delayed(const Duration(milliseconds: 500));

      // 2️⃣ Update Display Name & Email (Auth side)
      await user.updateDisplayName(widget.name.trim());

      await user.reload();

      // 3️⃣ Link Email & Password (Single Account System)
      try {
        AuthCredential emailCredential =
        EmailAuthProvider.credential(
          email: widget.email.trim(),
          password: widget.password.trim(),
        );

        await user.linkWithCredential(emailCredential);
      } catch (e) {
        // Email already linked / exists → continue safely
        debugPrint("Email link note: $e");
      }

      // 4️⃣ Ensure Email Updated
      try {
        await user.updateEmail(widget.email.trim());
        await user.reload();
      } catch (e) {
        debugPrint("Email update note: $e");
      }

      // 5️⃣ Save to Firestore
      // Pass variables explicitly if needed, but the getter in dbService should work now
      await dbService.updateProfile(
        name: widget.name.trim(),
        email: widget.email.trim(),
        phone: widget.phoneNumber.trim(),
      );

      // 6️⃣ Save to Local Storage (Instant Login)
      await dbService.saveUserLocally(
        widget.name.trim(),
        user.uid,
      );

      if (!mounted) return;

      // Close dialog FIRST
      Navigator.of(context, rootNavigator: true).pop();

      // Navigate cleanly (prevents home showing early)
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
            (route) => false,
      );
    } catch (e) {
      if (mounted) {
        setState(() => isVerifying = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification Failed: $e")),
        );
      }
    }
  }

  // ✅ Resend OTP
  Future<void> _resendCode() async {
    final authService = AuthService();

    try {
      await authService.verifyPhone(widget.phoneNumber, (verId) {
        _startTimer();

        for (var controller in _controllers) {
          controller.clear();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("New OTP Sent!")),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Verify OTP",
        textAlign: TextAlign.center,
      ),
      content: isVerifying
          ? const SizedBox(
        height: 120,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
          : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Enter the 6-digit code sent to your phone",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9.0),
                  child: _otpBox(index),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          canResend
              ? TextButton(
            onPressed: _resendCode,
            child: const Text("Resend Code"),
          )
              : Text(
            "Resend in $_start seconds",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: isVerifying
              ? null
              : () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed:
          isVerifying ? null : _verifyOtp,
          child: const Text("Verify"),
        ),
      ],
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 45,
      child: TextField(
        controller: _controllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }

          if (index == 5 && value.isNotEmpty) {
            _verifyOtp();
          }
        },
      ),
    );
  }
}