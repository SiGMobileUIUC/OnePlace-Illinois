import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:oneplace_illinois/src/misc/enums.dart';
import 'package:oneplace_illinois/src/models/courseItem.dart';
import 'package:oneplace_illinois/src/models/courseListItem.dart';
import 'package:oneplace_illinois/src/widgets/alertBox.dart';
import 'package:oneplace_illinois/src/widgets/sliverView.dart';

/*
Main page for the Feed tab, will add more details later.
*/

class CourseView extends StatefulWidget {
  final Future<CourseItem?> course;
  final CourseListItem courseListItem;
  const CourseView({
    Key? key,
    required this.course,
    required this.courseListItem,
  }) : super(key: key);

  @override
  _CourseViewState createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
  List<Widget> _getDetails(CourseItem? course) {
    return <Widget>[
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        isThreeLine: true,
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            course!.title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
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
                      course.subject,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.grey[700], fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      "${Semesters.toStr(course.semester)} ${course.year}",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.grey[700], fontWeight: FontWeight.bold),
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
                      course.creditHours,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.grey[700], fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      course.category ?? "",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.grey[700], fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Divider(
        color: Colors.grey[700],
        endIndent: 25.0,
        indent: 25.0,
        thickness: 1.5,
      ),
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 5.0),
              child: Text(
                "Description",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              course.description,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      course.classScheduleInformation != null
          ? Divider(
              color: Colors.grey[700],
              endIndent: 25.0,
              indent: 25.0,
              thickness: 1.5,
            )
          : SizedBox(),
      course.classScheduleInformation != null
          ? ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      "Class Schedule Information:",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    course.classScheduleInformation.toString(),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ))
          : SizedBox(),
      course.courseSectionInformation != null
          ? Divider(
              color: Colors.grey[700],
              endIndent: 25.0,
              indent: 25.0,
              thickness: 1.5,
            )
          : SizedBox(),
      course.courseSectionInformation != null
          ? ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      "Course Section Information:",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    course.courseSectionInformation.toString(),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ))
          : SizedBox(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: FutureBuilder(
        future: widget.course,
        builder: (BuildContext context, AsyncSnapshot<CourseItem?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return SliverView(
                title:
                    "${widget.courseListItem.subjectID} ${widget.courseListItem.subjectNumber}",
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: SpinKitRing(
                      color: AppColors.secondaryUofILight,
                    ),
                  ),
                ],
                titleStyle: TextStyle(
                  color: Colors.white,
                ),
              );
            case ConnectionState.done:
              if (!snapshot.hasData || snapshot.data == null) {
                return AlertBox(
                  child: Text(
                    'Error loading details about this course.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return SliverView(
                title:
                    "${widget.courseListItem.subjectID} ${widget.courseListItem.subjectNumber}",
                children: _getDetails(snapshot.data),
                titleStyle: TextStyle(
                  color: Colors.white,
                ),
              );
          }
        },
      ),
    );
  }
}
