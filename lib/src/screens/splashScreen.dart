import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oneplace_illinois/src/onePlace.dart';
import 'package:oneplace_illinois/src/screens/authenticate.dart';
import 'package:oneplace_illinois/src/screens/emailVerification.dart';
import 'package:provider/provider.dart';
/*
Loading screen while app checks user data and connects to the internet.
*/

class SplashScreen extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  bool register = false;

  @override
  void initState() {
    super.initState();
  }

  void toggleScreen() {
    setState(() {
      register = !register;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<User?>(context);

    //App Navigation
    if (user != null) {
      if (user.emailVerified) {
        return OnePlaceTabs();
      } else {
        return EmailVerification();
      }
    } else {
      return Authenticate(register: register, toggleScreen: toggleScreen);
    }
  }
}
