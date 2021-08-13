import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oneplace_illinois/src/models/homeworkItem.dart';
import 'package:oneplace_illinois/src/screens/homework/homeworkScreen.dart';

class HomeworkList extends StatelessWidget {
  final List<HomeworkItem> homework;

  const HomeworkList({Key? key, required this.homework}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: homework.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.grey[350],
            child: ListTile(
              title: Text(homework[index].name),
              subtitle: homework[index].description != null
                  ? Text(
                      homework[index].description!,
                      overflow: TextOverflow.ellipsis,
                    )
                  : Text(
                      'No description',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
              isThreeLine: false,
              trailing: Text(
                homework[index].dueInfo,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(
                    builder: (context) {
                      return HomeworkScreen(homework: homework[index]);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
