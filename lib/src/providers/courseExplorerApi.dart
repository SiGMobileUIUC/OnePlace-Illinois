import 'dart:convert';

import 'package:http/http.dart';
import 'package:oneplace_illinois/src/models/courseItem.dart';
import 'package:oneplace_illinois/src/models/courseListItem.dart';
import 'package:xml2json/xml2json.dart';

class CourseExplorerApi {
  Client client = Client();
  final String _authority = "courses.illinois.edu";
  final Xml2Json xml2json = Xml2Json();

  String? getSemester(DateTime dateTime) {
    if (DateTime(dateTime.year, DateTime.january, 15).isBefore(dateTime) &&
        DateTime(dateTime.year, DateTime.may, 15).isAfter(dateTime)) {
      return "spring";
    } else if (DateTime(dateTime.year, DateTime.may, 15).isBefore(dateTime) &&
        DateTime(dateTime.year, DateTime.august, 15).isAfter(dateTime)) {
      return "summer";
    } else if (DateTime(dateTime.year, DateTime.august, 15)
            .isBefore(dateTime) &&
        DateTime(dateTime.year, DateTime.december, 15).isAfter(dateTime)) {
      return "fall";
    } else if (DateTime(dateTime.year, DateTime.december, 15)
            .isBefore(dateTime) &&
        DateTime(dateTime.year, DateTime.january, 15).isAfter(dateTime)) {
      return "winter";
    }
  }

  Future<CourseItem?> getCourse(CourseListItem courseListItem) async {
    Uri uri = Uri.https(_authority,
        "/cisapp/explorer/schedule/${courseListItem.year}/${courseListItem.term}/${courseListItem.subjectID}/${courseListItem.subjectNumber}.xml");
    final response = await client.get(uri);

    if (response.statusCode != 200) {
      return null;
    }
    xml2json.parse(response.body);
    String data = xml2json.toGData();
    dynamic json = jsonDecode(data);
    CourseItem courseItem = CourseItem.fromJSON(json["ns2\$course"]);
    return courseItem;
  }
}
