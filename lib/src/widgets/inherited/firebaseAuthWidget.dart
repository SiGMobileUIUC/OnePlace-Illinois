import 'package:flutter/widgets.dart';
import 'package:oneplace_illinois/src/services/firebaseAuth.dart';

class FirebaseAuthWidget extends InheritedWidget {
  final FirebaseAuthService firebaseAuth;

  FirebaseAuthWidget({required this.firebaseAuth, required child})
      : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static FirebaseAuthWidget? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FirebaseAuthWidget>();
}
