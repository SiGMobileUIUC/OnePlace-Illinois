import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oneplace_illinois/src/misc/enums.dart';
import 'package:oneplace_illinois/src/models/courseItem.dart';
import 'package:oneplace_illinois/src/screens/courses/specificSectionView.dart';
import 'package:oneplace_illinois/src/widgets/sliverView.dart';

class CourseView extends StatefulWidget {
  final CourseItem course;
  const CourseView({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  _CourseViewState createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
  final Semesters _sem = Semesters();

  List<Widget> _getDetails(CourseItem course) {
    return <Widget>[
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        isThreeLine: true,
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            course.title,
            style: TextStyle(
              // color: Colors.black,
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
                          color: Colors.grey[500], fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      "${_sem.toStr(course.semester)} ${course.year}",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.grey[500], fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      course.creditHours,
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
        // color: Colors.grey[500],
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
                "Description:",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      // color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Text(
              course.description,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    // color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
      Divider(
        // color: Colors.grey[500],
        endIndent: 25.0,
        indent: 25.0,
        thickness: 1.5,
      ),
      buildCategories(course),
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
                            // color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Text(
                    course.classScheduleInformation.toString(),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          // color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Divider(
                    // color: Colors.grey[500],
                    endIndent: 25.0,
                    indent: 25.0,
                    thickness: 1.5,
                  ),
                ],
              ),
            )
          : SizedBox(),
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 5.0),
              child: Text(
                "Course Section Information:",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      // color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Text(
              course.courseSectionInformation.toString(),
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    // color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
      Divider(
        // color: Colors.grey[500],
        endIndent: 25.0,
        indent: 25.0,
        thickness: 1.5,
      ),
      Container(
        padding: EdgeInsets.only(top: 10.0),
        child: Text(
          "Sections:",
          style: Theme.of(context).textTheme.headline6!.copyWith(
                // color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
        ),
      ),
      _buildSections(course),
      SizedBox(
        height: MediaQuery.of(context).size.height / 3,
      ),
    ];
  }

  /* _getSection(CourseItem? courseItem) {
    return _courseExplorerApi.getSections(courseItem!.sections);
  } */

  Widget buildCategories(CourseItem courseItem) {
    if (courseItem.categories.isNotEmpty &&
        courseItem.categories[0].isNotEmpty) {
      return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 5.0),
              child: Text(
                "General Education Categories:",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      // color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              itemCount: courseItem.categories.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return courseItem.categories[index].isNotEmpty
                    ? Text(
                        courseItem.categories[index],
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              // color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                      )
                    : SizedBox();
              },
            ),
            Divider(
              // color: Colors.grey[500],
              endIndent: 25.0,
              indent: 25.0,
              thickness: 1.5,
            ),
          ],
        ),
      );
    }
    return SizedBox();
  }

  Widget _buildSections(CourseItem courseItem) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
      child: ListView.builder(
        itemCount: courseItem.sections.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, index) {
          return Card(
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.grey[300],
            child: ListTile(
              // onTap: () {
              //   Navigator.of(context, rootNavigator: true).push(
              //     CupertinoPageRoute(
              //       builder: (context) {
              //         return SectionView(
              //           sectionName: courseItem,
              //           sectionId: courseItem.sections[index].sectionID,
              //         );
              //       },
              //     ),
              //   );
              // },
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              isThreeLine: true,
              title: Text(
                courseItem.sections[index].sectionNumber,
                style: TextStyle(
                  // color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
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
                            courseItem.sections[index].enrollmentStatus,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            courseItem.sections[index].type.trim(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            courseItem.sections[index].instructors.isEmpty
                                ? ""
                                : courseItem.sections[index].instructors[0],
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                        /* Container(
                          // padding: EdgeInsets.all(2.0),
                          child: Text(
                            "${DateFormat.MEd().format(courseItem.sections[index].startDate)} - ${DateFormat.MEd().format(courseItem.sections[index].endDate)}",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold),
                          ),
                        ), */
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: SliverView(
        title: "${widget.course.subjectID} ${widget.course.courseID}",
        children: _getDetails(widget.course),
        titleStyle: TextStyle(
          color: Colors.white,
        ),
        actions: [],
        leading: null,
      ),
    );
  }
}
