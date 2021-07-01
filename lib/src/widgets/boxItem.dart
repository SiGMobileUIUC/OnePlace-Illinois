import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';

class BoxItem extends StatelessWidget {
  final Widget child;
  final double margin;
  final double padding;
  final double width;

  BoxItem(
      {Key? key,
      required this.child,
      this.margin = 12.0,
      this.padding = 12.0,
      this.width = double.infinity})
      : super(key: key);

  //factory BoxItem.sliding({Key key, @required this.child, this.margin = 12.0, this.padding = 12.0, this.width = });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        color: AppColors.secondaryUofIDark,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.0),
        child: child,
      ),
    );
  }
}
