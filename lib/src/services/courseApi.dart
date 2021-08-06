import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:oneplace_illinois/src/misc/config.dart';
import 'package:oneplace_illinois/src/models/courseItem.dart';
import 'package:oneplace_illinois/src/models/sectionItem.dart';
import 'package:oneplace_illinois/src/services/api.dart';

class CourseAPI {
  Future<List<CourseItem>?> getCourses(ApiService api, String query,
      {bool onlyCourses = false}) async {

    Dio client = await api.getClient();

    // NOTE: only_courses accept boolean (prev was onlyCourses.toString())
    final body = await client.get('/course/search', queryParameters: {
      'keyword': query, 'only_courses': onlyCourses
    });

    List<dynamic> data = body['courses'];
    List<CourseItem> courses =
        data.map((e) => CourseItem.fromJSON(e, onlyCourses)).toList();
    courses.sort((a, b) => a.compareTo([query, b]));
    return courses;
  }

  Future<SectionItem> getSection(ApiService api, String fullCode) async {
    List<String> codeSections = fullCode.split('_');
    String code = codeSections[0];
    String crn = codeSections[1];

    Dio client = await api.getClient();

    final body = await client.get('/section/search', queryParameters: {
      'code': code, 'CRN': crn,
    });

    // Since we provided CRN, only one section is returned
    dynamic data = body['sections'][0];
    SectionItem section = SectionItem.fromJSON(data);
    return section;
  }
}
