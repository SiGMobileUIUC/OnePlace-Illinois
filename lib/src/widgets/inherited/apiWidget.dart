import 'package:flutter/widgets.dart';
import 'package:oneplace_illinois/src/services/api.dart';

class ApiServiceWidget extends InheritedWidget {
  final ApiService api;

  ApiServiceWidget({required this.api, required child}) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static ApiServiceWidget of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ApiServiceWidget>()!;
}
