import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:oneplace_illinois/src/models/homeworkItem.dart';
import 'package:oneplace_illinois/src/providers/homeworkApi.dart';
import 'package:oneplace_illinois/src/widgets/homework/homework.dart';

class HomeworkScreen extends StatefulWidget {
  final homeworkApi = HomeworkAPI();
  late final Future<HomeworkItem?> homework;
  late final String? homeworkName;

  HomeworkScreen(
      {Key? key,
      HomeworkItem? homework,
      String? homeworkCode,
      String? homeworkName})
      : super(key: key) {
    assert(homework != null || (homeworkCode != null && homeworkName != null));

    this.homeworkName = homeworkName;
    this.homework = homework != null
        ? Future.value(homework)
        : homeworkApi.getHomework(homeworkCode!);
  }

  @override
  _HomeworkScreenState createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  late String homeworkName;

  @override
  void initState() {
    super.initState();
    setState(() {
      this.homeworkName = widget.homeworkName ?? '';
    });

    if (widget.homeworkName == null) {
      widget.homework.then((homework) => setState(() {
            homeworkName = homework!.name;
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(
          homeworkName,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: widget.homework,
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
                child: Text(snapshot.error.toString()),
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
