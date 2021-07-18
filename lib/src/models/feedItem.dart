import 'homeworkItem.dart';
import 'meeting.dart';

enum FeedItemType { Homework, Lecture, Meeting }

extension FeedItemTypeExtension on FeedItemType {
  static FeedItemType? fromItem(dynamic item) {
    if (item is HomeworkItem) {
      return FeedItemType.Homework;
    } else if (item is Meeting) {
      return FeedItemType.Meeting;
    }
  }
}

class FeedItem {
  String name;
  String owner;
  String body;
  DateTime postDate;
  FeedItemType type;
  String itemId;
  String? attachmentUrl;

  FeedItem({
    required this.name,
    required this.owner,
    required this.body,
    required this.postDate,
    required this.type,
    required this.itemId,
    this.attachmentUrl,
  });
}
