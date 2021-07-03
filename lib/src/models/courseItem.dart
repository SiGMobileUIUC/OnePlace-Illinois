import 'package:oneplace_illinois/src/models/instructor.dart';
import 'package:oneplace_illinois/src/models/meeting.dart';

class CourseItem {
  int year; // ns2:section -> parents -> calendarYear id
  String semester; // ns2:section -> parents -> term
  int semesterID; // ns2:section -> parents -> term id
  String subject; // ns2:section -> parents -> subject
  String subjectID; //ns2:section -> parents -> subject id
  int courseID; // ns2:section -> parents -> course id
  String section; // ns2:section -> sectionNumber
  int sectionID; // ns2:section id
  Instructor instructor; // ns2:section -> instructors -> instructor
  String title; // ns2:section -> course
  String description; // ns2:course -> description
  String creditHours; // ns2:course -> creditHours
  String courseSectionInformation; // ns2:course -> courseSectionInformation
  String classScheduleInformation; // ns2:course -> classScheduleInformation
  String category; // ns2:course -> genEdCategories -> category -> description
  Meeting meeting; // ns2:section -> meetings

  CourseItem({
    required this.year,
    required this.semester,
    required this.semesterID,
    required this.subject,
    required this.subjectID,
    required this.courseID,
    required this.section,
    required this.sectionID,
    required this.instructor,
    required this.title,
    required this.description,
    required this.creditHours,
    required this.courseSectionInformation,
    required this.classScheduleInformation,
    required this.category,
    required this.meeting,
  });
}
