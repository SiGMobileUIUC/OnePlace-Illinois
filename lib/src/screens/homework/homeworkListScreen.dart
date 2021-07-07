import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:oneplace_illinois/src/models/homeworkItem.dart';

import '../../widgets/homework/homeworkList.dart';

class HomeworkListScreen extends StatelessWidget {
  final List<HomeworkItem> homework;

  const HomeworkListScreen({Key? key, required this.homework})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        backgroundColor: AppColors.secondaryUofIDark,
        title: Text('Homework', style: TextStyle(color: Colors.white)),
      ),
      body: HomeworkList(
        homework: homework,
      ),
    );
  }
}
