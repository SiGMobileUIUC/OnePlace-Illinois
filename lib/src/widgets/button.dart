import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';

class Button extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;

  Button({required this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PlatformButton(
      onPressed: onPressed,
      child: child,
      color: Colors.white,
      cupertino: (context, platform) => CupertinoButtonData(
        color: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? AppColors.secondaryUofIDark
            : AppColors.secondaryUofILight,
      ),
      materialFlat: (context, platform) => MaterialFlatButtonData(
        textColor: Colors.white,
        color: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? AppColors.secondaryUofIDark
            : AppColors.secondaryUofILight,
      ),
    );
  }
}
