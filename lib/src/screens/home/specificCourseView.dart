import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:oneplace_illinois/src/models/courseItem.dart';
import 'package:oneplace_illinois/src/misc/enums.dart';
import 'package:oneplace_illinois/src/models/courseSectionItem.dart';

/*
Main page for the Feed tab, will add more details later.
*/

class CourseView extends StatefulWidget {
  final CourseItem course;
  const CourseView(CourseItem courseItem, {Key? key, required this.course})
      : super(key: key);

  @override
  _CourseViewState createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
  @override
  Widget build(BuildContext context) {
    String? year = widget.course.year.toString();
    String? semester = widget.course.semester.toString();
    String? semesterID = widget.course.semesterID.toString();
    String? subject = widget.course.subject.toString();
    String? subjectID = widget.course.subjectID.toString();
    String? courseID = widget.course.courseID.toString();
    String? title = widget.course.title.toString();
    String? description = widget.course.description.toString();
    String? creditHours = widget.course.creditHours.toString();
    String? courseSectionInformation =
        widget.course.courseSectionInformation.toString();
    String? classScheduleInformation =
        widget.course.classScheduleInformation.toString();
    String? category = widget.course.category.toString();

    String? courseSectionItem = widget.course.courseSectionItem.toString();
    // String? section = courseSectionItem.section.toString();
    // String? sectionID = courseSectionItem.sectionID.toString();
    // String? instructor = courseSectionItem.instructor.toString();
    // String? meeting = courseSectionItem.meeting.toString();

    final List<String> entries = <String>[
      year,
      semester,
      semesterID,
      subject,
      subjectID,
      courseID,
      title,
      description,
      creditHours,
      courseSectionInformation,
      classScheduleInformation,
      category,
      courseSectionItem,
    ];

    return MaterialApp(
        home: PlatformScaffold(
            appBar: PlatformAppBar(
              backgroundColor: AppColors.secondaryUofIDark,
              title: Text(
                entries[6],
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    height: 50,
                    color: Colors.white,
                    child: Card(
                        child: Center(child: Text(' ${entries[index]}')),
                        color: Colors.orange[600]));
              },
            )));
  }
}
