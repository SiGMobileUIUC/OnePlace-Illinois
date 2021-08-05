import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:oneplace_illinois/src/providers/mediSpaceFileProvider.dart';
import 'package:oneplace_illinois/src/providers/mediaSpaceDownloadProvider.dart';
import 'package:oneplace_illinois/src/screens/home/addItemTab.dart';
import 'package:oneplace_illinois/src/screens/home/feedTab.dart';
import 'package:oneplace_illinois/src/screens/home/libraryTab.dart';
import 'package:oneplace_illinois/src/screens/home/search.dart';
import 'package:oneplace_illinois/src/screens/settingsDrawer.dart';
import 'package:oneplace_illinois/src/screens/login/splashScreen.dart';
import 'package:oneplace_illinois/src/services/api.dart';
import 'package:oneplace_illinois/src/services/firebaseAuth.dart';
import 'package:oneplace_illinois/src/providers/mediaSpaceDownload.dart';
import 'package:oneplace_illinois/src/widgets/inherited/services.dart';
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
  final FirebaseAuthService firebaseAuth = FirebaseAuthService();
  late final ApiService api;

  _OnePlaceState() {
    api = ApiService(firebaseAuth: firebaseAuth);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final darkTheme = CupertinoThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      barBackgroundColor: AppColors.secondaryUofIDark,
      primaryColor: AppColors.secondaryUofILightest,
    );
    final lightTheme = CupertinoThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      barBackgroundColor: AppColors.secondaryUofILight,
      primaryColor: AppColors.secondaryUofILightest,
    );

    // Future proofing; If we ever need to access a class or object that is not a part of the current class or screen, we can by initializing a provider here.
    /* return MultiProvider(
      providers: [
      ],
      child: */
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MSDownload>(
          create: (context) => MSDownload(),
        ),
        ChangeNotifierProvider<MSDownloadProvider>(
          create: (context) => MSDownloadProvider(),
        ),
        ChangeNotifierProvider<MSVideoFileProvider>(
          create: (context) => MSVideoFileProvider(),
        ),
      ],
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
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              canvasColor: Colors.white,
              inputDecorationTheme: InputDecorationTheme(
                hintStyle: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.white,
              colorScheme: ColorScheme.light(),
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.secondaryUofILight,
                actionsIconTheme: IconThemeData(color: Colors.white),
                iconTheme: IconThemeData(color: Colors.white),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.black,
              backgroundColor: Colors.black,
              colorScheme: ColorScheme.dark(),
              canvasColor: Colors.black,
              inputDecorationTheme: InputDecorationTheme(
                hintStyle: TextStyle(color: Colors.white),
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.primaryUofI,
                actionsIconTheme: IconThemeData(color: Colors.white),
                iconTheme: IconThemeData(color: Colors.white),
              ),
            ),
            themeMode: ThemeMode.system,
          ),
          cupertino: (_, __) => CupertinoAppData(
            theme: MediaQuery.of(context).platformBrightness == Brightness.light
                ? lightTheme
                : darkTheme,
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
    // "Settings",
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
            /* BottomNavigationBarItem(
              icon: Icon(PlatformIcons(context).settings),
              label: "Settings",
            ), */
          ];

  Widget _search(BuildContext context, int index) {
    if (titles[index] == "Feed") {
      return PlatformIconButton(
        icon: Icon(
          PlatformIcons(context).search,
        ),
        onPressed: () {
          showSearch(
            context: context,
            delegate: Search(),
          );
        },
      );
    }
    return SizedBox(
      height: 0,
      width: 0,
    );
  }

  @override
  void initState() {
    final MSVideoFileProvider videoFile =
        Provider.of<MSVideoFileProvider>(context, listen: false);
    if (videoFile.externalDir == null && videoFile.status == null) {
      videoFile.init();
    }
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
      /* SettingsTab(
        key: settingsTabKey,
      ), */
    ];

    tabController = PlatformTabController(
      initialIndex: 1,
    );

    contentBuilder = (BuildContext context, int index) => SliverView(
          title: titles[index],
          children: [widgets[index]],
          actions: [_search(context, index)],
          drawer: SettingsDrawer(),
          leading: null,
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
      cupertinoTabs: (context, platform) => CupertinoTabBarData(
        activeColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? AppColors.secondaryUofILightest
                : AppColors.secondaryUofILight,
        inactiveColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? AppColors.secondaryUofILight
                : AppColors.secondaryUofILightest,
      ),
      materialTabs: (context, platform) => MaterialNavBarData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? AppColors.secondaryUofILightest
                : AppColors.secondaryUofILight,
        unselectedItemColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? AppColors.secondaryUofILight
                : AppColors.secondaryUofILightest,
      ),
    );
  }
}
