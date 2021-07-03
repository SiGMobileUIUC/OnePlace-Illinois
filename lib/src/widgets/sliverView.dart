import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:oneplace_illinois/src/screens/home/feedTab.dart';
import 'package:oneplace_illinois/src/screens/home/search.dart';

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

  Widget _search(BuildContext context) {
    if (children[0] is FeedTab) {
      return PlatformIconButton(
        icon: Icon(PlatformIcons(context).search),
        color: Colors.white,
        onPressed: () {
          showSearch(
            context: context,
            delegate: Search(),
          );
        },
      );
    }
    return SizedBox(
      height: 0,
      width: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        PlatformWidget(
          material: (context, _) => SliverAppBar(
            pinned: true,
            forceElevated: true,
            expandedHeight: 80.0,
            backgroundColor: AppColors.secondaryUofIDark,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                title,
                style: titleStyle ?? TextStyle(),
              ),
            ),
            brightness: Brightness.light,
            actions: [_search(context)],
          ),
          cupertino: (context, _) => CupertinoSliverNavigationBar(
            backgroundColor: AppColors.secondaryUofIDark,
            border: Border(
              bottom: BorderSide(
                color: CupertinoColors.systemGrey,
                width: 0.5,
              ),
            ),
            brightness: Brightness.light,
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
