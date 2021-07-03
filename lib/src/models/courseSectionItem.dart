import 'package:oneplace_illinois/src/models/instructor.dart';
import 'package:oneplace_illinois/src/models/meeting.dart';

class CourseSectionItem {
  /// ns2:section -> sectionNumber
  String section;

  /// ns2:section id
  int? sectionID;

  /// ns2:section -> meetings -> meeting -> instructors -> instructor
  Instructor? instructor;

  /// ns2:section -> meetings
  Meeting meeting;

  /// ns2:section -> parents -> course -> id
  int? courseID;

  CourseSectionItem({
    required this.section,
    required this.sectionID,
    required this.instructor,
    required this.meeting,
    required this.courseID,
  });

  factory CourseSectionItem.fromJSON(Map<String, dynamic> json) {
    dynamic courseSection = CourseSectionItem(
      section: json["ns2\$section"]["sectionNumber"],
      sectionID: int.tryParse(json["ns2\$section"]["id"]),
      instructor: Instructor.fromJSON(json),
      meeting: Meeting.fromJSON(json),
      courseID: int.tryParse(json["ns2\$section"]["parents"]["course"]["id"]),
    );
    return courseSection;
  }
}
