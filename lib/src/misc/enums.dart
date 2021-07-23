import 'package:oneplace_illinois/src/providers/courseExplorerApi.dart';

enum Semester { Fall, Winter, Spring, Summer }

class Semesters {
  CourseExplorerApi _api = CourseExplorerApi();
  String toStr(Semester semester) {
    switch (semester) {
      case Semester.Fall:
        return "Fall";
      case Semester.Winter:
        return "Winter";
      case Semester.Spring:
        return "Spring";
      case Semester.Summer:
        return "Summer";
    }
  }

  Semester fromString(String semester) {
    switch (semester) {
      case "fall":
        return Semester.Fall;
      case "winter":
        return Semester.Winter;
      case "spring":
        return Semester.Spring;
      case "summer":
        return Semester.Summer;
    }
    return fromString(_api.getSemester(DateTime.now()).toString());
  }
}
