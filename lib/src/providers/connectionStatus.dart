import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';

/*
Connection Status Provider, allows us to know if the device is connected to the internet or not.
We use ChangeNotifier to gain access to the contents of the object as it updates, without making the object static. Static objects usually do not work well if you want to check something as it updates, or wait for something to update.
*/

class ConnectionStatusProvider with ChangeNotifier {
  final Connectivity connectivity = Connectivity();
  bool isConnected = true;

  Future<void> checkConnectivity() async {
    final res = await connectivity.checkConnectivity();
    if (res == ConnectivityResult.none) {
      isConnected = false;
    } else {
      isConnected = true;
    }
  }
}
