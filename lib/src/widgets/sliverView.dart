import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';

class SliverView extends StatelessWidget {
  SliverView({
    Key? key,
    required this.title,
    required this.children,
    this.titleStyle,
  });

  final String title;
  final List<Widget> children;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        PlatformWidget(
          material: (context, _) => SliverAppBar(
            pinned: true,
            forceElevated: true,
            expandedHeight: 100.0,
            backgroundColor: AppColors.secondaryUofIDark,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                title,
                style: titleStyle ?? TextStyle(),
              ),
            ),
            brightness: Brightness.dark,
          ),
          cupertino: (context, _) => CupertinoSliverNavigationBar(
            backgroundColor: AppColors.secondaryUofIDark,
            border: Border(
              bottom: BorderSide(
                color: CupertinoColors.systemGrey,
                width: 0.5,
              ),
            ),
            brightness: Brightness.dark,
            largeTitle: Text(
              title,
              style: titleStyle ?? TextStyle(),
            ),
          ),
        ),
        SliverSafeArea(
          top: false, // Top safe area is consumed by the navigation bar.
          sliver: SliverList(
            delegate: SliverChildListDelegate(children),
          ),
        ),
      ],
    );
  }
}
