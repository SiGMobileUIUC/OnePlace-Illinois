import 'package:flutter/widgets.dart';
import 'package:oneplace_illinois/src/services/api.dart';
import 'package:oneplace_illinois/src/services/firebaseAuth.dart';
import 'package:oneplace_illinois/src/widgets/inherited/apiWidget.dart';
import 'package:oneplace_illinois/src/widgets/inherited/firebaseAuthWidget.dart';

class Services extends StatelessWidget {
  final FirebaseAuthService firebaseAuth = FirebaseAuthService();
  late final ApiService api;
  final Widget child;

  Services({required this.child}) {
    api = ApiService(firebaseAuth: firebaseAuth);
    api.login();
  }

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
