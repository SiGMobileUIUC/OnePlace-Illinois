class SectionItem {
  /// The current year for the section.
  int year;

  /// The current term for the section .
  String term;

  /// The section CRN.
  int crn;

  /// The [course] and [crn] seperated by a `_` which can be used to make an API request.
  String fullCode;

  /// The course for the section; CS124.
  String course;

  /// The section ID for the section; ABA, ABB, AL1, etc.
  String sectionID;

  /// The numerical term the section is in.
  int partOfTerm;

  /// Title of the section, often an empty string.
  String sectionTitle;

  /// The status for the section.
  ///
  /// Should rarely be used, consider using [enrollmentStatus] instead.
  String sectionStatus;

  /// The credit hours for this section.
  String creditHours;

  /// The current enrollment status of the section; Open (Restricted).
  String enrollmentStatus;

  /// The type of lectures the section will have; Online Lecture.
  String type;

  /// The code for [type]; OLC.
  String typeCode;

  /// The start time for the section.
  String startTime;

  /// The end time for the section.
  String endTime;

  /// The days of the week that the section meets.
  ///
  /// Note: This can often be an empty string.
  String daysOfWeek;

  /// The room that the section meets in.
  String room;

  /// The building that the section meets in.
  String building;

  /// List of instructors teaching the section.
  List<String> instructors;

  SectionItem({
    required this.year,
    required this.term,
    required this.crn,
    required this.fullCode,
    required this.course,
    required this.sectionID,
    required this.partOfTerm,
    required this.sectionTitle,
    required this.sectionStatus,
    required this.creditHours,
    required this.enrollmentStatus,
    required this.type,
    required this.typeCode,
    required this.startTime,
    required this.endTime,
    required this.daysOfWeek,
    required this.room,
    required this.building,
    required this.instructors,
  });

  factory SectionItem.fromJSON(Map<String, dynamic> json) {
    dynamic courseSection = SectionItem(
      course: json["course"],
      crn: json["code"],
      sectionID: json["CRN"],
      partOfTerm: int.parse(json["part_of_term"]),
      enrollmentStatus: json["enrollment_status"],
      instructors: json["instructors"].split(";"),
      type: json["type"],
      typeCode: json["type_code"],
      fullCode: json["full_code"],
      daysOfWeek: json["days_of_week"],
      room: json["room"],
      building: json["building"],
      creditHours: json["section_credit_hours"],
      endTime: json["end_time"],
      sectionStatus: json["section_status"],
      sectionTitle: json["section_title"],
      startTime: json["start_time"],
      term: json["term"],
      year: json["year"],
    );
    return courseSection;
  }
}
