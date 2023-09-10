import 'package:flutter/material.dart';
import 'package:gapshap_4/widgets/my_Button.dart';
import 'package:gapshap_4/widgets/my_text_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../services/auth/authService.dart';

class Loginpage extends StatefulWidget {
  final void Function()? onTap;
  const Loginpage({super.key, required this.onTap});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  // text controller for email and password
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // signup user
  void signIn() async {
    // get auth service
    print('button is clicked');
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailandPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
    print('button is clicked');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // create icon button

                // const Icon(
                //   Icons.message,
                //   size: 80,
                //   color: Colors.deepPurple,
                // ),
                SizedBox(
                  height: 300,
                  child: Image.asset('assets/images/Sign_up.png'),
                ),
                const SizedBox(height: 25),
                const SizedBox(height: 25),

                // welcome back msg

                const Text(
                  "Start Your journey",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 25),

                // email text field

                MyTextField(
                  controller: emailController,
                  hintText: 'Enter the Email',
                  obsucureText: false,
                ),
                const SizedBox(height: 16),
                // password text field

                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obsucureText: false,
                ),
                const SizedBox(height: 25),
                // Sign in Button

                MyButton(ontap: signIn, text: "Sign In"),
                const SizedBox(height: 16),
                // not a member?register now

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Not a Member ?"),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Register Now",
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ).p16(),
          ),
        ),
      ),
    );
  }
}
