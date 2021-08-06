import 'dart:convert';

import 'package:http/http.dart';
import 'package:oneplace_illinois/src/misc/config.dart';
import 'package:oneplace_illinois/src/models/courseItem.dart';

class CourseAPI {
  Client client = Client();

  Future<List<CourseItem>?> getCourses(String query, bool onlyCourses) async {
    Uri uri = Uri.http(Config.baseEndpoint!, '/api/v1/course/search',
        {"keyword": query, "only_courses": onlyCourses.toString()});
    final response = await client.get(uri);

    if (response.statusCode != 200) {
      print(jsonDecode(response.body)['error']);
      return null;
    }
    List<dynamic> data = jsonDecode(response.body)['courses'];
    List<CourseItem> courses =
        data.map((e) => CourseItem.fromJSON(e, onlyCourses)).toList();
    courses.sort((a, b) => a.compareTo([query, b]));
    return courses;
  }
}
