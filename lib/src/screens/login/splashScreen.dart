import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oneplace_illinois/src/onePlace.dart';
import 'package:oneplace_illinois/src/providers/accountProvider.dart';
import 'package:oneplace_illinois/src/screens/loadingPage.dart';
import 'package:oneplace_illinois/src/screens/login/authenticate.dart';
import 'package:oneplace_illinois/src/screens/login/emailVerification.dart';
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
    final AccountProvider accountProvider =
        Provider.of<AccountProvider>(context);
    //App Navigation
    if (user != null) {
      if (user.emailVerified) {
        if (accountProvider.jwt == null && !accountProvider.working) {
          accountProvider.init();
        } else if (accountProvider.jwt != null) {
          return OnePlaceTabs();
        }
        return LoadingPage();
      } else if (!user.emailVerified) {
        return EmailVerification();
      } else {
        return LoadingPage();
      }
    } else {
      return Authenticate(register: register, toggleScreen: toggleScreen);
    }
  }
}
