import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oneplace_illinois/src/misc/config.dart';
import 'package:oneplace_illinois/src/services/firebaseAuth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class APIService extends DioMixin {
  PersistCookieJar cookieJar = PersistCookieJar(ignoreExpires: false);
  Directory? appDocDir;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final FirebaseAuthService _authService = FirebaseAuthService();

  init() async {
    super.options = BaseOptions(
      baseUrl: Config.baseEndpoint!,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    super.httpClientAdapter = DefaultHttpClientAdapter();
    super.interceptors.clear();
    await setupCookie();
    super.interceptors.add(CookieManager(cookieJar));
    await this.getJwt(updateJwt: true);
  }

  Future<void> setupCookie() async {
    if (appDocDir == null) {
      final status = await Permission.storage.request();
      if (status.isGranted || status.isLimited) {
        appDocDir = await getApplicationDocumentsDirectory();
        cookieJar = PersistCookieJar(
          ignoreExpires: false, // don't save/load expired cookies
          storage: FileStorage("${appDocDir!.path}/.cookies/"),
        );
      }
    }
  }

  Future<String?> getJwt({bool updateJwt = false}) async {
    String? jwt = await storage.read(key: "jwt_access");
    if (jwt != null && !updateJwt) {
      return jwt;
    }

    User? user = await _authService.userStream.first;

    if (user != null) {
      Uri uri = Uri.http(Config.baseEndpoint!, "api/v1/user/login");
      Response<dynamic> response = await super.postUri(uri, data: {
        "email": user.email,
        "token": await user.getIdToken(),
      });

      Map<String, dynamic>? payload = response.data["payload"];

      // save access token (refresh token is auto-saved by CookieManager above)
      if (payload != null && payload['accessToken'] != "") {
        await storage.write(key: 'jwt_access', value: payload['accessToken']);
        jwt = payload['accessToken'];
        return jwt;
      }
    }
  }
}
