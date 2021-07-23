import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:oneplace_illinois/src/misc/enums.dart';
import 'package:oneplace_illinois/src/models/courseItem.dart';

import 'package:oneplace_illinois/src/providers/courseApi.dart';
import 'package:oneplace_illinois/src/screens/courses/specificCourseView.dart';
import 'package:oneplace_illinois/src/widgets/alertBox.dart';

class Search extends SearchDelegate<CourseItem> {
  List<CourseItem>? _courses = [];
  final CourseAPI _courseAPI = CourseAPI();
  // final CourseExplorerApi _courseExplorerApi = CourseExplorerApi();
  final CourseItem emptyCourseItem = CourseItem(
    year: 0,
    semester: Semester.Fall,
    semesterID: "0",
    subject: "",
    subjectID: "",
    courseID: 0,
    title: "",
    description: "",
    creditHours: "",
    courseSectionInformation: "",
    classScheduleInformation: "",
    sections: [],
    categories: [""],
  );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
        textTheme: TextTheme(
            headline6: TextStyle(
      color: Colors.white,
      fontSize: Theme.of(context).textTheme.headline6!.fontSize,
    )));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(PlatformIcons(context).clear),
        onPressed: () {
          query = '';
        },
      ),
      IconButton(
        icon: Icon(
          PlatformIcons(context).search,
        ),
        onPressed: () {
          showResults(context);
        },
      ),
      // _buildSearchSort(),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(PlatformIcons(context).back),
      onPressed: () {
        close(
          context,
          emptyCourseItem,
        );
      },
    );
  }

  _getCourses() {
    return _courseAPI.getCourses(query, false);
  }

  /* Future<CourseItem?> _getCourse(CourseListItem courseListItem) async {
    CourseItem? course = await _courseExplorerApi.getCourse(courseListItem);
    return course;
  } */

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _getCourses(),
          builder: (BuildContext context,
              AsyncSnapshot<List<CourseItem>?> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(
                  child: SpinKitRing(
                    color: AppColors.secondaryUofILightest,
                  ),
                );
              case ConnectionState.done:
                if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return query != ""
                      ? AlertBox(
                          child: Text(
                            'No Search results found for $query',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Container();
                }
                _courses = snapshot.data;
                return ListView.builder(
                  padding: EdgeInsets.all(5.0),
                  itemCount: _courses!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? Colors.grey[900]
                          : Colors.grey[350],
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        isThreeLine: true,
                        title: Text(
                          "${_courses![index].subjectID} ${_courses![index].courseID}",
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  color: MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          _courses![index].title,
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                color:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (context) {
                                return CourseView(
                                  course: _courses![index],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
            }
          }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
