// ignore_for_file: avoid_dynamic_calls, cast_nullable_to_non_nullable, inference_failure_on_function_invocation

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog/src/http_method.dart' as method;
import 'package:http/http.dart' as http;
import 'package:supabase/supabase.dart';
import 'package:twitter_api/models/queue_tweet_model.dart';
import 'package:twitter_api/twitter_api.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    if (context.request.method == method.HttpMethod.post) {
      if (!context.request.headers.containsKey('Authorization')) {
        return Response.json(
          body: {
            'status': 'ERROR',
            'message': 'Authorization header is missing',
          },
        );
      }

      final body = jsonDecode(await context.request.body());
      final serviceRole = (context.request.headers['Authorization'] as String)
          .replaceFirst('Bearer ', '');
      final supabaseUrl = body['supabaseUrl'];
      final supabase = SupabaseClient(
        supabaseUrl as String,
        serviceRole,
      );
      final queue =
          await supabase.from('queue').select().eq('id', body['queueId']);

      final userData = await supabase
          .from('info')
          .select('twitter')
          .eq('id', body['userId']);
      final authParams = userData.first['twitter'];

      final tweets = (queue.first['tweets'] as List<dynamic>)
          .map(QueueTweetModelEdge.fromMap)
          .toList();

      for (var i = 0; i < tweets.length; i++) {
        final tweet = tweets[i];
        final mediaIds = <String>[];

        for (final media in tweet.media) {
          final mediaIntList = await http.get(Uri.parse(media.url!));
          final mediaId = await TwitterApi.uploadMedia(
            apiKey: authParams['apiKey'] as String,
            apiSecretKey: authParams['apiSecretKey'] as String,
            oauthToken: authParams['oauthToken'] as String,
            mediaType: media.type,
            tokenSecret: authParams['oauthTokenSecret'] as String,
            body: mediaIntList.bodyBytes,
          );
          if (mediaId['statusCode'] != 200) {
            return Response.json(
              body: {
                'status': 'ERROR',
                'message': 'Media upload failed',
              },
            );
          }
          mediaIds.add(mediaId['id'].toString());
        }
        tweet.mediaIds = mediaIds;
      }
      await supabase
          .from('queue')
          .update({'tweets': tweets}).eq('id', body['queueId']);

      return Response.json(
        body: {'status': 'OK', 'message': 'Done'},
      );
    }
    return Response.json(
      body: {'status': 'ERROR', 'message': 'Method not allowed'},
    );
  } catch (e) {
    return Response.json(
      body: {
        'status': 'ERROR',
        'message': 'Something went wrong',
      },
    );
  }
}
