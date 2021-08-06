import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:oneplace_illinois/src/models/lectureItem.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MSVideoFileProvider extends ChangeNotifier {
  Directory? externalDir;
  PermissionStatus? status;

  void init() async {
    this.externalDir = await getExternalDir();
    this.status = await getPermissionStatus();
  }

  Future<Directory> getExternalDir() async {
    return await getApplicationDocumentsDirectory();
  }

  Future<bool> checkFile(LectureItem lectureItem) async {
    final status = await Permission.storage.request();
    if (status.isGranted || status.isLimited) {
      final externalDir = await getApplicationDocumentsDirectory();
      String path = "${externalDir.path}/${lectureItem.videoID}.mp4";
      if (await File(path).exists()) {
        return true;
      }
    }
    return false;
  }

  Future<PermissionStatus> getPermissionStatus() async {
    return await Permission.storage.request();
  }
}
