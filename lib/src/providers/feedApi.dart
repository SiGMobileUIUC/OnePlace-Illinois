import 'dart:convert';
import 'dart:io';

import 'package:oneplace_illinois/src/misc/config.dart';
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

    dynamic data = jsonDecode(response.body)['payload'][0];
    List<FeedItem> feedItems = data.map((elem) => FeedItem.fromJSON(elem));
    return feedItems;
  }
}
