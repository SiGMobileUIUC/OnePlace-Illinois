import 'package:oneplace_illinois/src/models/instructor.dart';
import 'package:oneplace_illinois/src/models/meeting.dart';

class SectionItem {
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

  String? sectionNotes;

  /// ns2:section -> startDate
  DateTime startDate;

  /// ns2:section -> endDate
  DateTime endDate;

  /// ns2:section -> meetings -> meeting -> instructors -> instructor
  List<Instructor?> instructors;

  /// ns2:section -> meetings
  Meeting? meeting;

  /// ns2:section -> parents -> course -> id
  int? courseID;

  SectionItem({
    required this.sectionNumber,
    required this.sectionID,
    required this.sectionCappArea,
    required this.partOfTerm,
    required this.enrollmentStatus,
    required this.sectionNotes,
    required this.startDate,
    required this.endDate,
    required this.instructors,
    required this.meeting,
    required this.courseID,
  });

  factory SectionItem.fromJSON(Map<String, dynamic> json) {
    List<Instructor?> _getInstructor(dynamic json) {
      if (json is List) {
        return json.toList().map((e) => Instructor.fromJSON(e)).toList();
      } else {
        return [];
      }
    }

    dynamic courseSection = SectionItem(
      sectionNumber: json["sectionNumber"]?["\$t"],
      sectionID: int.tryParse(json["id"]),
      sectionCappArea: json["sectionCappArea"]?["\$t"],
      partOfTerm: json["partOfTerm"]["\$t"],
      enrollmentStatus: json["enrollmentStatus"]["\$t"],
      sectionNotes: json["sectionNotes"]?["\$t"],
      startDate: DateTime.parse(json["startDate"]["\$t"].split("Z")[0]),
      endDate: DateTime.parse(json["endDate"]["\$t"].split("Z")[0]),
      instructors: _getInstructor(
          json["meetings"]?["meeting"]?["instructors"]?["instructor"]),
      meeting: Meeting.fromJSON(json),
      courseID: int.tryParse(json["parents"]["course"]["id"]),
    );
    return courseSection;
  }
}
