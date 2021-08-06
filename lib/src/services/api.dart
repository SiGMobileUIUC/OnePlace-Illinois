import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
//import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oneplace_illinois/src/misc/config.dart';
import 'package:oneplace_illinois/src/misc/exceptions.dart';
import 'package:oneplace_illinois/src/misc/cookieManager.dart';
import 'package:oneplace_illinois/src/services/firebaseAuth.dart';

class ApiService {
  // NOTE: Signed cookie doesn't work with HTTP request. Only works with HTTPS.
  static final _baseUrl = Uri.https(Config.baseEndpoint!, '');

  static PersistCookieJar _cookieJar = new PersistCookieJar(ignoreExpires: false);
  /* // use default settings for now
  static Future<PersistCookieJar> get cookieJar async {
    if (_cookieJar == null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath  = appDocDir.path;
      _cookieJar = new PersistCookieJar({
        ignoreExpires: false, // don't save/load expired cookies
        storage: appDocPath + '/.cookies/'
      });
    }
    return _cookieJar;
  }
  */

  final storage = new FlutterSecureStorage(); // for storing access token

  FirebaseAuthService _firebaseAuth;

  ApiService({required firebaseAuth}) : this._firebaseAuth = firebaseAuth;


  Dio _getClient() async {
    final Dio _dio = Dio();

    _dio.options.baseUrl = _baseUrl + '/api/v1';
    _dio.interceptors.clear();

    _dio.interceptors.add(InterceptorsWrapper(
      onResponse: (Response response) {
        var data = response.data;

        if (data['error'] != null) {
          log(data.toString());
          throw ApiException(data['error']);
        }

        // save access token (refresh token is auto-saved by CookieManager above)
        var _accessToken = (tmp = data["payload"]) == null ? null : tmp["accessToken"];
        if (_accessToken) {
          await storage.write(key: 'jwt_access', value: _accessToken);
        }

        return data;
      },
    ));

    return _dio;
  }

  Future<Dio> _getClientWithAuth() async {
    // retrieve access token
    String? _accessToken = await storage.read(key: 'jwt_access');

    if (_accessToken == null) {
      // interceptor from _getClient() used by _login() will auto-save
      // the new access & refresh token (for later requests) 
      await _login();
    }

    final Dio _dio = Dio();

    _dio.options.baseUrl = _baseUrl + '/api/v1';
    _dio.interceptors.clear();

    // Add cookie (refresh token) to interceptor
    _dio.interceptors.add(CookieManager(_cookieJar));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, handler) {
        // Add access token to interceptor
        options.headers['Authorization'] = 'Bearer ' + _accessToken;
        handler.next(options);
      },
      onResponse: (Response response, handler) async {
        var data = response.data;

        if (data['error'] != null) {
          log(data.toString());
          throw ApiException(data['error']);
        }

        // Save access token if new one is issued from the server
        if (data['payload'] && data['payload']['accessToken']) {
          await storage.write(key: 'jwt_access', value: data['payload']['accessToken']);
        }

        // return response;
        return data;
      }, onError: (DioError error) async {
        // Catch response error
        /*
        // When server turns 403 Unauthorized, redo firebase login
        // (hypothetical case for the moment)
        if (error.response?.statusCode == 403) {
          _dio.interceptors.requestLock.lock();
          _dio.interceptors.responseLock.lock();

          RequestOptions options = error.response.request;
          await _login(); // gets new access & refresh token

          _dio.interceptors.requestLock.unlock();
          _dio.interceptors.responseLock.unlock();
          return _dio.request(options.path, options: options);
        } else {
          return error;
        }*/
        throw HttpException(error.response?.reasonPhrase ?? error.response?.statusCode.toString());
    }));
    return _dio;
  }

  Future<void> _login() async {
    var user = await _firebaseAuth.userStream.first;

    Dio client = _getClient();

    Response response = await client.post('/user/login', data: {
      'email': user!.email,
      'token': await user.getIdToken(),
    });
  }
}
