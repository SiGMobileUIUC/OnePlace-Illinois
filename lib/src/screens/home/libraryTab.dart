import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Container(
      child: Column(
        children: <Widget>[
          Card(
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.grey[300],
            child: ListTile(
              onTap: () {},
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              isThreeLine: false,
              title: Text(
                "Sections",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
              ),
            ),
          ),
          Card(
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.grey[300],
            child: ListTile(
              onTap: () {},
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              isThreeLine: false,
              title: Text(
                "Lectures",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
