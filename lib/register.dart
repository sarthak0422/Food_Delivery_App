import 'package:flutter/material.dart';
import 'package:untitled/home_page.dart';
import 'package:untitled/services/auth/auth_services.dart';
import 'components/my_buttons.dart';
import 'components/my_textfield.dart';

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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();


  //register method
  void register() async {
    //get auth service
    final authService = AuthService();
    //check if password matches  -> create user
    if (passwordController.text == confirmPasswordController.text) {
      //try creating user
      try {
        await authService.signInWithEmailPassword(emailController.text, passwordController.text,);
      }
      //display any errors
      catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(e.toString()),
            ),
        );
      }
    }
    //if password don't match -> show error
    else {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text("Password don't match!!"),
          ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                  "Let's Create an Account for You",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                const SizedBox(height: 25),

                MyTextField(
                  controller: phoneController,
                  obscureText: false,
                  hintText: "+91- ..........",
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

                // Confirm Password TextField
                MyTextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  hintText: "Confirm Password",
                ),
                const SizedBox(height: 25),

                // Button sign up
                MyButton(
                  text: "Sign Up",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Already have an account? login here
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
