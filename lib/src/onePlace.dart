import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:oneplace_illinois/src/screens/home/addItemTab.dart';
import 'package:oneplace_illinois/src/screens/home/feedTab.dart';
import 'package:oneplace_illinois/src/screens/home/libraryTab.dart';
import 'package:oneplace_illinois/src/screens/home/settingsTab.dart';
import 'package:oneplace_illinois/src/screens/splashScreen.dart';
import 'package:oneplace_illinois/src/services/firebaseAuth.dart';
import 'package:oneplace_illinois/src/widgets/sliverView.dart';
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
    final materialTheme = ThemeData(
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.white,
      ),
      brightness: Brightness.light,
      primaryColor: Colors.white,
      appBarTheme: AppBarTheme(
        color: AppColors.secondaryUofIDark,
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white),
      ),
    );

    // Future proofing; If we ever need to access a class or object that is not a part of the current class or screen, we can by initializing a provider here.
    /* return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConnectionStatusProvider>(
          create: (context) => ConnectionStatusProvider(),
        ),
      ],
      child: */
    return Theme(
      data: materialTheme,
      //  This is for multiplatform, it will load the themes based on the platform that is being used, in order to make the app feel natural to the user.
      child: PlatformProvider(
        settings: PlatformSettingsData(iosUsesMaterialWidgets: true),
        builder: (context) => PlatformApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          title: "One Place",
          home: StreamProvider<User?>.value(
            value: FirebaseAuthService().userStream,
            initialData: FirebaseAuthService().user,
            child: SplashScreen(),
          ),
          material: (_, __) => MaterialAppData(
            theme: materialTheme,
          ),
          cupertino: (_, __) => CupertinoAppData(
            theme: CupertinoThemeData(
              brightness: Brightness.light,
              primaryColor: CupertinoColors.white,
            ),
          ),
        ),
      ),
    );
    // );
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
  final GlobalKey<NavigatorState> settingsTabKey = GlobalKey<NavigatorState>();
  late Widget Function(BuildContext, int) contentBuilder;
  late PlatformTabController tabController;
  final List<String> titles = [
    "Library",
    "Feed",
    "New Item",
    "Settings",
  ];
  final List<BottomNavigationBarItem> Function(BuildContext)
      navigationBarItems = (BuildContext context) => [
            BottomNavigationBarItem(
              icon: Icon(PlatformIcons(context).book),
              label: "Library",
            ),
            BottomNavigationBarItem(
              icon: Icon(PlatformIcons(context).home),
              label: "Feed",
            ),
            BottomNavigationBarItem(
              icon: Icon(PlatformIcons(context).addCircledOutline),
              label: "New Item",
            ),
            BottomNavigationBarItem(
              icon: Icon(PlatformIcons(context).settings),
              label: "Settings",
            ),
          ];
  @override
  void initState() {
    super.initState();
    final List<Widget> widgets = [
      LibraryTab(
        key: libraryTabKey,
      ),
      FeedTab(
        key: feedTabKey,
      ),
      AddItemTab(
        key: addItemTabKey,
      ),
      SettingsTab(
        key: settingsTabKey,
      ),
    ];

    tabController = PlatformTabController(
      initialIndex: 1,
    );

    contentBuilder = (BuildContext context, int index) => SliverView(
          title: titles[index],
          children: [widgets[index]],
          titleStyle: TextStyle(color: Colors.white),
        );
  }

  @override
  Widget build(BuildContext context) {
    // multiplatform themes
    return PlatformTabScaffold(
      iosContentPadding: true,
      tabController: tabController,
      bodyBuilder: contentBuilder,
      items: navigationBarItems(context),
      pageBackgroundColor: Colors.white,
      cupertinoTabs: (context, platform) => CupertinoTabBarData(
        activeColor: CupertinoColors.white,
        inactiveColor: CupertinoColors.extraLightBackgroundGray,
        backgroundColor: AppColors.secondaryUofIDark,
      ),
      materialTabs: (context, platform) => MaterialNavBarData(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[400],
          backgroundColor: AppColors.secondaryUofIDark),
    );
  }
}
