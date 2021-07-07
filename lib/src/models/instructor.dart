class Instructor {
  /// ns2:section -> meetings -> meeting -> instructors -> instructor -> firstname
  String firstName;

  /// ns2:section -> meetings -> meeting -> instructors -> instructor -> lastname
  String lastName;

  String fullName;

  Instructor(
      {required this.firstName,
      required this.lastName,
      required this.fullName});

  factory Instructor.fromJSON(Map<String, dynamic> json) {
    dynamic instructor = Instructor(
      firstName: json["firstName"],
      lastName: json["lastName"],
      fullName: json["\$t"],
    );
    return instructor;
  }
}
