import 'dart:developer';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/options.dart' as dioOptions;
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oneplace_illinois/src/misc/config.dart';
import 'package:oneplace_illinois/src/misc/exceptions.dart';
import 'package:oneplace_illinois/src/models/feedItem.dart';
import 'package:oneplace_illinois/src/models/sectionItem.dart';
import 'package:oneplace_illinois/src/services/apiService.dart';

class AccountProvider extends ChangeNotifier {
  final APIService api = APIService();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  String? jwt;
  bool working = false;

  List<SectionItem> followedSections = [];
  List<FeedItem> feedItems = [];

  Future<void> init() async {
    working = true;
    notifyListeners();

    await api.init();
    jwt = await api.getJwt();
    notifyListeners();
    api.interceptors.add(
      InterceptorsWrapper(
        onResponse: (Response<dynamic> response,
            ResponseInterceptorHandler handler) async {
          if (response.data['error'] != null) {
            log(response.data.toString());
            throw ApiException(response.data['error']);
          }

          dynamic payload = response.data["payload"];

          // save access token (refresh token is auto-saved by CookieManager above)
          if (payload.isNotEmpty && payload != null) {
            if (payload?["accesstoken"] != null) {
              await storage.write(
                key: 'jwt_access',
                value: payload[0]['accessToken'],
              );
              jwt = payload[0]['accessToken'];
              notifyListeners();
            }
          }
          handler.resolve(response);
        },
      ),
    );
    await this.getFeed();
    await this.getSections();

    working = false;
    notifyListeners();
  }

  CookieJar get cookieJar => api.cookieJar;

  Future<List<FeedItem>> getFeed() async {
    Uri uri = Uri.http(Config.baseEndpoint!, "/api/v1/feed/list");

    final response = await api.getUri(
      uri,
      options: dioOptions.Options(
        headers: {"Authorization": "Bearer ${this.jwt}"},
      ),
    );

    if (response.statusCode != 200) {
      throw HttpException(response.statusCode.toString());
    }

    Map<String, dynamic> data = response.data;

    if (data['error'] != null) {
      log(data.toString());
      throw ApiException(data['error']);
    }

    if (List.from(data["payload"]).isEmpty) {
      feedItems = [];
      return feedItems;
    }

    feedItems =
        data['payload'].map<FeedItem>((e) => FeedItem.fromJSON(e)).toList();
    feedItems.sort((a, b) => a.postDate.compareTo(b.postDate));
    notifyListeners();
    return feedItems;
  }

  Future<List<SectionItem>> getSections() async {
    Uri uri = Uri.http(Config.baseEndpoint!, "/api/v1/library/search");

    final response = await api.getUri(
      uri,
      options: dioOptions.Options(
        headers: {"Authorization": "Bearer $jwt"},
      ),
    );
    if (response.statusCode != 200) {
      throw HttpException(response.statusCode.toString());
    }
    Map<String, dynamic> data = response.data;
    if (data['error'] != null) {
      log(data.toString());
      throw ApiException(data['error']);
    }

    if (data["payload"]["library"].isEmpty) {
      followedSections = [];
      return followedSections;
    }

    followedSections =
        data['payload'].map((e) => SectionItem.fromJSON(e)).toList();
    return followedSections;
  }

  Future<void> signOut() async {
    this.feedItems = [];
    this.followedSections = [];
    this.jwt = null;
    await this.cookieJar.deleteAll();
    await this.storage.deleteAll();
    this.working = false;
  }
}
