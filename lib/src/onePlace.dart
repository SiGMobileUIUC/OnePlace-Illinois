import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oneplace_illinois/src/providers/connection_status_provider.dart';
import 'package:oneplace_illinois/src/screens/addItemTab.dart';
import 'package:oneplace_illinois/src/screens/feedTab.dart';
import 'package:oneplace_illinois/src/screens/libraryTab.dart';
import 'package:oneplace_illinois/src/screens/splashScreen.dart';
import 'package:provider/provider.dart';

/*
OnePlace class, a stateful widget. Returns a Cupertino App since we plan on developing for both Android and iOS.
*/

class OnePlace extends StatefulWidget {
  const OnePlace({Key? key}) : super(key: key);

  @override
  _OnePlaceState createState() => _OnePlaceState();
}

class _OnePlaceState extends State<OnePlace> {
  @override
  Widget build(BuildContext context) {
    // Future proofing; If we ever need to access a class or object that is not a part of the current class or screen, we can by initializing a provider here.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConnectionStatusProvider>(
          create: (context) => ConnectionStatusProvider(),
        )
      ],
      child: CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: "One Place",
        theme: CupertinoThemeData(
          brightness: Brightness.dark,
          primaryColor: CupertinoColors.white,
        ),
        home: SplashScreen(),
      ),
    );
  }
}

/*
Initial page that will load into once a User is logged in. Uses a tab view that has a tab bar at the bottom. 
*/

class OnePlaceTabs extends StatefulWidget {
  @override
  _OnePlaceTabs createState() => _OnePlaceTabs();
}

class _OnePlaceTabs extends State<OnePlaceTabs> {
  final GlobalKey<NavigatorState> libraryTabKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> feedTabKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> addItemTabKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBuilder: (BuildContext context, int i) {
        switch (i) {
          case 0:
            return CupertinoTabView(
              navigatorKey: libraryTabKey,
              builder: (context) => LibraryTab(),
            );
          case 1:
            return CupertinoTabView(
              navigatorKey: feedTabKey,
              builder: (context) => FeedTab(),
            );
          case 2:
            return CupertinoTabView(
              navigatorKey: addItemTabKey,
              builder: (context) => AddItemTab(),
            );
          default:
            return CupertinoTabView(
              navigatorKey: feedTabKey,
              builder: (context) => FeedTab(),
            );
        }
      },
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            label: "Library",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: "Feed",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add_circled),
            label: "New Item",
          ),
        ],
        activeColor: CupertinoColors.white,
        currentIndex: 1,
        backgroundColor: CupertinoColors.black,
      ),
    );
  }
}
