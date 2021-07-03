import 'package:oneplace_illinois/src/misc/enums.dart';
import 'package:oneplace_illinois/src/models/courseSectionItem.dart';

class CourseItem {
  /// ns2:section -> parents -> calendarYear id
  int? year;

  /// ns2:section -> parents -> term
  Semester? semester;

  /// ns2:section -> parents -> term id
  int? semesterID;

  /// ns2:section -> parents -> subject
  String subject;

  /// ns2:section -> parents -> subject id
  String subjectID;

  /// ns2:course -> id
  int? courseID;

  /// ns2:section -> course
  String title;

  /// ns2:course -> description
  String description;

  /// ns2:course -> creditHours
  String creditHours;

  /// ns2:course -> courseSectionInformation
  String? courseSectionInformation;

  /// ns2:course -> classScheduleInformation
  String? classScheduleInformation;

  /// ns2:course -> genEdCategories -> category -> description
  String? category;

  CourseSectionItem? courseSectionItem;

  CourseItem({
    required this.year,
    required this.semester,
    required this.semesterID,
    required this.subject,
    required this.subjectID,
    required this.courseID,
    required this.title,
    required this.description,
    required this.creditHours,
    required this.courseSectionInformation,
    required this.classScheduleInformation,
    this.category,
    this.courseSectionItem,
  });

  factory CourseItem.fromJSON(Map<String, dynamic> json) {
    dynamic course = CourseItem(
      year: int.tryParse(json["parents"]["calendarYear"]["id"]),
      semester: Semesters.fromString(json["parents"]["term"]["\$t"].trim()[0]),
      semesterID: int.tryParse(json["parents"]["term"]["id"]),
      subject: json["parents"]["subject"]["\$t"],
      subjectID: json["parents"]["subject"]["id"],
      courseID: int.tryParse(json["id"].trim()[1]),
      title: json["label"]["\$t"],
      description: json["description"]["\$t"],
      creditHours: json["creditHours"]["\$t"],
      courseSectionInformation: json["courseSectionInformation"] != null
          ? json["courseSectionInformation"]["\$t"]
          : null,
      classScheduleInformation: json["classScheduleInformation"] != null
          ? json["classScheduleInformation"]["\$t"]
          : null,
      category: json["genEdCategories"] != null
          ? json["genEdCategories"]["category"]["description"]["\$t"]
          : null,
    );
    return course;
  }
}
