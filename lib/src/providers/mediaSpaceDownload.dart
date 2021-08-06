import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_ffmpeg/completed_ffmpeg_execution.dart';
import 'package:flutter_ffmpeg/statistics.dart';
import 'package:oneplace_illinois/src/models/lectureItem.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:oneplace_illinois/src/services/flutter_ffmpeg_api_wrapper.dart';

// TODO: Implement iOS version by looking at the docs for flutter_ffmpeg and permission_handler

class MSDownload extends ChangeNotifier {
  /// bool that represents if the download failed or not. If it failed, then [failed] will be true.
  bool failed = false;

  /// bool that represents if the download was cancelled or not. If it was cancelled, then [cancelled] will be true.
  bool cancelled = false;

  /// The error that occurred if the download failed.
  String error = "";

  /// bool that represents if the download is completed or not. If it is completed, then [completed] will be true.
  bool completed = false;

  bool encoding = false;

  /// Statistics for the current download.
  late Statistics? statistics;

  void init() {
    this.failed = false;
    this.statistics = null;
    this.cancelled = false;
    this.error = "";
    this.completed = false;
    this.encoding = true;
    resetStatistics();
    enableStatisticsCallback(_statisticsCallback);
  }

  /// Asynchronous function that will download the lecture from an HLS stream using FFmpeg.
  /// Accpets a [LectureItem] which is the lecture to download.
  void downloadVideo(LectureItem lectureItem) async {
    final status = await Permission.storage.request();
    if (status.isGranted || status.isLimited) {
      final externalDir = await getApplicationDocumentsDirectory();
      String path = "${externalDir.path}/${lectureItem.videoID}.mp4";
      if (await File(path).exists()) {
        this.failed = true;
        this.error = "File already exists!";
        this.encoding = false;
        notifyListeners();
        return;
      }
      // https://cdnapisec.kaltura.com/p/1329972/sp/132997200/playManifest/entryId/1_46ekurb1/flavorIds/1_9eorkib1,1_4vn7my9k,1_2skkqsew/format/applehttp/protocol/https/a.m3u8

      try {
        executeAsyncFFmpeg(
          "-i ${lectureItem.hlsUrl} -c copy $path",
          (CompletedFFmpegExecution execution) {
            if (execution.returnCode == 255) {
              this.cancelled = true;
              this.encoding = false;
              notifyListeners();
            } else if (execution.returnCode == 0) {
              this.completed = true;
              this.encoding = false;
              notifyListeners();
            }
          },
        );
      } catch (e) {
        this.failed = true;
        this.encoding = false;
        this.error = e.toString();
        notifyListeners();
      }
    } else {
      this.failed = true;
      this.encoding = false;
      this.error =
          "Permission to storage was denied. Please grant access to storage to download files.";
      notifyListeners();
    }
  }

  void cancelDownloadVideo(int executionId) {
    cancelExecution(executionId);
    this.cancelled = true;
    this.encoding = false;
    notifyListeners();
  }

  // https://cdnapisec.kaltura.com/p/1329972/sp/132997200/playManifest/entryId/1_46ekurb1/flavorIds/1_9eorkib1,1_4vn7my9k,1_2skkqsew/format/applehttp/protocol/https/a.m3u8

  void _statisticsCallback(Statistics statistics) {
    this.statistics = statistics;
    notifyListeners();
  }
}
