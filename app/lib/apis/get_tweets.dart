import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;
import 'package:schedurio_utils/schedurio_utils.dart';

import '../services/hive_cache.dart';

class GetTweets {
  static Dio dio = Dio();
  static Future<List<TweetModel>> fromServer(int page) async {
    final response = await dio.get('http://localhost:8080/tweets?page=$page');
    for (var tweet in response.data['tweets']) {
      await LocalCache.tweets.put(tweet['id'], tweet);
    }

    return (response.data['tweets'] as List)
        .map((tweet) => TweetModel.fromJson(tweet))
        .toList();
  }

  static Future<String> formateText(String text) async {
    RegExp exp = RegExp(r'https:\/\/t.co\/\S+');
    final matches = exp.allMatches(text);
    final urls = matches.map((e) => e.group(0)).toList();

    for (var url in urls) {
      final response = await dio.get(
        url!,
        options: Options(
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'
          },
          followRedirects: false,
        ),
      );

      var document = parser.parse(response.toString());
      String title = document.getElementsByTagName('title')[0].text;
      String uri = title.startsWith('http') ? title : '';

      if (uri.startsWith('https://twitter.com/')) {
        text = text.replaceAll(url, '');
      } else {
        text = text.replaceAll(url, uri);
      }
    }
    return text;
  }
}
