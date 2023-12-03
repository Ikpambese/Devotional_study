import 'dart:async';

import 'package:adminnewlifedevotion/authentication/auth_screen.dart';
import 'package:adminnewlifedevotion/screens/home_screen.dart';
import 'package:adminnewlifedevotion/screens/upload_pdf.dart';
import 'package:flutter/material.dart';
import '../services/global.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 8), () async {
      //if seller is already logged in
      if (firebaseAuth.currentUser != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => const HomeScreen(), //home
            ));
      } else {
        // if seller is not authenticated
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => const AuthScreen(), //auth
            ));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        // color: Color.fromARGB(255, 13, 71, 161),
        color: Colors.white,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/imgs/logo.jpg',
                height: 100,
                width: 100,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      const Color.fromARGB(255, 13, 71, 161).withOpacity(0.5)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
