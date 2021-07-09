import 'package:oneplace_illinois/src/misc/enums.dart';

class CourseItem {
  /// ns2:course -> parents -> calendarYear id
  int? year;

  /// ns2:course -> parents -> term
  Semester? semester;

  /// ns2:course -> parents -> term id
  int? semesterID;

  /// ns2:course -> parents -> subject
  String subject;

  /// ns2:course -> parents -> subject id
  String subjectID;

  /// ns2:course -> id
  int? courseID;

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
  List<String> sectionsLinks;

  /// ns2:course -> genEdCategories -> category -> description
  List<String?>? categories;

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
    required this.sectionsLinks,
    this.categories,
  });

  factory CourseItem.fromJSON(Map<String, dynamic> json) {
    List<String> _getSectionsLinks(dynamic sections) {
      if (sections is List) {
        return sections.map((e) => e["href"].toString()).toList();
      } else {
        return [sections["href"].toString()];
      }
    }

    List<String> _getCategories(dynamic json) {
      if (json is List) {
        return json
            .map((e) =>
                e["ns2\$genEdAttributes"]["genEdAttribute"]["\$t"].toString())
            .toList();
      } else {
        return [
          json["ns2\$genEdAttributes"]["genEdAttribute"]["\$t"].toString()
        ];
      }
    }

    dynamic course = CourseItem(
      year: int.tryParse(json["parents"]["calendarYear"]["id"]),
      semester: Semesters.fromString(
          json["parents"]["term"]["\$t"].split(" ")[0].toLowerCase()),
      semesterID: int.tryParse(json["parents"]["term"]["id"]),
      subject: json["parents"]["subject"]["\$t"],
      subjectID: json["parents"]["subject"]["id"],
      courseID: int.tryParse(json["id"].trim()[1]),
      title: json["label"]["\$t"],
      description: json["description"]["\$t"],
      creditHours: json["creditHours"]["\$t"],
      courseSectionInformation: json["courseSectionInformation"]?["\$t"],
      classScheduleInformation: json["classScheduleInformation"]?["\$t"],
      sectionsLinks: _getSectionsLinks(json["sections"]?["section"]),
      categories: _getCategories(json["genEdCategories"]?["category"]),
    );
    return course;
  }
}
