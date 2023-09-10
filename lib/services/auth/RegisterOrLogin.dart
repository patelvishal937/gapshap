import 'package:flutter/material.dart';
import 'package:gapshap_4/pages/RegisterPage.dart';
import 'package:gapshap_4/pages/loginPage.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // initally show the login page
  bool showTheLoginPage = true;
  // toggle between two pages
  void togglePages() {
    setState(() {
      showTheLoginPage = !showTheLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showTheLoginPage) {
      return Loginpage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
