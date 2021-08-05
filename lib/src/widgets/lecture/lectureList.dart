import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:oneplace_illinois/src/screens/lectures/lecturePage.dart';
import 'package:oneplace_illinois/src/providers/mediaSpaceDownload.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class LectureList extends StatefulWidget {
  final List<LectureItem> lectureItems;
  final CourseItem courseItem;

  LectureList({
    Key? key,
    required this.lectureItems,
    required this.courseItem,
  }) : super(key: key);

  @override
  _LectureListState createState() => _LectureListState();
}

class _LectureListState extends State<LectureList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MSVideoFileProvider videoFile =
        Provider.of<MSVideoFileProvider>(context);
    final MSDownload ffmpeg = Provider.of<MSDownload>(context, listen: false);
    return ListView.builder(
      itemCount: widget.lectureItems.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            if (videoFile.status!.isGranted || videoFile.status!.isLimited) {
              String path =
                  "${videoFile.externalDir!.path}/${widget.lectureItems[index].videoID}.mp4";
              if (await videoFile.checkFile(widget.lectureItems[index]) &&
                  !ffmpeg.encoding) {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(
                    builder: (context) {
                      return LecturePage(
                        lectureItem: widget.lectureItems[index],
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
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(
                builder: (context) {
                  return LecturePage(
                    lectureItem: widget.lectureItems[index],
                    courseItem: widget.courseItem,
                    downloaded: false,
                    path: "",
                  );
                },
              ),
            );
          },
          child: Card(
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.grey[300],
            child: Container(
              margin: EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                top: 6.0,
                bottom: 6.0,
              ),
              height: 100,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Hero(
                      tag: widget.lectureItems[index].lectureUrl,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          color: Colors.black,
                          child: FadeInImage.memoryNetwork(
                            fadeInCurve: Curves.easeOut,
                            fadeInDuration: Duration(milliseconds: 300),
                            image: widget.lectureItems[index].thumbnail,
                            placeholder: kTransparentImage,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 12.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              "Lecture ${widget.lectureItems[index].lectureNumber}"),
                          Text(
                            widget.lectureItems[index].title,
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.lectureItems[index].author,
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${DateFormat.MEd().format(widget.lectureItems[index].created)}",
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  /* Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: _downloadButton(index),
                  ), */
                ],
              ),
            ),
            margin: EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              top: 6.0,
              bottom: 6.0,
            ),
          ),
        );
      },
    );
  }

  Widget _downloadButton(int index) {
    final MSVideoFileProvider videoFile =
        Provider.of<MSVideoFileProvider>(context);
    bool? isDownloaded;
    return Selector<MSDownload, bool>(
      selector: (_, ffmpeg) => ffmpeg.encoding,
      builder: (BuildContext context, bool encoding, Widget? child) {
        return Consumer<MSDownloadProvider>(
          builder: (BuildContext context, MSDownloadProvider msDownloadProvider,
              Widget? child) {
            return FutureBuilder(
              future: videoFile.checkFile(widget.lectureItems[index]),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return Center(
                      child: SpinKitRing(
                        color: AppColors.secondaryUofILight,
                        size: 30.0,
                        lineWidth: 3.0,
                      ),
                    );
                  case ConnectionState.done:
                    isDownloaded = snapshot.data!;
                    if (!isDownloaded!) {
                      if (msDownloadProvider.queue
                              .contains(widget.lectureItems[index]) &&
                          widget.lectureItems[index].lectureUrl !=
                              msDownloadProvider.current.lectureUrl) {
                        return Center(child: Icon(Icons.motion_photos_paused));
                      }
                      if (encoding &&
                          widget.lectureItems[index].lectureUrl ==
                              msDownloadProvider.current.lectureUrl) {
                        return Center(
                          child: SpinKitRing(
                            color: AppColors.secondaryUofILight,
                            size: 30.0,
                            lineWidth: 3.0,
                          ),
                        );
                      }
                      return Center(
                        child: PlatformIconButton(
                          icon: Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          onPressed: widget.lectureItems[index].platform ==
                                  LecturePlatform.MediaSpace
                              ? () {
                                  setState(() {
                                    isDownloaded = true;
                                  });
                                  msDownloadProvider.addItem(
                                      widget.lectureItems[index], context);
                                }
                              : null,
                        ),
                      );
                    }
                    return Center(
                      child: PlatformIconButton(
                        icon: Icon(
                          PlatformIcons(context).delete,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        onPressed: () {
                          String path =
                              "${videoFile.externalDir!.path}/${widget.lectureItems[index].videoID}.mp4";
                          File(path).delete();
                          setState(() {
                            isDownloaded = false;
                          });
                        },
                      ),
                    );
                }
              },
            );
          },
        );
      },
    );
  }
}
