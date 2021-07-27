import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:oneplace_illinois/src/models/feedItem.dart';
import 'package:oneplace_illinois/src/models/sectionItem.dart';
import 'package:oneplace_illinois/src/providers/feedApi.dart';
import 'package:oneplace_illinois/src/screens/courses/specificSectionView.dart';
import 'package:oneplace_illinois/src/screens/homework/homeworkScreen.dart';
import 'package:oneplace_illinois/src/widgets/boxItem.dart';
import 'package:oneplace_illinois/src/widgets/inherited/apiWidget.dart';
import 'package:oneplace_illinois/src/widgets/button.dart';
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
  FeedAPI feedApi = FeedAPI();
  List<FeedItem> feedItems = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final api = ApiServiceWidget.of(context).api;
    feedApi.getFeed(api).then((feedItems) {
      setState(() {
        this.feedItems = feedItems;
      });
    });

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
    // if (item.type == FeedItemType.Lecture && item.attachmentUrl != null) {
    //   videoPlayerController =
    //       VideoPlayerController.network(item.attachmentUrl!);
    //   await videoPlayerController.initialize();
    //}

    return Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            platformPageRoute(
              context: context,
              builder: (context) {
                return _getScreenForFeedItem(item);
              },
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).push(
                        platformPageRoute(
                          context: context,
                          builder: (context) {
                            return SectionView(
                              sectionName: item.owner,
                              sectionCode: item.itemCode,
                            );
                          },
                        ),
                      ),
                      child: Text('${item.owner}'),
                    ),
                    Text(' posted ${item.name}'),
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
                    Button(
                      onPressed: () => Navigator.of(context).push(
                        platformPageRoute(
                          context: context,
                          builder: (context) {
                            return _getScreenForFeedItem(item);
                          },
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(PlatformIcons(context).eyeSolid),
                          SizedBox(width: 5),
                          PlatformText('View'),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getScreenForFeedItem(FeedItem item) {
    switch (item.type) {
      case FeedItemType.Homework:
        return HomeworkScreen(
          homeworkCode: item.itemCode,
          homeworkName: item.name,
        );
      default:
        return throw UnimplementedError(
            'No other item screens yet implemented.');
    }
  }
}
