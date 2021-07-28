import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';

class Button extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  final Color textColor;

  Button({required this.child, this.onPressed, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return PlatformButton(
      onPressed: onPressed,
      child: child,
      color: textColor,
      cupertino: (context, platform) => CupertinoButtonData(
        color: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? AppColors.secondaryUofIDark
            : AppColors.secondaryUofILight,
      ),
      materialFlat: (context, platform) => MaterialFlatButtonData(
        textColor: textColor,
        color: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? AppColors.secondaryUofIDark
            : AppColors.secondaryUofILight,
      ),
    );
  }
}
