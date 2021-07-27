import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:oneplace_illinois/src/misc/config.dart';
import 'package:oneplace_illinois/src/models/courseItem.dart';
import 'package:oneplace_illinois/src/models/sectionItem.dart';
import 'package:oneplace_illinois/src/services/api.dart';

class CourseAPI {
  Future<List<CourseItem>?> getCourses(ApiService api, String query,
      {bool onlyCourses = false}) async {
    Uri uri = Uri.http(Config.baseEndpoint!, '/api/v1/course/search',
        {"keyword": query, "only_courses": onlyCourses.toString()});
    final response = await api.get(uri);

    if (response.statusCode != 200) {
      throw HttpException(
          response.reasonPhrase ?? response.statusCode.toString());
    }
    List<dynamic> data = jsonDecode(response.body)['courses'];
    List<CourseItem> courses =
        data.map((e) => CourseItem.fromJSON(e, onlyCourses)).toList();
    courses.sort((a, b) => a.compareTo([query, b]));
    return courses;
  }

  Future<SectionItem> getSection(ApiService api, String fullCode) async {
    List<String> codeSections = fullCode.split('_');
    String code = codeSections[0] + codeSections[1];
    int crn = int.parse(codeSections[2]);
    Uri uri = Uri.http(Config.baseEndpoint!, '/api/v1/section/search',
        {'code': code, 'CRN': crn.toString()});

    final response = await api.get(uri);
    if (response.statusCode != 200) {
      throw HttpException(
          response.reasonPhrase ?? response.statusCode.toString());
    }

    dynamic data = jsonDecode(response.body)['sections'][0];
    SectionItem section = SectionItem.fromJSON(data);
    return section;
  }
}
