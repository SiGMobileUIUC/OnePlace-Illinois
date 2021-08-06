import 'package:oneplace_illinois/src/services/courseExplorerApi.dart';

enum Semester { Fall, Winter, Spring, Summer }
enum LecturePlatform { MediaSpace, YouTube }

class LecturePlatforms {
  LecturePlatform fromString(String platform) {
    switch (platform) {
      case "mediaspace":
        return LecturePlatform.MediaSpace;
      case "youtube":
        return LecturePlatform.YouTube;
      default:
        return LecturePlatform.MediaSpace;
    }
  }

  String toStr(LecturePlatform platform) {
    switch (platform) {
      case LecturePlatform.MediaSpace:
        return "mediaspace";
      case LecturePlatform.YouTube:
        return "youtube";
    }
  }
}

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
      default:
        return _api.getSemester(DateTime.now()).toString();
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
      default:
        return fromString(_api.getSemester(DateTime.now()).toString());
    }
  }
}
