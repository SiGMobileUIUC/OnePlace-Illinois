class CourseListItem {
  int year;
  String term;
  String subjectID;
  String subjectNumber;
  String name;

  CourseListItem({
    required this.year,
    required this.term,
    required this.subjectID,
    required this.subjectNumber,
    required this.name,
  });

  factory CourseListItem.fromJSON(Map<String, dynamic> json) {
    dynamic courseListItem = CourseListItem(
      year: int.parse(json['year']),
      term: json['term'],
      subjectID: json['subjectId'],
      subjectNumber: json['subjectNumber'],
      name: json['name'],
    );
    return courseListItem;
  }
}
