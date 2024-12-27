import 'package:actual/common/view/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const _App(),
  );
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: const Scaffold(
        backgroundColor: Colors.white,
        body: SplashScreen(),
      ),
    );
  }
}
