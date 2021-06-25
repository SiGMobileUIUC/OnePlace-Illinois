import 'package:flutter/cupertino.dart';

/*
Main page for the Library tab, will add more details later.
*/

class LibraryTab extends StatefulWidget {
  const LibraryTab({Key? key}) : super(key: key);

  @override
  _LibraryTabState createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
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
            largeTitle: Text("Library"),
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
