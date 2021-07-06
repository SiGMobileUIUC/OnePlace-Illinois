import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:oneplace_illinois/src/misc/enums.dart';
import 'package:oneplace_illinois/src/models/courseItem.dart';
import 'package:oneplace_illinois/src/models/courseListItem.dart';
import 'package:oneplace_illinois/src/providers/courseListApi.dart';
import 'package:oneplace_illinois/src/widgets/alertBox.dart';

class Search extends SearchDelegate<CourseItem> {
  final CourseListAPI _courseListAPI = CourseListAPI();
  final CourseItem emptyCourseItem = CourseItem(
    year: 0,
    semester: Semester.Fall,
    semesterID: 0,
    subject: "",
    subjectID: "",
    courseID: 0,
    title: "",
    description: "",
    creditHours: "",
    courseSectionInformation: "",
    classScheduleInformation: "",
    category: "",
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
        icon: Icon(PlatformIcons(context).search),
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
    return _courseListAPI.getCourses(query);
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _getCourses(),
          builder: (BuildContext context,
              AsyncSnapshot<List<CourseListItem>?> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(
                  child: SpinKitRing(
                    color: AppColors.secondaryUofILight,
                  ),
                );
              case ConnectionState.done:
                if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return AlertBox(
                    child: Text(
                      'No Search results found for $query',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          isThreeLine: true,
                          title: Text(
                            "${snapshot.data![index].subjectID} ${snapshot.data![index].subjectNumber}",
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            snapshot.data![index].name,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                );
            }
          }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}
