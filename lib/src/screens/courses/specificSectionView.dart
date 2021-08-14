import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oneplace_illinois/src/misc/enums.dart';
import 'package:oneplace_illinois/src/models/file.dart';
import 'package:oneplace_illinois/src/models/homeworkItem.dart';
import 'package:oneplace_illinois/src/models/lectureItem.dart';
import 'package:oneplace_illinois/src/models/sectionItem.dart';
import 'package:oneplace_illinois/src/providers/accountProvider.dart';
import 'package:oneplace_illinois/src/services/homeworkApi.dart';
import 'package:oneplace_illinois/src/widgets/homework/homeworkList.dart';
import 'package:oneplace_illinois/src/widgets/lecture/lectureList.dart';
import 'package:oneplace_illinois/src/widgets/sliverView.dart';
import 'package:provider/provider.dart';

class SectionView extends StatefulWidget {
  final SectionItem sectionItem;
  SectionView({
    Key? key,
    required this.sectionItem,
  }) : super(key: key);

  @override
  _SectionViewState createState() => _SectionViewState();
}

class _SectionViewState extends State<SectionView> {
  List<Widget> _getDetails(SectionItem section) {
    // Only here for now, to make things look seemless, will be removed and replaced witht he homework api
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
          section.sectionID,
          style: TextStyle(
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
                      "Enrollment Status:",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
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
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      "Building:",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      "Lecture Type:",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      section.type,
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      "Instructors:",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      section.instructors[0],
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.grey[500], fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Divider(
        endIndent: 25.0,
        indent: 25.0,
        thickness: 1.5,
      ),
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        isThreeLine: true,
        title: Text(
          "Homework:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        subtitle: HomeworkList(
          homework: homework,
        ),
      ),
      Divider(
        endIndent: 25.0,
        indent: 25.0,
        thickness: 1.5,
      ),
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        isThreeLine: true,
        title: Text(
          "Lectures:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        subtitle: LectureList(
          lectureItems: lectureItems.toList(),
          sectionItem: widget.sectionItem,
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 3,
      ),
    ];
  }

  String _getTitle(String title) {
    int index = title.indexOf(RegExp(r"[0-9]"));
    String name = title.substring(0, index);
    String number = title.substring(index, title.length);
    return "$name $number";
  }

  Widget _addSectionButton(BuildContext context, AccountProvider account) {
    if (!account.sections!
        .map((e) => e.crn)
        .toList()
        .contains(widget.sectionItem.crn)) {
      return IconButton(
        onPressed: () async {
          await account.addSection(widget.sectionItem);
        },
        icon: Icon(PlatformIcons(context).addCircledOutline),
        tooltip: "Add course to library.",
      );
    }
    return IconButton(
      onPressed: () async {
        await account.dropSection(widget.sectionItem);
      },
      icon: Icon(PlatformIcons(context).removeCircledOutline),
      tooltip: "Remove course from library.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: SliverView(
        title: _getTitle(widget.sectionItem.course),
        children: _getDetails(widget.sectionItem),
        titleStyle: TextStyle(
          color: Colors.white,
        ),
        actions: [
          Consumer<AccountProvider>(builder: (context, account, child) {
            return _addSectionButton(context, account);
          }),
        ],
        leading: null,
      ),
    );
  }
}
