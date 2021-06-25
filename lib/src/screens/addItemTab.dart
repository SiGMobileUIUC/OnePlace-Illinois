import 'package:flutter/cupertino.dart';

/*
Main page for the Add Item tab, will add more details later.
*/

class AddItemTab extends StatefulWidget {
  const AddItemTab({Key? key}) : super(key: key);

  @override
  _AddItemTabState createState() => _AddItemTabState();
}

class _AddItemTabState extends State<AddItemTab> {
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
            largeTitle: Text("Add Item"),
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
