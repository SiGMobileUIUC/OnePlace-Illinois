import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:oneplace_illinois/src/models/homeworkItem.dart';
import 'package:oneplace_illinois/src/services/homeworkApi.dart';
import 'package:oneplace_illinois/src/widgets/alertBox.dart';
import 'package:oneplace_illinois/src/widgets/homework/homework.dart';

class HomeworkScreen extends StatefulWidget {
  late final HomeworkItem? homework;
  late final String? homeworkCode;

  HomeworkScreen({Key? key, HomeworkItem? homework, String? homeworkCode})
      : super(key: key) {
    assert(homework != null || homeworkCode != null);

    this.homework = homework;
    this.homeworkCode = homeworkCode;
  }

  @override
  _HomeworkScreenState createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  final homeworkApi = HomeworkAPI();
  String? homeworkName;
  late Future<HomeworkItem> homework;

  @override
  void initState() {
    super.initState();

    setState(() {
      homeworkName = widget.homework != null ? widget.homework!.name : '';
      homework = widget.homework != null
          ? Future.value(widget.homework)
          : homeworkApi.getHomework(widget.homeworkCode!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(
          homeworkName ?? '',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: homework,
          initialData: null,
          builder: (context, AsyncSnapshot<HomeworkItem?> snapshot) {
            HomeworkItem? data;
            if (snapshot.hasData) data = snapshot.data;

            if (snapshot.connectionState == ConnectionState.waiting ||
                data == null) {
              return Center(
                child: SpinKitRing(
                  color: AppColors.urbanaOrange,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: AlertBox(
                  child: Text(
                    snapshot.error.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              );
            } else {
              return HomeworkItemWidget(homework: data);
            }
          },
        ),
      ),
    );
  }
}
