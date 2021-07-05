import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oneplace_illinois/src/services/firebaseAuth.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(
          backgroundColor: AppColors.secondaryUofIDark,
          title: Text(
            "Verify Email",
            style: TextStyle(color: Colors.white),
          ),
        ),
        iosContentPadding: true,
        body: Center(
              child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Please check your inbox for a verification email.',
                  textAlign: TextAlign.center,
                ),
                PlatformElevatedButton(
                  onPressed: () => _authService.reloadUser(),
                  child: Text(
                    "Continue to Home",
                  ),
                  cupertino: (context, platform) =>
                      CupertinoElevatedButtonData(color: AppColors.primaryUofI),
                  material: (context, platform) => MaterialElevatedButtonData(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              AppColors.primaryUofI))),
                ),
                PlatformElevatedButton(
                  onPressed: () => _authService.resendVerificationEmail(),
                  child: Text(
                    "Resend Verification Email",
                  ),
                  cupertino: (context, platform) =>
                      CupertinoElevatedButtonData(color: AppColors.primaryUofI),
                  material: (context, platform) => MaterialElevatedButtonData(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              AppColors.primaryUofI))),
                ),
              ],
            ),
          ],
        ));
  }
}
