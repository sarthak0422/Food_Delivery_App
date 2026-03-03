import 'package:flutter/material.dart';
import 'package:untitled/components/my_buttons.dart';
import 'package:untitled/components/my_textfield.dart';
import 'package:untitled/components/otp_dialog.dart';
import 'package:untitled/services/auth/auth_services.dart';
import 'package:untitled/home_page.dart';

class Login extends StatefulWidget {
  final void Function()? onTap;

  const Login({super.key, required this.onTap});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
      ),
    );
  }

  void login() async {
    final authService = AuthService();
    setState(() => isLoading = true);

    try {
      // 1️⃣ Email + Password login
      if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
        await authService.signInWithEmailPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      }
      // 2️⃣ Phone login
      else if (phoneController.text.isNotEmpty) {
        if (!phoneController.text.contains('+')) {
          throw Exception("Please include country code in phone (e.g. +91)");
        }

        await authService.verifyPhone(
          phoneController.text.trim(),
              (verificationId) {
            setState(() => isLoading = false);
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => OtpDialog(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
                phoneNumber: phoneController.text.trim(), name: '',
              ),
            );
          },
        );
      }
      // 3️⃣ Neither provided
      else {
        throw Exception("Please enter Email/Password OR Phone Number");
      }
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Image.asset(
                  "assets/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                "GharKaLunch",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 25),

              // ---------- PHONE LOGIN ----------
              MyTextField(
                controller: phoneController,
                obscureText: false,
                hintText: "+91-..........",
              ),

              const SizedBox(height: 15),

              // ---------- OR DIVIDER ----------
              Row(
                children: [
                  Expanded(child: Divider(color: Theme.of(context).colorScheme.tertiary)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("OR"),
                  ),
                  Expanded(child: Divider(color: Theme.of(context).colorScheme.tertiary)),
                ],
              ),

              const SizedBox(height: 15),

              // ---------- EMAIL LOGIN ----------
              MyTextField(
                controller: emailController,
                obscureText: false,
                hintText: "Enter your email",
              ),
              const SizedBox(height: 15),

              MyTextField(
                controller: passwordController,
                obscureText: true,
                hintText: "Enter your password",
              ),
              const SizedBox(height: 25),

              MyButton(
                text: "Sign In",
                onTap: isLoading ? null : login,
                child: isLoading ? const CircularProgressIndicator() : null,
              ),
              const SizedBox(height: 25),

              // ---------- REGISTER LINK ----------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a Member?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Register Now",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}