import '../../schedurio_utils.dart';

class ConvertTwitterResponse {
  static List<TweetModel> toTweetModel(dynamic data) {
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
