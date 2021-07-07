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
      meetingID: int.tryParse(json["meetings"]?["meeting"]?["id"]),
      type: json["meetings"]?["meeting"]?["type"]?["\$t"],
      start: json["meetings"]?["meeting"]?["start"]?["\$t"],
      end: json["meetings"]?["meeting"]?["end"]?["\$t"] ?? null,
      daysOfTheWeek:
          json["meetings"]?["meeting"]?["daysOfTheWeek"]?["\$t"] ?? null,
      roomNumber: json["meetings"]?["meeting"]?["roomNumber"]?["\$t"] ?? null,
      buildingName:
          json["meetings"]?["meeting"]?["buildingName"]?["\$t"] ?? null,
    );
    return meeting;
  }
}
