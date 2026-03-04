import 'package:flutter/material.dart';
import 'package:untitled/services/auth/auth_services.dart';
import 'components/my_buttons.dart';
import 'components/my_textfield.dart';
import 'components/otp_dialog.dart';

class Register extends StatefulWidget {
  final void Function()? onTap;

  const Register({
    super.key,
    required this.onTap,
  });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
      ),
    );
  }

  // void register() async {
  //   if (passwordController.text != confirmPasswordController.text) {
  //     showDialog(
  //       context: context,
  //       builder: (context) => const AlertDialog(
  //         title: Text("Passwords don't match!"),
  //       ),
  //     );
  //     return;
  //   }
  //
  //   setState(() => isLoading = true);
  //
  //   final authService = AuthService();
  //
  //   try {
  //     // 1️⃣ Create email account first
  //     await authService.signUpWithEmailPassword(
  //       emailController.text.trim(),
  //       passwordController.text.trim(),
  //     );
  //
  //     // 2️⃣ Send OTP to phone
  //     await authService.verifyPhoneNumber(
  //       phoneController.text.trim(),
  //           () {
  //         // This runs when SMS is sent successfully
  //         if (mounted) {
  //           setState(() => isLoading = false);
  //
  //           showDialog(
  //             context: context,
  //             barrierDismissible: false,
  //             builder: (context) => const OtpDialog(),
  //           );
  //         }
  //       },
  //     );
  //   } catch (e) {
  //     if (mounted) {
  //       setState(() => isLoading = false);
  //
  //       showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text("Registration Error"),
  //           content: Text(e.toString()),
  //         ),
  //       );
  //     }
  //   }
  // }

  void register() async {
    // Basic validation
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter your full name")));
      return;
    }
    if (phoneController.text.isEmpty || !phoneController.text.contains('+')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter phone number with country code (e.g. +91)")),
      );
      return;
    }

    setState(() => isLoading = true);
    final authService = AuthService();

    try {
      // We START with phone verification.
      // We don't create the email user yet!
      await authService.verifyPhone(
          phoneController.text,
              (verId) {
            setState(() => isLoading = false);
            // ONLY show the dialog when the code is sent
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => OtpDialog(
                // We pass the email/password to the dialog so it can
                // complete the full registration after OTP is correct
                name: nameController.text.trim(),
                email: emailController.text,
                password: passwordController.text,
                phoneNumber: phoneController.text,
              ),
            );
          }
      );
    } catch (e) {
      setState(() => isLoading = false);
      _showError(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  // Logo
                  SizedBox(
                    height: 150,
                    child: Image.asset(
                      "assets/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Let's Create an Account for You",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 25),
                  MyTextField(
                    controller: nameController,
                    obscureText: false,
                    hintText: "Enter Full Name",
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: phoneController,
                    obscureText: false,
                    hintText: "+919876543210",
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: emailController,
                    obscureText: false,
                    hintText: "Enter your email",
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: passwordController,
                    obscureText: true,
                    hintText: "Enter your password",
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    hintText: "Confirm Password",
                  ),
                  const SizedBox(height: 25),

                  // Button with loading state
                  MyButton(
                    text: "Sign Up",
                    onTap: isLoading ? null : register,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : null, // Pass null so it shows the text "Sign Up"
                  ),

                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Login Now",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}