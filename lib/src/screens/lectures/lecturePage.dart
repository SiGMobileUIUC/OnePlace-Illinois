import 'dart:async';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:oneplace_illinois/src/misc/enums.dart';
import 'package:oneplace_illinois/src/providers/mediSpaceFileProvider.dart';
import 'package:oneplace_illinois/src/models/courseItem.dart';
import 'package:oneplace_illinois/src/models/lectureItem.dart';
import 'package:oneplace_illinois/src/providers/mediaSpaceDownloadProvider.dart';
import 'package:oneplace_illinois/src/providers/mediaSpaceDownload.dart';
import 'package:oneplace_illinois/src/widgets/sliverView.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class LecturePage extends StatefulWidget {
  final CourseItem courseItem;
  final LectureItem lectureItem;
  final bool downloaded;
  final String path;
  const LecturePage({
    Key? key,
    required this.courseItem,
    required this.lectureItem,
    required this.downloaded,
    required this.path,
  }) : super(key: key);

  @override
  _LecturePageState createState() => _LecturePageState();
}

class _LecturePageState extends State<LecturePage> with WidgetsBindingObserver {
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource dataSource;
  GlobalKey _betterPlayerKey = GlobalKey();
  StreamController<bool> _placeholderStreamController =
      StreamController.broadcast();
  bool _showPlaceholder = true;

  @override
  void dispose() {
    _placeholderStreamController.close();
    _betterPlayerController.dispose();
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
        backgroundColor: Colors.black54,
        fontColor: Colors.white,
      ),
      placeholder: _buildVideoPlaceholder(),
      showPlaceholderUntilPlay: true,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        overflowModalColor: Colors.black,
        overflowMenuIconsColor: Colors.white,
        overflowModalTextColor: Colors.white,
      ),
    );
    dataSource = widget.downloaded
        ? BetterPlayerDataSource(
            BetterPlayerDataSourceType.file,
            widget.path,
            useAsmsSubtitles: true,
            notificationConfiguration: BetterPlayerNotificationConfiguration(
              showNotification: true,
              title: widget.lectureItem.title,
              activityName: "Lecture",
              imageUrl: widget.lectureItem.thumbnail,
            ),
          )
        : BetterPlayerDataSource(
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
    // _checkPIP();
    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.play) {
        _setPlaceholderVisibleState(false);
      }
    });
    super.initState();
  }

  Future<void> _checkPIP() async {
    bool supported =
        await _betterPlayerController.isPictureInPictureSupported();
    if (supported) {
      _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
    }
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
        children: _buildPage(context),
        actions: [],
        leading: null,
      ),
    );
  }

  List<Widget> _buildPage(BuildContext context) {
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
      ),
      _detailsBar(context),
      _navbar(context),
    ];
  }

  Widget _detailsBar(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.lectureItem.title,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        "${DateFormat.MEd().format(widget.lectureItem.created)}",
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              fontSize: 15.0,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Lecture ${widget.lectureItem.lectureNumber}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      Text(
                        widget.lectureItem.author,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              fontSize: 15.0,
                            ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }
    return SizedBox();
  }

  Widget _navbar(BuildContext context) {
    final MSVideoFileProvider videoFile =
        Provider.of<MSVideoFileProvider>(context);
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 5.0),
                  child: PlatformIconButton(
                    icon: Icon(
                      PlatformIcons(context).leftChevron,
                      size: 40.0,
                    ),
                    onPressed: widget.lectureItem.previous == null
                        ? null
                        : () async {
                            if (videoFile.status!.isGranted ||
                                videoFile.status!.isLimited) {
                              String path =
                                  "${videoFile.externalDir!.path}/${widget.lectureItem.previous!.videoID}.mp4";
                              if (await File(path).exists()) {
                                Navigator.of(context, rootNavigator: true)
                                    .pushReplacement(
                                  CupertinoPageRoute(
                                    builder: (context) {
                                      return LecturePage(
                                        lectureItem:
                                            widget.lectureItem.previous!,
                                        courseItem: widget.courseItem,
                                        downloaded: true,
                                        path: path,
                                      );
                                    },
                                  ),
                                );
                                return;
                              }
                            }
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacement(
                              CupertinoPageRoute(
                                builder: (context) {
                                  return LecturePage(
                                    lectureItem: widget.lectureItem.previous!,
                                    courseItem: widget.courseItem,
                                    downloaded: false,
                                    path: "",
                                  );
                                },
                              ),
                            );
                          },
                  ),
                ),
                /* Expanded(
                  child: downloadButton(context),
                ), */
                Container(
                  padding: EdgeInsets.only(right: 5.0),
                  child: PlatformIconButton(
                    icon: Icon(
                      PlatformIcons(context).rightChevron,
                      size: 40.0,
                    ),
                    onPressed: widget.lectureItem.next == null
                        ? null
                        : () async {
                            if (videoFile.status!.isGranted ||
                                videoFile.status!.isLimited) {
                              String path =
                                  "${videoFile.externalDir!.path}/${widget.lectureItem.next!.videoID}.mp4";
                              if (await File(path).exists()) {
                                Navigator.of(context, rootNavigator: true)
                                    .pushReplacement(
                                  CupertinoPageRoute(
                                    builder: (context) {
                                      return LecturePage(
                                        lectureItem: widget.lectureItem.next!,
                                        courseItem: widget.courseItem,
                                        downloaded: true,
                                        path: path,
                                      );
                                    },
                                  ),
                                );
                                return;
                              }
                            }
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacement(
                              CupertinoPageRoute(
                                builder: (context) {
                                  return LecturePage(
                                    lectureItem: widget.lectureItem.next!,
                                    courseItem: widget.courseItem,
                                    downloaded: false,
                                    path: "",
                                  );
                                },
                              ),
                            );
                          },
                  ),
                ),
              ],
            ),
            Divider(
              height: 1.0,
            )
          ],
        ),
      );
    }
    return SizedBox();
  }

  Widget downloadButton(BuildContext context) {
    final MSVideoFileProvider videoFile =
        Provider.of<MSVideoFileProvider>(context);
    bool downloaded = widget.downloaded;
    if (widget.downloaded) {
      return PlatformIconButton(
        icon: Icon(
          PlatformIcons(context).checkMark,
          color: Colors.white,
          size: 28.0,
        ),
        onPressed: null,
      );
    }
    return Selector<MSDownload, bool>(
        selector: (_, ffmpeg) => ffmpeg.encoding,
        builder: (context, encoding, child) {
          return Consumer<MSDownloadProvider>(builder: (BuildContext context,
              MSDownloadProvider msDownloadProvider, Widget? child) {
            return FutureBuilder(
              future: videoFile.checkFile(widget.lectureItem),
              builder: (context, AsyncSnapshot<bool> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return SpinKitRing(
                      color: AppColors.secondaryUofILight,
                      size: 35.0,
                      lineWidth: 3.5,
                    );
                  case ConnectionState.done:
                    downloaded = snapshot.data!;
                    if (!downloaded || encoding) {
                      if (msDownloadProvider.queue
                              .contains(widget.lectureItem) &&
                          widget.lectureItem.lectureUrl !=
                              msDownloadProvider.current.lectureUrl) {
                        return PlatformIconButton(
                          icon: Icon(
                            Icons.motion_photos_paused,
                            color: Colors.white,
                            size: 28.0,
                          ),
                          onPressed: null,
                        );
                      }
                      if (encoding &&
                          widget.lectureItem.lectureUrl ==
                              msDownloadProvider.current.lectureUrl) {
                        return SpinKitRing(
                          color: AppColors.secondaryUofILight,
                          size: 35.0,
                          lineWidth: 3.5,
                        );
                      }
                      return PlatformIconButton(
                        icon: Icon(
                          Icons.download,
                          color: Colors.white,
                          size: 28.0,
                        ),
                        onPressed: widget.lectureItem.platform ==
                                LecturePlatform.MediaSpace
                            ? () {
                                setState(() {
                                  downloaded = true;
                                });
                                msDownloadProvider.addItem(
                                    widget.lectureItem, context);
                              }
                            : null,
                      );
                    }
                    return PlatformIconButton(
                      icon: Icon(
                        PlatformIcons(context).checkMark,
                        color: Colors.white,
                        size: 28.0,
                      ),
                      onPressed: null,
                    );
                }
              },
            );
          });
        });
  }
}
