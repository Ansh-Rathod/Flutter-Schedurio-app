import 'dart:convert';

import 'package:edge_http_client/edge_http_client.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_functions/supabase_functions.dart';
import 'package:twitter_api/models/queue_tweet_model.dart';
import 'package:twitter_api/twitter_api.dart';
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
    final body = await request.json() as dynamic;
    final id = body['id'];

    final queue = await supabase.from('queue').select().eq('id', id);

    final userData = await supabase.from('info').select('twitter');

    final authParams = userData.first['twitter'];

    final tweets = (queue[0]['tweets'] as List<dynamic>)
        .map((e) => QueueTweetModelEdge.fromMap(e))
        .toList();

    for (var i = 0; i < tweets.length; i++) {
      final tweet = tweets[i];
      var mediaIds = [];

      for (var media in tweet.media) {
        print(media.type);
        final mediaIntList = await EdgeHttpClient().get(Uri.parse(media.url!));
        final mediaId = await TwitterApi.uploadMedia(
          apiKey: authParams['apiKey'],
          apiSecretKey: authParams['apiSecretKey'],
          oauthToken: authParams['oauthToken'],
          mediaType: media.type,
          oauthTokenSecret: authParams['oauthTokenSecret'],
          body: mediaIntList.bodyBytes,
        );
        if (mediaId.id == null) {
          print(mediaId.message);
          print(mediaId.statusCode);
          return Response.json({
            'error': 'Media upload failed',
            'message': mediaId.message,
          });
        }
        mediaIds.add(mediaId.id);
      }
      tweet.mediaIds = mediaIds;
    }

    await supabase.from('queue').update(
        {'tweets': tweets.map((e) => e.toJson()).toList()}).eq('id', id);

    return Response.json(tweets.map((e) => e.toJson()).toList());
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
