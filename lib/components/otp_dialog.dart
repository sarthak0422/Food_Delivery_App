import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/services/auth/auth_services.dart';
import 'package:untitled/home_page.dart';
import 'dart:async';

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
    startTimer();
  }

  void startTimer() {
    setState(() {
      _start = 30;
      canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          canResend = true;
          timer.cancel();
        });
      } else {
        setState(() => _start--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // ✅ Verify OTP
  void _verifyOtp() async {
    setState(() => isVerifying = true);
    String otp = _controllers.map((e) => e.text).join();
    final authService = AuthService();
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter all 6 digits")),
      );
      return;
    }

    try {
      // 1. Sign in with Phone first
      UserCredential userCredential = await authService.loginInWithOTP(otp);

      // 2. Set the Display Name (Full Name)
      await userCredential.user?.updateDisplayName(widget.name);

      // 3. Link Email/Password

      try {
        // This creates a single account with both Phone and Email login
        AuthCredential emailCredential = EmailAuthProvider.credential(
          email: widget.email.trim(),
          password: widget.password.trim(),
        );

        await userCredential.user?.linkWithCredential(emailCredential);
        try {
          // This ensures the email is explicitly set on the account profile
          await userCredential.user?.updateEmail(widget.email.trim());
          await userCredential.user?.reload();
        } catch (e) {
          print("Email profile update note: $e");
        }
      }catch (linkError) {
        // If the email is already in use, we just continue
        // as the phone is already verified.
        print("Link error or email already exists: $linkError");
      }

      if (mounted) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } catch (e) {
      setState(() => isVerifying = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid OTP: $e")));
    }
  }

  // ✅ Resend code
  void _resendCode() async {
    final authService = AuthService();
    try {
      // Trigger the SMS again using the passed phone number
      await authService.verifyPhone(widget.phoneNumber, (verId) {
        startTimer(); // Reset the 30s countdown
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("New OTP Sent!")));
        for (var controller in _controllers) {
          controller.clear();
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Verify OTP",
        textAlign: TextAlign.center,
      ),
      content: isVerifying
          ? SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
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
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        ElevatedButton(
          onPressed: isVerifying ? null : _verifyOtp,
          child: const Text("Verify"),
        ),
      ],
    );
  }

  // ✅ OTP box widget
  Widget _otpBox(int index) {
    return SizedBox(
      width: 45,
      child: TextField(
        controller: _controllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          // Auto-submit when last digit entered
          if (index == 5 && value.isNotEmpty) {
            _verifyOtp();
          }
        },
      ),
    );
  }
}