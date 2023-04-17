// ignore_for_file: unnecessary_await_in_return

import 'dart:typed_data';

import 'package:upload_media_server/twitter_api/post_request.dart';
import 'package:upload_media_server/twitter_api/signature.dart';

/// twitter api class
class TwitterApi {
  /// url
  static String uploadMediaUrl =
      'https://upload.twitter.com/1.1/media/upload.json';

  ///uploads media to twitter
  static Future<dynamic> uploadMedia({
    required String apiKey,
    required String apiSecretKey,
    required String oauthToken,
    required String tokenSecret,
    required Uint8List body,
    required String mediaType,
  }) async {
    return await httpPostMedia(
      '$uploadMediaUrl?media_category=$mediaType',
      body,
      requestHeader(
        apiKey: apiKey,
        oauthToken: oauthToken,
      ),
      apiKey,
      apiSecretKey,
      tokenSecret,
    );
  }
}
