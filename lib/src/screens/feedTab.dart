import 'package:flutter/cupertino.dart';

/*
Main page for the Feed tab, will add more details later.
*/

class FeedTab extends StatefulWidget {
  const FeedTab({Key? key}) : super(key: key);

  @override
  _FeedTabState createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            backgroundColor: CupertinoColors.black,
            border: Border(
              bottom: BorderSide(
                color: CupertinoColors.systemGrey,
                width: 0.5,
              ),
            ),
            brightness: Brightness.dark,
            largeTitle: Text("Feed"),
          ),
          SliverFillRemaining(
            child: Center(
              child: Text("Base"),
            ),
          ),
        ],
      ),
    );
  }
}
