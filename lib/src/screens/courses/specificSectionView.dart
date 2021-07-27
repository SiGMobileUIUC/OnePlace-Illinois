import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:oneplace_illinois/src/misc/enums.dart';
import 'package:oneplace_illinois/src/models/courseItem.dart';
import 'package:oneplace_illinois/src/models/file.dart';
import 'package:oneplace_illinois/src/models/homeworkItem.dart';
import 'package:oneplace_illinois/src/models/lectureItem.dart';
import 'package:oneplace_illinois/src/models/sectionItem.dart';
import 'package:oneplace_illinois/src/providers/courseApi.dart';
import 'package:oneplace_illinois/src/widgets/homework/homeworkList.dart';
import 'package:oneplace_illinois/src/widgets/lecture/lectureList.dart';
import 'package:oneplace_illinois/src/widgets/sliverView.dart';

class SectionView extends StatefulWidget {
  final CourseAPI _courseAPI = CourseAPI();
  late final String? sectionName;
  late final String? sectionCode;
  late final Future<SectionItem> section;
  late final Future<CourseItem> course;

  SectionView(
      {Key? key,
      String? sectionName,
      String? sectionCode,
      SectionItem? section,
      CourseItem? course})
      : super(key: key) {
    assert(section != null || (sectionName != null && sectionCode != null));

    this.sectionName = sectionName ?? '${course!.title} ${section!.sectionID}';
    this.sectionCode = sectionCode;
    this.section = section != null
        ? Future.value(section)
        : _courseAPI.getSection(sectionCode!);
    this.course = course != null
        ? Future.value(course)
        : _courseAPI
            .getCourses(sectionCode!.split('_')[0])
            .then((items) => items![0]);
  }

  @override
  _SectionViewState createState() => _SectionViewState();
}

class _SectionViewState extends State<SectionView> {
  List<HomeworkItem> homework = [];

  _SectionViewState() {
    // widget.course.then((course) {
    //   homework = [
    //     HomeworkItem(
    //       dueDate: DateTime.now().add(Duration(days: 2)),
    //       name: 'Practice Problems #1',
    //       description: 'This homework will help prepare you for the test!',
    //       assignmentUrl: 'https://example.com',
    //       platform: 'turnitin',
    //       course: course,
    //       files: [
    //         File(
    //           name: 'Problem set.json',
    //           mimeType: 'application/json',
    //           size: 400,
    //           url: 'https://example.com',
    //         ),
    //         File(
    //           name: 'Problem set.json',
    //           mimeType: 'application/json',
    //           size: 400,
    //           url: 'https://example.com',
    //         ),
    //         File(
    //           name: 'Problem set.json',
    //           mimeType: 'application/json',
    //           size: 400,
    //           url: 'https://example.com',
    //         )
    //       ],
    //     ),
    //     HomeworkItem(
    //       name: 'Practice Problems #2',
    //       dueDate: DateTime.now().add(Duration(days: 7)),
    //       assignmentUrl: 'https://en.wikipedia.org/wiki/Hot_air_ballooning',
    //       platform: 'turnitin',
    //       course: course,
    //     )
    //   ];
    // });
  }

  List<Widget> _getDetails(SectionItem section) {
    LinkedList<LectureItem> lectureItems = LinkedList();
    lectureItems.addAll([
      LectureItem(
        lectureUrl: "https://mediaspace.illinois.edu/media/t/1_46ekurb1",
        platform: LecturePlatform.MediaSpace,
        title: "Illustrator Getting Started",
        lectureNumber: 1,
        created: DateTime.now().subtract(Duration(days: 1)),
        author: "Judi Geistlinger",
      ),
      LectureItem(
        lectureUrl: "https://mediaspace.illinois.edu/media/t/1_vz4b8qa1",
        platform: LecturePlatform.MediaSpace,
        title: "Master of Science in Strategic Brand Communication",
        lectureNumber: 2,
        created: DateTime.now().subtract(Duration(days: 1)),
        author: "Kalee Ackerman",
      ),
      LectureItem(
        lectureUrl: "https://mediaspace.illinois.edu/media/t/1_u1jmkwl5",
        platform: LecturePlatform.MediaSpace,
        title: "Ch. 9 and 10 - July 28th Lecture",
        lectureNumber: 28,
        created: DateTime.now().subtract(Duration(days: 1)),
        author: "Blake Johnson",
      ),
    ]);

    return <Widget>[
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        isThreeLine: true,
        title: Text(
          section.sectionNumber,
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
      Divider(
        // color: Colors.grey[500],
        endIndent: 25.0,
        indent: 25.0,
        thickness: 1.5,
      ),
      LectureList(
        lectureItems: lectureItems.toList(),
        courseItem: widget.courseItem,
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 3,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: FutureBuilder(
        future: Future.wait([widget.section, widget.course]),
        initialData: null,
        builder: (context, AsyncSnapshot<List<dynamic>?> snapshot) {
          List<dynamic>? data;
          if (snapshot.hasData) data = snapshot.data;

          if (snapshot.connectionState == ConnectionState.waiting ||
              data == null) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.urbanaOrange,
              ),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            return Center(
              child: Text(error.toString()),
            );
          } else {
            final SectionItem section = data[0];
            final CourseItem course = data[1];
            // return _getDetails(section);
            return SliverView(
              title: widget.sectionName ??
                  '${course.subjectID}-${section.sectionID}',
              children: _getDetails(section),
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
            );
          }
        },
      ),
    );
  }
}
