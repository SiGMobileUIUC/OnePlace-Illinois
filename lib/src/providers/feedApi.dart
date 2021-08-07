import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:oneplace_illinois/src/misc/config.dart';
import 'package:oneplace_illinois/src/misc/exceptions.dart';
import 'package:oneplace_illinois/src/models/feedItem.dart';
import 'package:oneplace_illinois/src/services/api.dart';

class FeedAPI {
  static const feedListPath = Config.basePath + '/feed/list';

  Future<List<FeedItem>> getFeed(ApiService api) async {
    Uri uri = Uri.http(Config.baseEndpoint!, feedListPath);

    final response = await api.get(uri);
    if (response.statusCode != 200) {
      throw HttpException(
          response.reasonPhrase ?? response.statusCode.toString());
    }
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['error'] != null) {
      log(data.toString());
      throw ApiException(data['error']);
    }

    List<FeedItem> feedItems =
        data['payload'].map<FeedItem>((e) => FeedItem.fromJSON(e)).toList();
    feedItems.sort((a, b) => a.postDate.compareTo(b.postDate));
    return feedItems;
  }
}
