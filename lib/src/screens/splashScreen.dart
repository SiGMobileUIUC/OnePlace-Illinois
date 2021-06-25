import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oneplace_illinois/src/onePlace.dart';
import 'package:oneplace_illinois/src/providers/connection_status_provider.dart';
import 'package:provider/provider.dart';

/*
Loading screen while app checks user data and connects to the internet.
*/

class SplashScreen extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    // Will check if user is logged in or not here.

    final connection = Provider.of<ConnectionStatusProvider>(context);
    await connection.checkConnectivity();
    if (connection.isConnected) {
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          builder: (BuildContext context) => OnePlaceTabs(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Center(
        child: SpinKitThreeBounce(
          color: CupertinoColors.white,
        ),
      ),
    );
  }
}
