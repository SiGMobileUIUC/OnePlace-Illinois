import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:oneplace_illinois/src/misc/config.dart';
import 'package:oneplace_illinois/src/models/courseItem.dart';
import 'package:oneplace_illinois/src/models/sectionItem.dart';

class CourseAPI {
  final Dio dio = Dio();

  Future<List<CourseItem>?> getCourses(String query,
      {bool onlyCourses = false}) async {
    Uri uri = Uri.http(Config.baseEndpoint!, '/api/v1/course/search',
        {"keyword": query, "only_courses": onlyCourses.toString()});
    dio.interceptors.add(
      DioCacheManager(
        CacheConfig(
          baseUrl: Config.baseEndpoint!,
          defaultMaxAge: Duration(
            days: 1,
          ),
        ),
      ).interceptor,
    );
    final response = await dio.getUri(uri);

    if (response.statusCode != 200) {
      print(response.data['error']);
      return null;
    }
    List<dynamic> data = response.data["payload"]['courses'];

    List<CourseItem> courses =
        data.map((e) => CourseItem.fromJSON(e, onlyCourses)).toList();
    courses.sort((a, b) => a.compareTo([query, b]));
    return courses;
  }

  Future<SectionItem> getSection(String fullCode) async {
    List<String> codeSections = fullCode.split('_');
    String code = codeSections[0];
    String crn = codeSections[1];
    Uri uri = Uri.http(Config.baseEndpoint!, '/api/v1/section/search',
        {'code': code, 'CRN': crn});
    final response = await dio.getUri(uri);

    if (response.statusCode != 200) {
      throw HttpException(response.statusCode.toString());
    }

    dynamic data = response.data['payload']['sections'][0];

    SectionItem section = SectionItem.fromJSON(data);
    return section;
  }
}
