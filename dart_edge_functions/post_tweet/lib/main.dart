import 'dart:convert';

import 'package:edge_http_client/edge_http_client.dart';
import 'package:edge_twitter_api/models/queue_tweet_model.dart';
import 'package:edge_twitter_api/twitter_api.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_functions/supabase_functions.dart';
import 'package:yet_another_json_isolate/yet_another_json_isolate.dart';

void main() {
  final supabase = SupabaseClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get(
        'SUPABASE_SERVICE_ROLE_KEY')!, // Use service role key to bypass RLS
    httpClient: EdgeHttpClient(),
    isolate: EdgeIsolate(),
  );

  SupabaseFunctions(fetch: (request) async {
    print("heee");
    final body = await request.json() as dynamic;

    print("yes");

    final queueId = body['queueId'];
    final userId = body['userId'];
    print("done");

    try {
      final queue =
          await supabase.from('queue').select('tweets').eq('id', queueId);

      print(queue);
      final tweets = (queue[0]['tweets'] as List<dynamic>)
          .map((e) => QueueTweetModelEdge.fromMap(e))
          .toList();

      final userData =
          await supabase.from('info').select('twitter').eq('id', userId);

      print(userData);
      final authParams = userData.first['twitter'];

      String? replyId;
      String? firstTweetID;
      for (var tweet in tweets) {
        Map<String, dynamic> body = {
          "text": tweet.content,
        };

        if (tweet.mediaIds.isNotEmpty) {
          body['media'] = {"media_ids": tweet.mediaIds};
        }
        if (replyId != null) {
          body['reply'] = {"in_reply_to_tweet_id": replyId};
        }
        final id = await TwitterApi.postTweet(
          apiKey: authParams['apiKey'],
          apiSecretKey: authParams['apiSecretKey'],
          oauthToken: authParams['oauthToken'],
          oauthTokenSecret: authParams['oauthTokenSecret'],
          body: body,
        );
        if (id.id == null) {
          print(id.message);
          print(id.statusCode);
          await supabase.from('queue').update({
            'status': 'error',
            'twitter_id': firstTweetID,
          }).eq('id', queueId);

          return Response.json({
            'status': 'ERROR',
            'message': id.message,
          });
        } else {
          replyId = id.id;
          if (tweets.indexOf(tweet) == 0) {
            firstTweetID = id.id;
          }
        }
      }
      await supabase.from('queue').update({
        'status': 'posted',
        'twitter_id': firstTweetID,
      }).eq('id', queueId);

      return Response.json({
        "status": "OK",
        'id': firstTweetID,
      });
    } catch (e) {
      return Response.json({
        'status': 'ERROR',
        'message': 'INTERNAL SERVER ERROR',
      });
    }
  });
}

class EdgeIsolate implements YAJsonIsolate {
  @override
  Future decode(String json) {
    return Future.value(jsonDecode(json));
  }

  @override
  Future<void> dispose() async {}

  @override
  Future<String> encode(Object? json) {
    return Future.value(jsonEncode(json));
  }

  @override
  Future<void> initialize() async {}
}
