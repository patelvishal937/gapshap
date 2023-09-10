import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gapshap_4/pages/homePage.dart';
import 'package:gapshap_4/services/auth/RegisterOrLogin.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // user is logged in

            if (snapshot.hasData) {
              return const Homepage();
            }
             else {
              return const LoginOrRegister();
            }
            // user is not logged in
          }),
    );
  }
}
