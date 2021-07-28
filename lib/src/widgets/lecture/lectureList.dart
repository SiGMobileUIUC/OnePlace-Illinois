import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:oneplace_illinois/src/models/courseItem.dart';
import 'package:oneplace_illinois/src/models/lectureItem.dart';
import 'package:oneplace_illinois/src/screens/lectures/lecturePage.dart';
import 'package:transparent_image/transparent_image.dart';

class LectureList extends StatelessWidget {
  final List<LectureItem> lectureItems;
  final CourseItem courseItem;
  const LectureList({
    Key? key,
    required this.lectureItems,
    required this.courseItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lectureItems.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(
                builder: (context) {
                  return LecturePage(
                    lectureItem: lectureItems[index],
                    courseItem: courseItem,
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
                  Hero(
                    tag: lectureItems[index].lectureUrl,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: Colors.black,
                        child: FadeInImage.memoryNetwork(
                          fadeInCurve: Curves.easeOut,
                          fadeInDuration: Duration(milliseconds: 300),
                          image: lectureItems[index].thumbnail,
                          placeholder: kTransparentImage,
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
                          Text("Lecture ${lectureItems[index].lectureNumber}"),
                          Text(
                            lectureItems[index].title,
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            lectureItems[index].author,
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${DateFormat.MEd().format(lectureItems[index].created)}",
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
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
}
