import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  List<FeedItem>? feedItems;

  FeedAPI feedApi = FeedAPI();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final api = ApiServiceWidget.of(context).api;
    feedApi.getFeed(api).then((feedItems) {
      setState(() {
        this.feedItems = feedItems;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      child: feedItems == null
          ? Center(
              child: SpinKitRing(color: AppColors.secondaryUofILightest),
            )
          : ListView.builder(
              itemCount: feedItems!.length,
              itemBuilder: (context, i) => _buildItem(context, feedItems![i]),
            ),
    );
  }

  Widget _buildItem(BuildContext context, FeedItem item) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        color: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.grey[300],
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) {
                return _getScreenForFeedItem(item);
              },
            ),
          ),
          child: _buildFeedItemWidget(item),
        ),
      ),
    );
  }

  Widget _buildFeedItemWidget(FeedItem item) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) {
                      return SectionView(
                        sectionName: item.owner.course,
                        sectionCode: item.owner.fullCode,
                      );
                    },
                  ),
                ),
                child: Text('${item.owner.course} '),
              ),
              Text(item.action),
              Spacer(),
              Text('${postDateFormatter.format(item.postDate)}',
                  style: TextStyle(color: Colors.grey[700])),
            ],
          ),
          SizedBox(height: 10),
          Text(
            item.body,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
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
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(
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
    );
  }

  Widget _getScreenForFeedItem(FeedItem item) {
    switch (item.type) {
      case FeedItemType.Homework:
        return HomeworkScreen(homeworkCode: item.itemCode);
      case FeedItemType.Section:
        return SectionView(
          sectionName: item.owner.course,
          sectionCode: item.owner.fullCode,
        );
      default:
        return throw UnimplementedError(
            'No other item screens yet implemented.');
    }
  }
}
