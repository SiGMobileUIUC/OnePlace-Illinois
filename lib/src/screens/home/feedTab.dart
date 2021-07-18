import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:oneplace_illinois/src/models/feedItem.dart';
import 'package:oneplace_illinois/src/models/sectionItem.dart';
import 'package:oneplace_illinois/src/widgets/boxItem.dart';
import 'package:video_player/video_player.dart';

/*
Main page for the Feed tab, will add more details later.
*/

class FeedTab extends StatefulWidget {
  const FeedTab({Key? key}) : super(key: key);

  @override
  _FeedTabState createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  static final DateFormat postDateFormatter = DateFormat('h:m a');

  final List<FeedItem> feedItems = [
    FeedItem(
      name: 'Lecture 1',
      owner: 'Calculus I - AAB',
      body: 'Please do this IMMEDIATELY',
      type: FeedItemType.Lecture,
      itemId: '54t3t3',
      postDate: DateTime.now().add(Duration(hours: 4)),
      attachmentUrl:
          'https://images.all-free-download.com/footage_preview/mp4/kitty_68.mp4',
    ),
    FeedItem(
      name: 'Homework 5',
      owner: 'English 101',
      body: 'Never do this',
      type: FeedItemType.Homework,
      itemId: '54t3t3',
      postDate: DateTime.now().add(Duration(hours: 2)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      child: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: feedItems.length,
        itemBuilder: (context, i) => buildItem(context, feedItems[i]),
      ),
    );
  }

  Widget buildItem(BuildContext context, FeedItem item) {
    VideoPlayerController? videoPlayerController;
    if (item.type == FeedItemType.Lecture && item.attachmentUrl != null) {
      videoPlayerController =
          VideoPlayerController.network(item.attachmentUrl!);
      await videoPlayerController.initialize();
    }

    return Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        child: InkWell(
          onTap: () => {},
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('${item.owner} posted ${item.name}'),
                    Spacer(),
                    Text('${postDateFormatter.format(item.postDate)}',
                        style: TextStyle(color: Colors.grey[400])),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  item.body,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                SizedBox(height: 10),
                Row(
                  children: [
                    if (item.type == FeedItemType.Homework)
                      Row(
                        children: [
                          Icon(PlatformIcons(context).time),
                          SizedBox(width: 5),
                          Text('Appears in calendar',
                              style: TextStyle(color: Colors.grey[450]))
                        ],
                      ),
                    Spacer(),
                    PlatformButton(
                        onPressed: () => {},
                        child: Row(
                          children: [
                            Icon(PlatformIcons(context).eyeSolid),
                            SizedBox(width: 5),
                            PlatformText('View'),
                          ],
                        ),
                        color: Colors.white,
                        cupertino: (context, platform) => CupertinoButtonData(
                            color: AppColors.secondaryUofILight),
                        materialFlat: (context, platform) =>
                            MaterialFlatButtonData(
                                textColor: Colors.white,
                                color: AppColors.secondaryUofILight)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
