import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:oneplace_illinois/src/misc/config.dart';
import 'package:oneplace_illinois/src/misc/enums.dart';
import 'package:oneplace_illinois/src/models/courseItem.dart';
import 'package:oneplace_illinois/src/models/homeworkItem.dart';
import 'package:oneplace_illinois/src/models/sectionItem.dart';

final course = CourseItem(
  year: 2021,
  semester: Semester.Fall,
  semesterID: '25',
  subject: 'Math',
  subjectID: "math",
  courseID: 34535,
  title: 'Calculus I',
  description: 'Calulus 1 for people',
  creditHours: '4',
  courseSectionInformation: 'Only X people',
  classScheduleInformation: "DAILY",
  sections: [],
  categories: ['none'],
);

class HomeworkAPI {
  Client client = Client();

  Future<HomeworkItem> getHomework(String homeworkCode) async {
    final homework = HomeworkItem(
      name: 'Homework 1',
      assignmentUrl: 'https://example.com',
      dueDate: DateTime.now().add(const Duration(hours: 5)),
      platform: 'turitin',
      course: course,
    );

    await Future.delayed(const Duration(seconds: 2));

    return Future.value(homework);
  }
}
