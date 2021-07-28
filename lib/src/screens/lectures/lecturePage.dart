import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oneplace_illinois/src/models/courseItem.dart';
import 'package:oneplace_illinois/src/models/lectureItem.dart';
import 'package:oneplace_illinois/src/widgets/sliverView.dart';

class LecturePage extends StatefulWidget {
  final CourseItem courseItem;
  final LectureItem lectureItem;
  const LecturePage({
    Key? key,
    required this.courseItem,
    required this.lectureItem,
  }) : super(key: key);

  @override
  _LecturePageState createState() => _LecturePageState();
}

class _LecturePageState extends State<LecturePage> with WidgetsBindingObserver {
  late BetterPlayerController _betterPlayerController;
  GlobalKey _betterPlayerKey = GlobalKey();
  StreamController<bool> _placeholderStreamController =
      StreamController.broadcast();
  bool _showPlaceholder = true;

  @override
  void dispose() {
    _placeholderStreamController.close();
    super.dispose();
  }

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      allowedScreenSleep: false,
      autoDispose: true,
      autoDetectFullscreenDeviceOrientation: true,
      autoPlay: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ],
      subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
        alignment: Alignment.center,
        backgroundColor: Colors.grey,
        fontColor: Colors.white,
      ),
      placeholder: _buildVideoPlaceholder(),
      showPlaceholderUntilPlay: true,
    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.lectureItem.hlsUrl,
      useAsmsSubtitles: true,
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: widget.lectureItem.title,
        activityName: "Lecture",
        imageUrl: widget.lectureItem.thumbnail,
      ),
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.play) {
        _setPlaceholderVisibleState(false);
      }
    });
    super.initState();
  }

  void _setPlaceholderVisibleState(bool hidden) {
    _placeholderStreamController.add(hidden);
    _showPlaceholder = hidden;
  }

  Widget _buildVideoPlaceholder() {
    return StreamBuilder<bool>(
      stream: _placeholderStreamController.stream,
      builder: (context, snapshot) {
        return _showPlaceholder
            ? Image.network(widget.lectureItem.thumbnail)
            : SizedBox();
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.resumed:
        _betterPlayerController.disablePictureInPicture();
        break;
      case AppLifecycleState.paused:
        _betterPlayerController.enablePictureInPicture(_betterPlayerKey);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: SliverView(
        title: "${widget.courseItem.subjectID} ${widget.courseItem.courseID}",
        children: _buildVideo(context),
        actions: [],
        leading: null,
      ),
    );
  }

  List<Widget> _buildVideo(BuildContext context) {
    return [
      Hero(
        tag: widget.lectureItem.lectureUrl,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: BetterPlayer(
            controller: _betterPlayerController,
            key: _betterPlayerKey,
          ),
        ),
      )
    ];
  }
}
