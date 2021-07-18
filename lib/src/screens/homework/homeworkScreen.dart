import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oneplace_illinois/src/models/homeworkItem.dart';
import 'package:oneplace_illinois/src/widgets/homework/homework.dart';

class HomeworkScreen extends StatelessWidget {
  final HomeworkItem homework;

  const HomeworkScreen({Key? key, required this.homework}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(
          homework.name,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: HomeworkItemWidget(homework: homework),
      ),
    );
  }
}
