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

  List<SectionItem>? sections;
  List<FeedItem>? feedItems;

  Future<void> init() async {
    working = true;
    notifyListeners();

    await this.api.init();
    jwt = await this.api.getJwt();
    notifyListeners();
    this.api.interceptors.add(
      InterceptorsWrapper(
        onResponse: (Response<dynamic> response,
            ResponseInterceptorHandler handler) async {
          if (response.data['error'] != null) {
            log(response.data.toString());
            throw ApiException(response.data['error']);
          }

          Map<String, dynamic> payload = response.data["payload"];

          // save access token (refresh token is auto-saved by CookieManager above)
          if (payload["accesstoken"] != null) {
            await storage.write(
              key: 'jwt_access',
              value: payload[0]['accessToken'],
            );
            jwt = payload[0]['accessToken'];
            notifyListeners();
          }
          handler.resolve(response);
        },
      ),
    );
    await updateLists();

    working = false;
    notifyListeners();
  }

  CookieJar get cookieJar => this.api.cookieJar;

  Future<void> updateLists() async {
    await this.getFeed();
    await this.getSections();
  }

  Future<List<FeedItem>?> getFeed() async {
    Uri uri = Uri.http(Config.baseEndpoint!, "/api/v1/feed/list", {
      "only_feeds": false.toString(),
    });

    final response = await this.api.getUri(
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

    if (List.from(data["payload"]["feeds"]).isEmpty) {
      feedItems = [];
      notifyListeners();
      return feedItems;
    }

    feedItems = data['payload']["feeds"]
        .map<FeedItem>((e) => FeedItem.fromJSON(e))
        .toList();
    feedItems!.sort((a, b) => a.postDate.compareTo(b.postDate));
    notifyListeners();
    return feedItems;
  }

  Future<List<SectionItem>?> getSections() async {
    Uri uri = Uri.http(Config.baseEndpoint!, "/api/v1/library/search");

    final response = await this.api.getUri(
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

    if (data["payload"]["library"].isEmpty) {
      sections = [];
      notifyListeners();
      return sections;
    }
    List<dynamic> dataSections = data['payload']['library'];

    sections = dataSections
        .map((e) => SectionItem.fromJSON(e["sectionData"]))
        .toList();
    notifyListeners();
    return sections;
  }

  Future<void> addSection(SectionItem sectionItem) async {
    Uri uri = Uri.http(Config.baseEndpoint!, "/api/v1/library/add");

    final response = await this.api.postUri(
      uri,
      options: dioOptions.Options(
        headers: {"Authorization": "Bearer ${this.jwt}"},
      ),
      data: {
        "course": sectionItem.course,
        "section": sectionItem.crn,
      },
    );

    if (response.statusCode != 200) {
      throw HttpException(response.statusCode.toString());
    }

    Map<String, dynamic> data = response.data;

    if (data['error'] != null || data["status"] != "success") {
      log(data.toString());
      throw ApiException(data['error']);
    }

    sections!.add(sectionItem);
    await this.updateLists();
  }

  Future<void> dropSection(SectionItem sectionItem) async {
    Uri uri = Uri.http(Config.baseEndpoint!, "/api/v1/library/drop");

    final response = await this.api.deleteUri(
      uri,
      options: dioOptions.Options(
        headers: {"Authorization": "Bearer ${this.jwt}"},
      ),
      data: {
        "course": sectionItem.course,
        "section": sectionItem.crn,
      },
    );

    if (response.statusCode != 200) {
      throw HttpException(response.statusCode.toString());
    }

    Map<String, dynamic> data = response.data;

    if (data['error'] != null || data["status"] != "success") {
      log(data.toString());
      throw ApiException(data['error']);
    }

    sections!.remove(sectionItem);
    await this.updateLists();
  }

  Future<void> signOut() async {
    this.feedItems = [];
    this.sections = [];
    this.jwt = null;
    await this.cookieJar.deleteAll();
    await this.storage.deleteAll();
    this.working = false;
  }
}
