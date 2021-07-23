import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oneplace_illinois/src/misc/enums.dart';
import 'package:oneplace_illinois/src/models/courseItem.dart';
import 'package:oneplace_illinois/src/models/file.dart';
import 'package:oneplace_illinois/src/models/homeworkItem.dart';
import 'package:oneplace_illinois/src/models/sectionItem.dart';
import 'package:oneplace_illinois/src/widgets/homework/homeworkList.dart';
import 'package:oneplace_illinois/src/widgets/sliverView.dart';

class SectionView extends StatefulWidget {
  final SectionItem sectionItem;
  final CourseItem courseItem;
  const SectionView(
      {Key? key, required this.sectionItem, required this.courseItem})
      : super(key: key);

  @override
  _SectionViewState createState() => _SectionViewState();
}

class _SectionViewState extends State<SectionView> {
  final CourseItem course = CourseItem(
    year: 2021,
    semester: Semester.Fall,
    semesterID: "fa",
    subject: 'Computer Science',
    subjectID: "CS",
    courseID: 0,
    title: 'Introduction to Computer Science I',
    description:
        'Basic concepts in computing and fundamental techniques for solving computational problems. Intended as a first course for computer science majors and others with a deep interest in computing. Credit is not given for both CS 124 and CS 125. Prerequisite: Three years of high school mathematics or MATH 112.',
    creditHours: '3 hours.',
    courseSectionInformation:
        'Credit is not given for both CS 124 and CS 125. Prerequisite: Three years of high school mathematics or MATH 112.',
    classScheduleInformation: null,
    sections: [],
    categories: [],
  );

  List<Widget> _getDetails(SectionItem? section) {
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

    return <Widget>[
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        isThreeLine: true,
        title: Text(
          section!.sectionNumber,
          style: TextStyle(
            // color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        subtitle: Container(
          padding: EdgeInsets.only(top: 2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      section.enrollmentStatus,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      section.building,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              section.sectionCappArea != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            section.sectionCappArea ?? "",
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
              section.sectionNotes != null
                  ? Container(
                      padding: EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              section.sectionNotes ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
      Divider(
        // color: Colors.grey[500],
        endIndent: 25.0,
        indent: 25.0,
        thickness: 1.5,
      ),
      HomeworkList(
        homework: homework,
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 3,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: SliverView(
        title: "${widget.courseItem.subjectID} ${widget.courseItem.courseID}",
        children: _getDetails(widget.sectionItem),
        titleStyle: TextStyle(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(PlatformIcons(context).addCircledOutline),
            tooltip: "Add course to library.",
          ),
        ],
        leading: null,
      ),
    );
  }
}
