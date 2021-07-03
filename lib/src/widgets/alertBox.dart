import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AlertBox extends StatelessWidget {
  final Color? iconColor;
  final Widget child;
  AlertBox({Key? key, this.iconColor, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Card(
            color: Colors.grey[850],
            elevation: 0.0,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.error_outline,
                      color: iconColor ?? Colors.redAccent,
                    ),
                  ),
                  child,
                ],
              ),
            ),
            margin: EdgeInsets.all(10.0),
          ),
        ),
      ],
    );
  }
}
