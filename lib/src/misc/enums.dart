enum Semester { Fall, Winter, Spring, Summer }

class Semesters {
  static String toStr(Semester? semester) {
    switch (semester) {
      case Semester.Fall:
        return "Fall";
      case Semester.Winter:
        return "Winter";
      case Semester.Spring:
        return "Spring";
      case Semester.Summer:
        return "Summer";
      case null:
        return "";
    }
  }

  static Semester? fromString(String semester) {
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
  }
}
