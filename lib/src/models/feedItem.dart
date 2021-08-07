import 'homeworkItem.dart';
import 'sectionItem.dart';

enum FeedItemType { Homework, Lecture, Section }

extension FeedItemTypeExtension on FeedItemType {
  static FeedItemType? fromItem(dynamic item) {
    if (item is HomeworkItem) {
      return FeedItemType.Homework;
    } else if (item is SectionItem) {
      return FeedItemType.Section;
    }
  }

  static FeedItemType? fromIndex(int index) {
    return FeedItemType.values[index];
  }
}

class FeedItem {
  /// The owning section for this feed item
  SectionItem? owner;

  /// The "body" of this feed item. Description text/message
  String body;

  /// The post date for this feed item
  DateTime postDate;

  /// The item type for this feed item (to differentiate how it displays/links to its item)
  FeedItemType type;

  /// The action undertaken to create this feed item
  String action;

  /// The code of the item referenced by this feed item
  String itemCode;

  /// An optional URL for a feed item attachment. The "type" may affect how this is used
  String? attachmentUrl;

  FeedItem({
    this.owner,
    required this.body,
    required this.postDate,
    required this.type,
    required this.action,
    required this.itemCode,
    this.attachmentUrl,
  });

  factory FeedItem.fromJSON(Map<String, dynamic> json) {
    FeedItem feedItem = FeedItem(
      owner: SectionItem.fromJSON(json['sectionDetail']),
      body: json['body'],
      postDate: DateTime.parse(json['createdAt']),
      type: FeedItemTypeExtension.fromIndex(json['type'])!,
      action: json['action'],
      itemCode: json['item_id'],
      attachmentUrl: json['attachment_url'],
    );
    return feedItem;
  }
}
