import 'package:flutter/material.dart';
import 'package:untitled/components/my_buttons.dart';
import 'package:untitled/components/my_textfield.dart';

import 'package:untitled/services/auth/auth_services.dart';

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

  //login method
  void login() async {
    //get instance of auth services
    final authServices = AuthService();
    //try sign in
    try {
      await authServices.signInWithEmailPassword(emailController.text, passwordController.text,);
    }
    //display any error
    catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
      );
    }
  }

  //forget password
  void forgotPW() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text("User tapped forget page"),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Icon(
              Icons.lock_open_outlined,
              size: 72,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(height: 25),

            // Message
            Text(
              "Food Delivery App",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            const SizedBox(height: 25),

            MyTextField(
              controller: phoneController,
              obscureText: false,
              hintText: "+91-..........",
            ),
            const SizedBox(height: 25),

            // Email TextField
            MyTextField(
              controller: emailController,
              obscureText: false,
              hintText: "Enter your email",
            ),
            const SizedBox(height: 25),

            // Password TextField
            MyTextField(
              controller: passwordController,
              obscureText: true,
              hintText: "Enter your password",
            ),
            const SizedBox(height: 25),

            // Button
            // ElevatedButton(
            //   onPressed: () {
            //     // Perform login action
            //   },
            //   child: Text('Login'),
            // ),
            //
            // // Register Now
            // TextButton(
            //   onPressed: () {
            //     // Navigate to registration page
            //   },
            //   child: Text('Register Now'),
            // ),
            MyButton(
              text: "Sign In",
              onTap: widget.onTap,
            ),

            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(
                "Not a Member?",
                  style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
              GestureDetector(
                onTap: widget.onTap,
                child: Text(
                  "Register Now",
                  style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
