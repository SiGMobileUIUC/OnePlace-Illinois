import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:oneplace_illinois/src/models/feedItem.dart';
import 'package:oneplace_illinois/src/models/sectionItem.dart';
import 'package:oneplace_illinois/src/providers/accountProvider.dart';
import 'package:oneplace_illinois/src/screens/courses/specificSectionView.dart';
import 'package:oneplace_illinois/src/screens/homework/homeworkScreen.dart';
import 'package:oneplace_illinois/src/widgets/alertBox.dart';
import 'package:oneplace_illinois/src/widgets/button.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Selector<AccountProvider, List<FeedItem>?>(
      selector: (_, account) => account.feedItems,
      builder: (context, value, child) {
        return Container(
          width: size.width,
          height: size.height * 3 / 4,
          child: value == null
              ? Center(
                  child: SpinKitRing(color: AppColors.secondaryUofILightest),
                )
              : (value.isEmpty)
                  ? Center(
                      child: AlertBox(
                        child: Text(
                          "There is no feed to show! Please consider following some sections to view the feed!",
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, i) =>
                          _buildItem(context, value[i]),
                    ),
        );
      },
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
          onTap: () => Navigator.of(context, rootNavigator: true).push(
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
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(
                    builder: (context) {
                      return SectionView(
                        sectionItem: SectionItem(
                          year: 2021,
                          term: "fall",
                          crn: 74477,
                          fullCode: "CS124_74477",
                          course: "CS124",
                          sectionID: "AL1",
                          partOfTerm: 1,
                          sectionTitle: "",
                          sectionStatus: "A",
                          creditHours: "",
                          enrollmentStatus: "Open (Restricted)",
                          type: "Online Lecture",
                          typeCode: "OLC",
                          startTime: "ARRANGED",
                          endTime: "",
                          daysOfWeek: "",
                          room: "",
                          building: "",
                          instructors: ["Challen, G", "Lewis, C"],
                        ),
                      );
                    },
                  ),
                ),
                child: Text('${item.owner!.course} '),
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
          sectionItem: item.owner!,
        );
      default:
        return throw UnimplementedError(
            'No other item screens yet implemented.');
    }
  }
}
