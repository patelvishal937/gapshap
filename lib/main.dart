import 'package:flutter/material.dart';
import 'package:gapshap_4/firebase_options.dart';
import 'package:gapshap_4/services/auth/authGate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gapshap_4/services/auth/authService.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

late Size mq;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MaterialApp(
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: AuthGate(),
      ),
    );
  }
}
