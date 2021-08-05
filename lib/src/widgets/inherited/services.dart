import 'package:flutter/widgets.dart';
import 'package:oneplace_illinois/src/services/api.dart';
import 'package:oneplace_illinois/src/services/firebaseAuth.dart';
import 'package:oneplace_illinois/src/widgets/inherited/apiWidget.dart';
import 'package:oneplace_illinois/src/widgets/inherited/firebaseAuthWidget.dart';

class Services extends StatelessWidget {
  final ApiService api;
  final FirebaseAuthService firebaseAuth;
  final Widget child;

  Services(
      {required this.api, required this.firebaseAuth, required this.child});

  @override
  Widget build(BuildContext context) {
    return ApiServiceWidget(
      api: api,
      child: FirebaseAuthWidget(
        firebaseAuth: firebaseAuth,
        child: child,
      ),
    );
  }
}
