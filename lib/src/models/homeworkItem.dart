import 'package:intl/intl.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:oneplace_illinois/src/misc/format.dart';

import 'courseItem.dart';
import 'file.dart';

class HomeworkItem {
  static final dueDateFormat = DateFormat("EEE 'at' h:m a");
  static final dueDateFormatLong = DateFormat("MMMM d 'at' h:m a");
  static final dueDateDurationFormat = DurationFormat(0.85);

  String name;
  String? description;
  String _assignmentUrl;
  DateTime dueDate;
  String platform;
  CourseItem course;
  String? _assignmentPreviewUrl;
  List<File> files;

  HomeworkItem({
    required this.name,
    this.description,
    required assignmentUrl,
    required this.dueDate,
    required this.platform,
    required this.course,
    assignmentPreviewUrl,
    files,
  })  : this._assignmentUrl = assignmentUrl,
        this._assignmentPreviewUrl = assignmentPreviewUrl,
        this.files = files ?? [];

  get dueInfo {
    var timeUntilDue = dueDate.difference(DateTime.now());
    var percentageDay =
        (timeUntilDue.inHours % Duration.hoursPerDay).toDouble() /
            Duration.hoursPerDay;
    var daysUntilDue = (timeUntilDue.inDays + percentageDay).round();

    if (timeUntilDue.isNegative) {
      return 'Past due';
    }

    if (daysUntilDue <= 2) {
      return 'Due ${dueDateDurationFormat.format(timeUntilDue, humanize: true)}';
    } else if (daysUntilDue >= 7 && daysUntilDue < 14) {
      return 'Due next ${dueDateFormat.format(dueDate)}';
    } else if (daysUntilDue >= 14) {
      return 'Due on ${dueDateFormatLong.format(dueDate)}';
    } else {
      return 'Due on ${dueDateFormat.format(dueDate)}';
    }
  }

  set assignmentUrl(value) {
    this._assignmentUrl = value;
    this._assignmentPreviewUrl = null;
  }

  get assignmentUrl => _assignmentUrl;

  Future<String?> get assignmentPreviewUrl async {
    _assignmentPreviewUrl ??=
        (await MetadataFetch.extract(_assignmentUrl))?.image;
    return _assignmentPreviewUrl;
  }
}
