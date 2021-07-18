import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:oneplace_illinois/src/models/courseListItem.dart';

class CourseListAPI {
  Client client = Client();
  final endpoint = dotenv.env["BASE_ENDPOINT"];

  Future<List<CourseListItem>?> getCourses(String query) async {
    Uri uri = Uri.http(endpoint!, '/api/v1/course/search', {"keyword": query});
    final response = await client.get(uri);

    if (response.statusCode != 200) {
      print(jsonDecode(response.body)['error']);
      return null;
    }
    List<dynamic> data = jsonDecode(response.body)['courses'];
    List<CourseListItem> courses =
        data.map((e) => CourseListItem.fromJSON(e)).toList();
    List<CourseListItem> queriedCourses = courses
        .where((element) =>
            element.subjectID.toLowerCase() == query.trimLeft().split(" ")[0])
        .toList();
    return queriedCourses.isEmpty ? courses : queriedCourses;
  }
}
