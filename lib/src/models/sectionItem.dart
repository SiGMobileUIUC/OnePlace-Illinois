class SectionItem {
  /// The current year for the section.
  ///
  /// Ex: 2021
  int year;

  /// The current term for the section.
  ///
  /// Ex: "fall"
  String term;

  /// The section CRN.
  ///
  /// Ex: 74477
  int crn;

  /// The course for the section.
  ///
  /// Ex: "CS124"
  String course;

  /// The section ID for the section.
  ///
  /// Ex: "AL1"
  String sectionID;

  /// The numerical term the section is in.
  ///
  /// Ex: "A"
  String partOfTerm;

  /// Title of the section.
  ///
  /// Note: often an empty string.
  String sectionTitle;

  /// The status for the section.
  ///
  /// Should rarely be used, consider using [enrollmentStatus] instead.
  String sectionStatus;

  /// The credit hours for this section.
  String creditHours;

  /// The current enrollment status of the section; Open (Restricted).
  ///
  /// Ex: "Open"
  String enrollmentStatus;

  /// The type of lectures the section will have.
  ///
  /// Ex: "Online Lecture"
  String type;

  /// The code for [type].
  ///
  /// Ex: "OLC"
  String typeCode;

  /// The start time for the section.
  ///
  /// Ex: "ARRANGED", "10:00 AM"
  String startTime;

  /// The end time for the section.
  ///
  /// Ex: "10:50 AM"
  String endTime;

  /// The days of the week that the section meets.
  ///
  /// Ex: "T"
  ///
  /// Note: This can often be an empty string.
  String daysOfWeek;

  /// The room that the section meets in.
  ///
  /// Ex: "2310"
  ///
  /// Note: This can often be an empty string.
  String room;

  /// The building that the section meets in.
  ///
  /// Ex: "Krannert Center for Perf Arts"
  /// Note: This can often be an empty string.
  String building;

  /// List of instructors teaching the section.
  ///
  /// Ex: "Challen, G;Lewis, C"
  List<String> instructors;

  SectionItem({
    required this.year,
    required this.term,
    required this.crn,
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
    required this.course,
  });

  factory SectionItem.fromJSON(Map<String, dynamic> json) {
    dynamic courseSection = SectionItem(
      course: json["course"] ?? "",
      crn: json["CRN"],
      sectionID: json["code"],
      partOfTerm: json["partOfTerm"],
      enrollmentStatus: json["enrollmentStatus"],
      instructors: json["instructors"].split(";"),
      type: json["type"],
      typeCode: json["typeCode"],
      daysOfWeek: json["daysOfWeek"],
      room: json["room"],
      building: json["building"],
      creditHours: json["sectionCreditHours"],
      endTime: json["endTime"],
      sectionStatus: json["sectionStatus"],
      sectionTitle: json["sectionTitle"],
      startTime: json["startTime"],
      term: json["term"],
      year: json["year"],
    );
    return courseSection;
  }
}
