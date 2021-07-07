class Instructor {
  /// ns2:section -> meetings -> meeting -> instructors -> instructor -> firstname
  String? firstname;

  /// ns2:section -> meetings -> meeting -> instructors -> instructor -> lastname
  String? lastname;

  Instructor({required this.firstname, required this.lastname});

  factory Instructor.fromJSON(Map<String, dynamic> json) {
    dynamic instructor = Instructor(
        firstname: json["meetings"]["meeting"]["instructors"]?["instructor"]
            ["firstname"],
        lastname: json["meetings"]["meeting"]["instructors"]?["instructor"]
            ["lastName"]);
    return instructor;
  }
}
