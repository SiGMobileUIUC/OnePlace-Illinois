class SectionItem {
  String course;

  /// ns2:section -> sectionNumber
  String sectionNumber;

  /// ns2:section id
  int sectionID;

  /// ns2:section -> sectionCappArea
  String? sectionCappArea;

  /// ns2:section -> partOfTerm
  String partOfTerm;

  /// ns2:section -> enrollmentStatus
  String enrollmentStatus;

  String? sectionNotes;

  /* /// ns2:section -> startDate
  DateTime startDate;

  /// ns2:section -> endDate
  DateTime endDate; */

  /// ns2:section -> meetings -> meeting -> instructors -> instructor
  List<String> instructors;

  String type;

  String typeCode;

  String fullCode;

  String daysOfWeek;

  String room;

  String building;

  SectionItem({
    required this.course,
    required this.sectionNumber,
    required this.sectionID,
    required this.sectionCappArea,
    required this.partOfTerm,
    required this.enrollmentStatus,
    required this.sectionNotes,
    // required this.startDate,
    // required this.endDate,
    required this.instructors,
    required this.type,
    required this.typeCode,
    required this.fullCode,
    required this.daysOfWeek,
    required this.room,
    required this.building,
  });

  factory SectionItem.fromJSON(Map<String, dynamic> json) {
    /* List<Instructor?> _getInstructor(dynamic json) {
      if (json is List) {
        return json.toList().map((e) => Instructor.fromJSON(e)).toList();
      } else {
        return [];
      }
    } */

    dynamic courseSection = SectionItem(
      course: json["course"],
      sectionNumber: json["code"],
      sectionID: json["CRN"],
      sectionCappArea: json["sectionCappArea"] ?? null,
      partOfTerm: json["part_of_term"],
      enrollmentStatus: json["enrollment_status"],
      sectionNotes: json["sectionNotes"] ?? null,
      // startDate: DateTime.parse(json["start_date"]),
      // endDate: DateTime.parse(json["end_date"]),
      instructors: [json["instructors"]],
      type: json["type"],
      typeCode: json["type_code"],
      fullCode: json["full_code"],
      daysOfWeek: json["days_of_week"],
      room: json["room"],
      building: json["building"],
    );
    return courseSection;
  }
}
