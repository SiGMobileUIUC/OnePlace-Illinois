import 'package:flutter/cupertino.dart';
import 'package:oneplace_illinois/src/misc/enums.dart';
import 'package:oneplace_illinois/src/models/lectureItem.dart';
import 'package:oneplace_illinois/src/providers/mediaSpaceDownload.dart';
import 'package:provider/provider.dart';

class MSDownloadProvider extends ChangeNotifier {
  List<LectureItem> queue = [];
  LectureItem current = LectureItem(
    lectureUrl: "",
    platform: LecturePlatform.YouTube,
    title: "",
    lectureNumber: 0,
    created: DateTime.now(),
    author: "",
  );

  void addItem(LectureItem item, BuildContext context) {
    queue.add(item);
    notifyListeners();
    startEncoding(context);
  }

  void removeItem(LectureItem item) {
    queue.remove(item);
    notifyListeners();
  }

  void startEncoding(BuildContext context) {
    final MSDownload ffmpeg = Provider.of<MSDownload>(context, listen: false);
    ffmpeg.addListener(() {
      if (!ffmpeg.encoding && queue.isNotEmpty && !ffmpeg.failed) {
        this.current = this.queue[0];
        this.queue.removeAt(0);
        ffmpeg.init();
        ffmpeg.downloadVideo(this.current);
      } else if (ffmpeg.completed || ffmpeg.failed || ffmpeg.error != "") {
        this.current = LectureItem(
          lectureUrl: "",
          platform: LecturePlatform.YouTube,
          title: "",
          lectureNumber: 0,
          created: DateTime.now(),
          author: "",
        );
        ffmpeg.removeListener(() {});
      }
    });
    if (!ffmpeg.encoding && queue.isNotEmpty && !ffmpeg.failed) {
      this.current = this.queue[0];
      this.queue.removeAt(0);
      ffmpeg.init();
      ffmpeg.downloadVideo(this.current);
    }
    notifyListeners();
  }
}
