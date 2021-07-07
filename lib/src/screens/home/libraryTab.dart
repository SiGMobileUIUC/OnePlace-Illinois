import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:oneplace_illinois/src/misc/enums.dart';
import 'package:oneplace_illinois/src/models/courseItem.dart';
import 'package:oneplace_illinois/src/models/file.dart';
import 'package:oneplace_illinois/src/models/homeworkItem.dart';
import 'package:oneplace_illinois/src/screens/homework/homeworkListScreen.dart';

/*
Main page for the Library tab, will add more details later.
*/

class LibraryTab extends StatefulWidget {
  const LibraryTab({Key? key}) : super(key: key);

  @override
  _LibraryTabState createState() => _LibraryTabState();
}

final CourseItem course = CourseItem(
  year: 2021,
  semester: Semester.Fall,
  semesterID: 25,
  subject: 'Math',
  subjectID: "math",
  courseID: 34535,
  title: 'Calculus I',
  description: 'Calulus 1 for people',
  creditHours: '4',
  courseSectionInformation: 'Only X people',
  classScheduleInformation: "DAILY",
);

class _LibraryTabState extends State<LibraryTab> {
  List<HomeworkItem> homework = [
    HomeworkItem(
      dueDate: DateTime.now().add(Duration(days: 2)),
      name: 'Practice Problems #1',
      description: 'This homework will help prepare you for the test!',
      assignmentUrl: 'https://example.com',
      platform: 'turnitin',
      course: course,
      files: [
        File(
          name: 'Problem set.json',
          mimeType: 'application/json',
          size: 400,
          url: 'https://example.com',
        ),
        File(
          name: 'Problem set.json',
          mimeType: 'application/json',
          size: 400,
          url: 'https://example.com',
        ),
        File(
          name: 'Problem set.json',
          mimeType: 'application/json',
          size: 400,
          url: 'https://example.com',
        )
      ],
    ),
    HomeworkItem(
      name: 'Practice Problems #2',
      dueDate: DateTime.now().add(Duration(days: 7)),
      assignmentUrl: 'https://en.wikipedia.org/wiki/Hot_air_ballooning',
      platform: 'turnitin',
      course: course,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return PlatformElevatedButton(
      child: Text('Show Homework'),
      cupertino: (context, platform) =>
          CupertinoElevatedButtonData(color: AppColors.primaryUofI),
      material: (context, platform) => MaterialElevatedButtonData(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(AppColors.primaryUofI))),
      onPressed: () => Navigator.push(
        context,
        platformPageRoute(
          context: context,
          builder: (_) => HomeworkListScreen(homework: homework),
        ),
      ),
    );
  }
}
