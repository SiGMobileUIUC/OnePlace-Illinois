import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:oneplace_illinois/src/models/homeworkItem.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeworkItemWidget extends StatelessWidget {
  static const warningTime = Duration(days: 2);
  static final dueDateFormatLong = DateFormat("EEEE, MMMM d 'at' h:m a");
  final HomeworkItem homework;

  HomeworkItemWidget({required this.homework});

  Widget buildAssignmentPreviewImage(
      BuildContext context, AsyncSnapshot<String?> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.data != null) {
        return FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: snapshot.data as String,
          fit: BoxFit.cover,
        );
      } else {
        return Padding(
          padding: EdgeInsets.all(20),
          child: CircleAvatar(
            child: Icon(PlatformIcons(context).edit),
            backgroundColor: AppColors.secondaryUofILightest,
            foregroundColor: Colors.black,
          ),
        );
      }
    }
    return Image.memory(kTransparentImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Row(
            children: [
              Text(
                homework.course.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onLongPress: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(dueDateFormatLong.format(homework.dueDate)),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(PlatformIcons(context).time),
                    SizedBox(width: 5),
                    Text(
                      homework.dueInfo,
                      style: TextStyle(
                        fontSize: 20,
                        color: homework.dueDate.difference(DateTime.now()) <
                                warningTime
                            ? AppColors.urbanaOrange
                            : Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        Divider(),
        Container(
          child: Column(
            children: [
              Text(
                'Assignment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 10),
                child: Text(
                  homework.description ?? 'No description',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                height: 150,
                width: 300,
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(10.0),
                  child: InkResponse(
                    onTap: () async => await canLaunch(homework.assignmentUrl)
                        ? await launch(homework.assignmentUrl)
                        : null,
                    child: FutureBuilder(
                        future: homework.assignmentPreviewUrl,
                        initialData: null,
                        builder: (_, snapshot) => buildAssignmentPreviewImage(
                            context, snapshot as AsyncSnapshot<String?>)),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    '${homework.platform} assignment',
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  PlatformButton(
                      onPressed: () async =>
                          await canLaunch(homework.assignmentUrl)
                              ? await launch(homework.assignmentUrl)
                              : null,
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
          padding: EdgeInsets.all(20),
        ),
        Container(
          child: Column(
            children: [
              Text(
                'Files',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 100,
                width: 500,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    for (var file in homework.files)
                      Card(
                        child: InkWell(
                          // TODO: Upload file
                          onTap: () => {},
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  file.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // TODO: Format file size with best unit choice
                                Text('${file.size} B'),
                                Spacer(),
                                // TODO: Convert file mimeType to icon
                                Icon(PlatformIcons(context).book),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Card(
                      child: InkWell(
                        // TODO: Download file
                        onTap: () => {},
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                PlatformIcons(context).upArrow,
                                color: AppColors.secondaryUofILight,
                              ),
                              Text(
                                'Upload Media',
                                style: TextStyle(
                                  color: AppColors.secondaryUofILight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
