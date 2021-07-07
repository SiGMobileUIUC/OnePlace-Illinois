import 'package:oneplace_illinois/src/models/instructor.dart';
import 'package:oneplace_illinois/src/models/meeting.dart';

class CourseSectionItem {
  /// ns2:section -> sectionNumber
  String sectionNumber;

  /// ns2:section id
  int? sectionID;

  /// ns2:section -> sectionCappArea
  String? sectionCappArea;

  /// ns2:section -> partOfTerm
  String partOfTerm;

  /// ns2:section -> enrollmentStatus
  String enrollmentStatus;

  /// ns2:section -> startDate
  DateTime startDate;

  /// ns2:section -> endDate
  DateTime endDate;

  /// ns2:section -> meetings -> meeting -> instructors -> instructor
  Instructor? instructor;

  /// ns2:section -> meetings
  Meeting meeting;

  /// ns2:section -> parents -> course -> id
  int? courseID;

  CourseSectionItem({
    required this.sectionNumber,
    required this.sectionID,
    required this.sectionCappArea,
    required this.partOfTerm,
    required this.enrollmentStatus,
    required this.startDate,
    required this.endDate,
    required this.instructor,
    required this.meeting,
    required this.courseID,
  });

  factory CourseSectionItem.fromJSON(Map<String, dynamic> json) {
    dynamic courseSection = CourseSectionItem(
      sectionNumber: json["sectionNumber"],
      sectionID: int.tryParse(json["id"]),
      sectionCappArea: json["sectionCappArea"]?["\$t"],
      partOfTerm: json["partOfTerm"]["\$t"],
      enrollmentStatus: json["enrollmentStatus"]["\$t"],
      startDate: json["startDate"]["\$t"],
      endDate: json["endDate"]["\$t"],
      instructor: Instructor.fromJSON(json),
      meeting: Meeting.fromJSON(json),
      courseID: int.tryParse(json["parents"]["course"]["id"]),
    );
    return courseSection;
  }
}
