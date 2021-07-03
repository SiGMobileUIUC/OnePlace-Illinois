enum Semester { Fall, Winter, Spring, Summer }

class Semesters {
  static String toStr(Semester semester) {
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

  static Semester? fromString(String semester) {
    switch (semester) {
      case "Fall":
        return Semester.Fall;
      case "Winter":
        return Semester.Winter;
      case "Spring":
        return Semester.Spring;
      case "Summer":
        return Semester.Summer;
    }
  }
}
