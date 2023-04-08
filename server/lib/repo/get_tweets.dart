import 'package:dio/dio.dart';
import 'package:schedurio_utils/schedurio_utils.dart';

class GetTweets {
  static Dio dio = Dio();

  List<TweetModel> convertResponse(dynamic data) {
    // final headers = {
    //   'Content-Type': 'application/json',
    //   'Authorization':
    //       'Bearer AAAAAAAAAAAAAAAAAAAAACNmggEAAAAAFRU6DxkolQw52kT0bp5tGQPLfP0%3D4NTdXlWJ8zIU87U0p9q9OhKIUL5ybSQve4cFbo8ZOeXK2ICFlU',
    // };
    // final response = await dio.get(
    //   'https://api.twitter.com/2/users/$userId/tweets?exclude=replies,retweets&max_results=100&media.fields=alt_text,duration_ms,height,media_key,non_public_metrics,organic_metrics,preview_image_url,promoted_metrics,public_metrics,type,url,variants,width&tweet.fields=author_id,created_at,public_metrics,text,attachments&expansions=attachments.media_keys,attachments.poll_ids&poll.fields=duration_minutes,end_datetime,id,options,voting_status',
    //   options: Options(headers: headers),
    // );

    final tweets = data['data'] as List<Map<String, dynamic>>;
    final media = (data['includes'] as Map).containsKey('media')
        ? (data['includes'] as Map)['media'] as List<Map<String, dynamic>>
        : [];
    final polls = (data['includes'] as Map).containsKey('polls')
        ? (data['includes'] as Map)['polls'] as List<Map<String, dynamic>>
        : [];

    final alltweets = [];
    for (final tweet in tweets) {
      final newTweet = <String, dynamic>{};
      newTweet['id'] = tweet['id'];
      newTweet['text'] = tweet['text'];
      newTweet['created_at'] = tweet['created_at'];
      newTweet['public_metrics'] = tweet['public_metrics'];
      newTweet['author_id'] = tweet['author_id'];

      if (tweet.containsKey('attachments')) {
        if ((tweet['attachments'] as Map).containsKey('media_keys')) {
          final mediaList = [];
          for (final i in tweet['attachments']['media_keys'] as List<dynamic>) {
            final mediaKey = media.firstWhere(
              (element) => element['media_key'] == i,
            );
            mediaList.add(mediaKey);
          }
          newTweet['media'] = mediaList;
        } else {
          newTweet['media'] = [];
        }
        if ((tweet['attachments'] as Map).containsKey('poll_ids')) {
          final mediaList = [];
          for (final i in tweet['attachments']['poll_ids'] as List<dynamic>) {
            final mediaKey = polls.firstWhere(
              (element) => element['id'] == i,
            );
            mediaList.add(mediaKey);
          }
          newTweet['poll'] = mediaList;
        } else {
          newTweet['poll'] = [];
        }
      } else {
        newTweet['media'] = [];
        newTweet['poll'] = [];
      }
      alltweets.add(newTweet);
    }
    return alltweets.map(TweetModel.fromJson).toList();
  }
}
