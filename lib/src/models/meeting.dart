class Meeting {
  /// ns2:section -> meetings -> meeting -> id
  int? meetingID;

  /// ns2:section -> meetings -> meeting -> type
  String? type;

  /// ns2:section -> meetings -> meeting -> start
  String? start;

  /// ns2:section -> meetings -> meeting -> end
  String? end;

  /// ns2:section -> meetings -> meeting -> daysOfTheWeek
  String? daysOfTheWeek;

  /// ns2:section -> meetings -> meeting -> roomNumber
  String? roomNumber;

  /// ns2:section -> meetings -> meeting -> buildingName
  String? buildingName;

  Meeting({
    required this.meetingID,
    required this.type,
    required this.start,
    required this.end,
    required this.daysOfTheWeek,
    required this.roomNumber,
    required this.buildingName,
  });

  factory Meeting.fromJSON(Map<String, dynamic> json) {
    dynamic meeting = Meeting(
      meetingID:
          int.tryParse(json["ns2\$section"]["meetings"]["meeting"]["id"]),
      type: json["ns2\$section"]["meetings"]["meeting"]["type"]["\$t"] ?? null,
      start:
          json["ns2\$section"]["meetings"]["meeting"]["start"]["\$t"] ?? null,
      end: json["ns2\$section"]["meetings"]["meeting"]["end"]["\$t"] ?? null,
      daysOfTheWeek: json["ns2\$section"]["meetings"]["meeting"]
              ["daysOfTheWeek"]["\$t"] ??
          null,
      roomNumber: json["ns2\$section"]["meetings"]["meeting"]["roomNumber"]
              ["\$t"] ??
          null,
      buildingName: json["ns2\$section"]["meetings"]["meeting"]["buildingName"]
              ["\$t"] ??
          null,
    );
    return meeting;
  }
}
