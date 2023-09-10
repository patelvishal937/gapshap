import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gapshap_4/services/auth/authService.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../widgets/my_Button.dart';
import '../widgets/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controller for email,password and confirmpassword

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final aboutController = TextEditingController();
  // signup user

  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("password not match"),
        ),
      );
      return;
    } else {
      // get authservice
      final authservice = Provider.of<AuthService>(context, listen: false);
      try {
        await authservice.signUpWIthEmailandPassword(
            emailController.text,
            passwordController.text,
            firstNameController.text,
            mobileNumberController.text,
            aboutController.text);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
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
                  child: Image.asset('assets/images/Otp_logo.png'),
                ),
                const SizedBox(height: 25),

                // welcome back msg

                const Text(
                  "Let's create a account for you",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 25),

                // FIRST NAME

                MyTextField(
                  controller: firstNameController,
                  hintText: 'Enter the FirstName',
                  obsucureText: false,
                ),
                const SizedBox(height: 16),

                // MOBILE NUMBER

                MyTextField(
                  controller: mobileNumberController,
                  hintText: 'Mobile Number',
                  obsucureText: false,
                ),
                const SizedBox(height: 16),

                // about
                MyTextField(
                  controller: aboutController,
                  hintText: 'about',
                  obsucureText: false,
                ),
                const SizedBox(height: 16),

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
                const SizedBox(height: 16),

                // password text field

                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'confirm Password',
                  obsucureText: false,
                ),
                const SizedBox(height: 25),
                // Sign in Button

                MyButton(ontap: signUp, text: "Register Now"),
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
