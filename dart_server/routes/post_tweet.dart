// ignore_for_file: inference_failure_on_function_invocation, cast_nullable_to_non_nullable

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog/src/http_method.dart' as method;
import 'package:supabase/supabase.dart';
import 'package:twitter_api/models/queue_tweet_model.dart';
import 'package:twitter_api/twitter_api.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == method.HttpMethod.post) {
    if (!context.request.headers.containsKey('Authorization')) {
      return Response.json(
        body: {
          'status': 'ERROR',
          'message': 'Authorization header is missing',
        },
      );
    }

    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;

    final queueId = body['queueId'];
    final userId = body['userId'];

    final serviceRole = (context.request.headers['Authorization'] as String)
        .replaceFirst('Bearer ', '');
    final supabaseUrl = body['supabaseUrl'];
    final supabase = SupabaseClient(
      supabaseUrl as String,
      serviceRole,
    );
    try {
      final queue =
          await supabase.from('queue').select('tweets').eq('id', queueId);

      final tweets = (queue[0]['tweets'] as List<dynamic>)
          .map(QueueTweetModelEdge.fromMap)
          .toList();

      final userData =
          await supabase.from('info').select('twitter').eq('id', userId);

      final authParams = userData.first['twitter'] as Map<String, dynamic>;

      String? replyId;
      String? firstTweetID;
      for (final tweet in tweets) {
        final body = <String, dynamic>{
          'text': tweet.content,
        };

        if (tweet.mediaIds.isNotEmpty) {
          body['media'] = {'media_ids': tweet.mediaIds};
        }
        if (replyId != null) {
          body['reply'] = {'in_reply_to_tweet_id': replyId};
        }
        final id = await TwitterApi.postTweet(
          apiKey: authParams['apiKey'] as String,
          apiSecretKey: authParams['apiSecretKey'] as String,
          oauthToken: authParams['oauthToken'] as String,
          oauthTokenSecret: authParams['oauthTokenSecret'] as String,
          body: body,
        );
        if (id.id == null) {
          await supabase.from('queue').update({
            'status': 'error',
            'twitter_id': firstTweetID,
          }).eq('id', queueId);

          return Response.json(
            body: {
              'status': 'ERROR',
              'message': id.message,
            },
          );
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

      return Response.json(
        body: {
          'status': 'OK',
          'id': firstTweetID,
        },
      );
    } catch (e) {
      return Response.json(
        body: {
          'status': 'ERROR',
          'message': 'INTERNAL SERVER ERROR',
        },
      );
    }
  } else {
    return Response.json(
      body: {
        'status': 'ERROR',
        'message': 'Method not allowed',
      },
    );
  }
}
