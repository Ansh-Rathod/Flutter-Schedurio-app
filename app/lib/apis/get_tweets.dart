import 'package:dio/dio.dart';
import 'package:schedurio_utils/schedurio_utils.dart';

import '../services/hive_cache.dart';

class GetTweets {
  static Dio dio = Dio();
  static Future<List<TweetModel>> fromServer(int page) async {
    final response = await dio.get('http://localhost:8080/tweets?page=$page');
    print(response.data['tweets']);
    for (var tweet in response.data['tweets']) {
      await LocalCache.tweets.put(tweet['id'], tweet);
    }

    return (response.data['tweets'] as List)
        .map((tweet) => TweetModel.fromJson(tweet))
        .toList();
  }
}
