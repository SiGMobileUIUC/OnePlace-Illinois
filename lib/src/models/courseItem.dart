import 'package:oneplace_illinois/src/misc/enums.dart';
import 'package:oneplace_illinois/src/models/sectionItem.dart';

class CourseItem implements Comparable {
  /// ns2:course -> parents -> calendarYear id
  int year;

  /// ns2:course -> parents -> term
  Semester semester;

  /// ns2:course -> parents -> term id
  String semesterID;

  /// ns2:course -> parents -> subject
  String subject;

  /// ns2:course -> parents -> subject id
  String subjectID;

  /// ns2:course -> id
  int courseID;

  /// ns2:course -> label
  String title;

  /// ns2:course -> description
  String description;

  /// ns2:course -> creditHours
  String creditHours;

  /// ns2:course -> courseSectionInformation
  String? courseSectionInformation;

  /// ns2:course -> classScheduleInformation
  String? classScheduleInformation;

  /// ns2:course -> sections
  List<SectionItem> sections;

  /// ns2:course -> genEdCategories -> category -> description
  List<String> categories;

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
    required this.sections,
    required this.categories,
  });

  factory CourseItem.fromJSON(Map<String, dynamic> json, bool onlyCourses) {
    Semesters _sem = Semesters();

    List<SectionItem> _getSections(List<dynamic> list) {
      List<SectionItem> sections =
          list.map((e) => SectionItem.fromJSON(e)).toList();
      return sections;
    }

    dynamic course = CourseItem(
      year: json["year"],
      semester: _sem.fromString(json["semester"]),
      semesterID: json["semesterID"].toString(),
      subject: json["subject"],
      subjectID: json["subjectId"],
      courseID: json["courseId"],
      title: json["name"],
      description: json["description"],
      creditHours: json["creditHours"],
      courseSectionInformation: json["courseSectionInformation"] ?? null,
      classScheduleInformation: json["classScheduleInformation"] ?? null,
      sections: _getSections(json["sections"]),
      categories: List<String>.from(json["genEd"]),
    );
    return course;
  }

  @override
  int compareTo(dynamic list) {
    String query = list[0];
    CourseItem other = list[1];
    if (this.subjectID.toLowerCase() == query.trimLeft().split(" ")[0] &&
        other.subjectID.toLowerCase() == query.trimLeft().split(" ")[0]) {
      if (this.courseID < other.courseID) {
        return -1;
      }
      if (this.courseID == other.courseID) {
        return 0;
      }
      if (this.courseID > other.courseID) {
        return 1;
      }
    }

    if (this.subjectID.toLowerCase() == query.trimLeft().split(" ")[0] &&
        other.subjectID.toLowerCase() != query.trimLeft().split(" ")[0]) {
      return -1;
    }

    if (this.subjectID.toLowerCase() != query.trimLeft().split(" ")[0] &&
        other.subjectID.toLowerCase() == query.trimLeft().split(" ")[0]) {
      return 1;
    }

    if (this.subjectID.toLowerCase() != query.trimLeft().split(" ")[0] &&
        other.subjectID.toLowerCase() != query.trimLeft().split(" ")[0]) {
      return 0;
    }
    return 0;
  }
}
