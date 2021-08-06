import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oneplace_illinois/src/misc/config.dart';
import 'package:oneplace_illinois/src/misc/exceptions.dart';
import 'package:oneplace_illinois/src/misc/cookieManager.dart';
import 'package:oneplace_illinois/src/services/firebaseAuth.dart';

class ApiService {
  // NOTE: Signed cookie doesn't work with HTTP request. Only works with HTTPS.
  static final _baseUrl = Uri.https(Config.baseEndpoint!);

  final Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;

  static PersistCookieJar _cookieJar = PersistCookieJar(
    ignoreExpires: false, // don't save/load expired cookies
    storage: FileStorage(appDocPath + '/.cookies/')
  );

  final storage = new FlutterSecureStorage(); // for storing access token

  FirebaseAuthService _firebaseAuth;

  ApiService({required firebaseAuth}) : this._firebaseAuth = firebaseAuth;


  Future<Dio> _getClient() async {
    final Dio _dio = Dio();

    _dio.options.baseUrl = _baseUrl + '/api/v1';
    _dio.interceptors.clear();

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options){
        return options;
      },
      onResponse: (Response response) {
        if (data['error'] != null) {
          log(data.toString());
          throw ApiException(data['error']);
        }

        Map<String, dynamic> data = jsonDecode(response.body);

        // save access token (refresh token is auto-saved by CookieManager above)
        if (data['payload'] && data['payload']['accessToken']) {
          await storage.write(key: 'jwt_access', value: _accessToken);
        }

        return data;
      },
      onError: (DioError e) {
        return e;
      }
    ));

    return _dio;
  }

  Future<Dio> _getClientWithAuth() async {
    // retrieve access token
    String _accessToken = await storage.read(key: 'jwt_access');

    if (_accessToken == null) {
      // interceptor from _getClient() used by _login() will auto-save
      // the new access & refresh token (for later requests) 
      await _login();
    }

    final Dio _dio = Dio();

    _dio.options.baseUrl = _baseUrl + '/api/v1';
    _dio.interceptors.clear();

    // Add cookie (refresh token) to interceptor
    _dio.interceptors.add(CookieManager(cookieJar));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) {
        // Add access token to interceptor
        options.headers['Authorization'] = 'Bearer ' + _accessToken;
        return options;
      },
      onResponse: (Response response) {
        Map<String, dynamic> data = jsonDecode(response.body);

        if (data['error'] != null) {
          log(data.toString());
          throw ApiException(data['error']);
        }

        // Save access token if new one is issued from the server
        if (data['payload'] && data['payload']['accessToken']) {
          await storage.write(key: 'jwt_access', value: _accessToken);
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
        throw HttpException(response.reasonPhrase ?? response.statusCode.toString());
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
