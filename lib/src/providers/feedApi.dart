import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oneplace_illinois/src/misc/config.dart';
import 'package:oneplace_illinois/src/misc/exceptions.dart';
import 'package:oneplace_illinois/src/models/feedItem.dart';
import 'package:oneplace_illinois/src/services/api.dart';

class FeedAPI {
  static const feedListPath = Config.basePath + '/feed/list';

  Future<List<FeedItem>> getFeed(ApiService api) async {
    Uri uri = Uri.http(Config.baseEndpoint!, feedListPath);

    final client = await api.getClientWithAuth();
    final data = await client.get('/feed/list', queryParameters: {}); // qs for later

    // NOTE: Does this catch case of empty feed list?
    List<FeedItem> feedItems =
        data['payload'].map<FeedItem>((e) => FeedItem.fromJSON(e)).toList();
    feedItems.sort((a, b) => a.postDate.compareTo(b.postDate));
    return feedItems;
  }
}
