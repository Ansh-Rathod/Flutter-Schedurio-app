import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:postgres/postgres.dart';

import '../config.dart';

class Api {
  static Future<String> scheduleTask({
    required String name,
    required String expression,
    required String url,
    required String queueId,
    required String userId,
  }) async {
    final connection = PostgreSQLConnection(
      "db.${AppConfig.supabaseUrl.replaceAll('https://', '')}",
      5432,
      'postgres',
      username: 'postgres',
      password: AppConfig.dbPassowrd,
    );

    await connection.open();

    await connection.query('''
        select cron.schedule(
          '$name', 
          '$expression',
          \$\$
          select call_api('{"Content-Type": "application/json", "Authorization": "Bearer ${AppConfig.supabaseToken}"}','$url','{"queueId": "$queueId", "userId": "$userId","supabaseUrl":"${AppConfig.supabaseUrl}"}');
          \$\$
        );
      ''');
    await connection.close();

    return name;
  }

  static Future<void> updateMediaOnTweet({
    required String queueId,
    required String userId,
  }) async {
    final response = await http.post(
      Uri.parse(AppConfig.updateMediaOnTweetUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${AppConfig.supabaseToken}"
      },
      body: jsonEncode(
        {
          'supabaseUrl': AppConfig.supabaseUrl,
          'queueId': queueId,
          'userId': userId,
        },
      ),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update media on tweet');
    }
  }

  static Future<void> postTweet({
    required String queueId,
    required String userId,
  }) async {
    final response = await http.post(
      Uri.parse(AppConfig.postTweetUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${AppConfig.supabaseToken}"
      },
      body: jsonEncode(
        {
          'supabaseUrl': AppConfig.supabaseUrl,
          'queueId': queueId,
          'userId': userId,
        },
      ),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to post tweet');
    }
  }
}
