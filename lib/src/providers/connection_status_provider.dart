import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';

/*
Connection Status Provider, allows us to know if the device is connected to the device or not.
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
