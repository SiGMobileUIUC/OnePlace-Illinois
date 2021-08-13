import 'package:oneplace_illinois/src/misc/enums.dart';
import 'package:oneplace_illinois/src/models/sectionItem.dart';

class CourseItem implements Comparable {
  /// The current year for the course.
  ///
  /// Ex: 2021
  int year;

  /// The semester for this course.
  ///
  /// Ex: "fall"
  Semester semester;

  /// The subject this course is a part of.
  ///
  /// Ex: "Computer Science"
  String subject;

  /// Shortened ID for the subject.
  ///
  /// Ex: "CS"
  String subjectID;

  /// The number for this course.
  ///
  /// Ex: 124
  int courseID;

  /// The title/name of the course.
  ///
  /// Ex: "Introduction to Computer Science I"
  String title;

  /// The description about the course
  ///
  /// Ex: "Basic concepts in computing and fundamental techniques for solving computational problems. Intended as a first course for computer science majors and others with a deep interest in computing. Credit is not given for both CS 124 and CS 125. Prerequisite: Three years of high school mathematics or MATH 112."
  String description;

  /// The credit hours for the course.
  ///
  /// Ex: "3 hours."
  String creditHours;

  /// Any information about the course sections.
  ///
  /// Ex: "Credit is not given for both CS 124 and CS 125. Prerequisite: Three years of high school mathematics or MATH 112."
  String? courseSectionInformation;

  /// Any information about the course schedule.
  ///
  /// Ex: "Open only to students who have passed a qualifying audition. Non-music majors will be assessed a fee."
  String? classScheduleInformation;

  /// List of sections for this course.
  ///
  /// Note: It can sometimes be an empty list if the API does not return the sections.
  List<SectionItem> sections;

  /// List of general education categories for this course.
  ///
  /// Note: It can sometimes be an empty list if there are no general education categories.
  List<String> categories;

  /// The [subjectID] and [courseID] combined together.
  ///
  /// Ex: "CS124"
  String fullCode;

  CourseItem({
    required this.year,
    required this.semester,
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
    required this.fullCode,
  });

  factory CourseItem.fromJSON(Map<String, dynamic> json, bool onlyCourses) {
    Semesters _sem = Semesters();

    List<SectionItem> _getSections(json) {
      List<dynamic> list = json["sections"] ?? [];
      if (list == []) {
        return [];
      }
      List<SectionItem> sections =
          list.map((e) => SectionItem.fromJSON(e)).toList();
      return sections;
    }

    dynamic course = CourseItem(
      year: json["year"],
      semester: _sem.fromString(json["semester"]),
      subject: json["subject"],
      subjectID: json["subjectId"],
      courseID: json["courseId"],
      title: json["name"],
      description: json["description"],
      creditHours: json["creditHours"],
      courseSectionInformation: json["courseSectionInformation"] ?? null,
      classScheduleInformation: json["classScheduleInformation"] ?? null,
      sections: _getSections(json),
      categories: List<String>.from(json["genEd"]),
      fullCode: json["fullCode"] ?? "${json['subjectId']}${json['courseId']}",
    );
    return course;
  }

  @override
  int compareTo(dynamic list) {
    String query = list[0];
    CourseItem other = list[1];
    if (this.subjectID.toLowerCase() ==
            query.trimLeft().split(" ")[0].toLowerCase() &&
        other.subjectID.toLowerCase() ==
            query.trimLeft().split(" ")[0].toLowerCase()) {
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

    if (this.subjectID.toLowerCase() ==
            query.trimLeft().split(" ")[0].toLowerCase() &&
        other.subjectID.toLowerCase() !=
            query.trimLeft().split(" ")[0].toLowerCase()) {
      return -1;
    }

    if (this.subjectID.toLowerCase() !=
            query.trimLeft().split(" ")[0].toLowerCase() &&
        other.subjectID.toLowerCase() ==
            query.trimLeft().split(" ")[0].toLowerCase()) {
      return 1;
    }

    if (this.subjectID.toLowerCase() != query.trimLeft().split(" ")[0] &&
        other.subjectID.toLowerCase() != query.trimLeft().split(" ")[0]) {
      return 0;
    }
    return 0;
  }
}
