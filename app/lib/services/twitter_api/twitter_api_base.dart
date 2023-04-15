import 'package:schedurio/services/twitter_api/post_request.dart';
import 'package:schedurio/services/twitter_api/signature.dart';

class TwitterApi {
  static Future<dynamic> getAuthUser({
    required String apiKey,
    required String apiSecretKey,
    required String oauthToken,
    required String tokenSecret,
  }) async {
    final res = await httpGet(
      "https://api.twitter.com/2/users/me?user.fields=profile_image_url,verified",
      requestHeader(
        apiKey: apiKey,
        oauthToken: oauthToken,
      ),
      apiKey,
      apiSecretKey,
      tokenSecret,
    );
    return res;
  }

  static Future<dynamic> getTweets(
      {required String apiKey,
      required String apiSecretKey,
      required String oauthToken,
      required String tokenSecret,
      required String userId,
      required String? pageinationToken}) async {
    var url =
        "https://api.twitter.com/2/users/$userId/tweets?exclude=replies,retweets&max_results=100&media.fields=alt_text,duration_ms,height,media_key,preview_image_url,public_metrics,type,url,variants,width&tweet.fields=author_id,created_at,public_metrics,text,attachments&expansions=attachments.media_keys,attachments.poll_ids&poll.fields=duration_minutes,end_datetime,id,options,voting_status";

    if (pageinationToken != null) {
      url =
          "https://api.twitter.com/2/users/$userId/tweets?exclude=replies,retweets&max_results=100&media.fields=alt_text,duration_ms,height,media_key,preview_image_url,public_metrics,type,url,variants,width&tweet.fields=author_id,created_at,public_metrics,text,attachments&expansions=attachments.media_keys,attachments.poll_ids&poll.fields=duration_minutes,end_datetime,id,options,voting_status&pagination_token=$pageinationToken";
    }
    final res = await httpGet(
      url,
      requestHeader(
        apiKey: apiKey,
        oauthToken: oauthToken,
      ),
      apiKey,
      apiSecretKey,
      tokenSecret,
    );
    print(res);
    return res;
  }
}
