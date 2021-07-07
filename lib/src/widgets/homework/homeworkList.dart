import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oneplace_illinois/src/models/homeworkItem.dart';

import '../../screens/homework/homeworkScreen.dart';

class HomeworkList extends StatelessWidget {
  final List<HomeworkItem> homework;

  const HomeworkList({Key? key, required this.homework}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var homeworkItem in homework)
          Card(
            child: ListTile(
              title: Text(homeworkItem.name),
              subtitle: homeworkItem.description != null
                  ? Text(
                      homeworkItem.description!,
                      overflow: TextOverflow.ellipsis,
                    )
                  : Text(
                      'No description',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
              isThreeLine: false,
              trailing: Text(
                homeworkItem.dueInfo,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () => handleHomeworkItemTap(context, homeworkItem),
            ),
            margin: EdgeInsets.only(top: 10, bottom: 10),
          ),
      ],
      padding: EdgeInsets.all(20),
    );
  }

  handleHomeworkItemTap(BuildContext context, HomeworkItem homework) {
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (_) => HomeworkScreen(homework: homework),
      ),
    );
  }
}
