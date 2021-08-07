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

  /* void clear() {
    super.clear();
  }

  void close({bool force = false}) async {
    super.close(force: force);
  }

  Future<Response<T>> delete<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      dioOptions.Options? options,
      CancelToken? cancelToken}) async {
    
    return super.delete(
      path,
      cancelToken: cancelToken,
      data: data,
      options: options,
      queryParameters: queryParameters,
    );
  }

  Future<Response<T>> deleteUri<T>(Uri uri,
      {data, dioOptions.Options? options, CancelToken? cancelToken}) async {
    return super.deleteUri(
      uri,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response> download(String urlPath, savePath,
      {ProgressCallback? onReceiveProgress,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      bool deleteOnError = true,
      String lengthHeader = Headers.contentLengthHeader,
      data,
      dioOptions.Options? options}) async {
    return super.download(
      urlPath,
      savePath,
      data: data,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      deleteOnError: deleteOnError,
      lengthHeader: lengthHeader,
      options: options,
    );
  }

  Future<Response> downloadUri(Uri uri, savePath,
      {ProgressCallback? onReceiveProgress,
      CancelToken? cancelToken,
      bool deleteOnError = true,
      String lengthHeader = Headers.contentLengthHeader,
      data,
      dioOptions.Options? options}) async {
    return super.downloadUri(
      uri,
      savePath,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      deleteOnError: deleteOnError,
      lengthHeader: lengthHeader,
      data: data,
      options: options,
    );
  }

  Future<Response<T>> fetch<T>(RequestOptions requestOptions) {
    return super.fetch(requestOptions);
  }

  Future<Response<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters,
      dioOptions.Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress}) async {
    return super.get(
      path,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      options: options,
      queryParameters: queryParameters,
    );
  }

  Future<Response<T>> getUri<T>(Uri uri,
      {dioOptions.Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress}) async {
    return super.getUri(
      uri,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      options: options,
    );
  }

  Future<Response<T>> head<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      dioOptions.Options? options,
      CancelToken? cancelToken}) async {
    return super.head(
      path,
      cancelToken: cancelToken,
      data: data,
      options: options,
      queryParameters: queryParameters,
    );
  }

  Future<Response<T>> headUri<T>(Uri uri,
      {data, dioOptions.Options? options, CancelToken? cancelToken}) async {
    return super.headUri(
      uri,
      cancelToken: cancelToken,
      data: data,
      options: options,
    );
  }

  Interceptors get interceptors => super.interceptors;

  void lock() {
    super.lock();
  }

  Future<Response<T>> patch<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      dioOptions.Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    return super.patch(
      path,
      cancelToken: cancelToken,
      data: data,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      options: options,
      queryParameters: queryParameters,
    );
  }

  Future<Response<T>> patchUri<T>(Uri uri,
      {data,
      dioOptions.Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    return super.patchUri(
      uri,
      cancelToken: cancelToken,
      data: data,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      options: options,
    );
  }

  Future<Response<T>> post<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      dioOptions.Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    return super.post(
      path,
      cancelToken: cancelToken,
      data: data,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      options: options,
      queryParameters: queryParameters,
    );
  }

  Future<Response<T>> postUri<T>(Uri uri,
      {data,
      dioOptions.Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    return super.postUri(
      uri,
      cancelToken: cancelToken,
      data: data,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      options: options,
    );
  }

  Future<Response<T>> put<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      dioOptions.Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    return super.put(
      path,
      cancelToken: cancelToken,
      data: data,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      options: options,
      queryParameters: queryParameters,
    );
  }

  Future<Response<T>> putUri<T>(Uri uri,
      {data,
      dioOptions.Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    return super.putUri(
      uri,
      cancelToken: cancelToken,
      data: data,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      options: options,
    );
  }

  Future<Response<T>> request<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      dioOptions.Options? options,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    return super.request(path,
        cancelToken: cancelToken,
        data: data,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        options: options,
        queryParameters: queryParameters);
  }

  Future<Response<T>> requestUri<T>(Uri uri,
      {data,
      CancelToken? cancelToken,
      dioOptions.Options? options,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    return super.requestUri(
      uri,
      cancelToken: cancelToken,
      data: data,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      options: options,
    );
  }

  void unlock() {
    super.unlock();
  } */
}
