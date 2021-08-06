import 'dart:collection';

import 'package:oneplace_illinois/src/misc/config.dart';
import 'package:oneplace_illinois/src/misc/enums.dart';

class LectureItem extends LinkedListEntry<LectureItem> {
  /// URL for the lecture.
  String lectureUrl;

  /// The platform that the video is hosted on.
  LecturePlatform platform;

  /// Lecture title.
  String title;

  /// The lecture number for the course.
  int lectureNumber;

  /// DateTime that represents the date that the video was created.
  DateTime created;

  /// Name of author that created the video.
  String author;

  LectureItem({
    required this.lectureUrl,
    required this.platform,
    required this.title,
    required this.lectureNumber,
    required this.created,
    required this.author,
  });

  /// HLS URL that will be passed to the video player.
  String get hlsUrl {
    String videoID = lectureUrl.split("/")[5];
    return Config.mediaSpaceVideoUrl
        .toString()
        .replaceFirst(r"{videoID}", videoID);
  }

  /// The url to the thumbnail of the video.
  String get thumbnail {
    String thumbnailID = lectureUrl.split("/")[5];
    return Config.mediaSpaceThumbnailUrl
        .toString()
        .replaceFirst(r"{thumbnailID}", thumbnailID);
  }

  String get videoID {
    return lectureUrl.split("/")[5];
  }
}
