import 'dart:convert';
import 'dart:typed_data';

import 'package:edge_http_client/edge_http_client.dart';
import 'package:http/http.dart' as http;

import '../models/signature.dart';

///
String? generateAuthHeader(Map<String, dynamic> params) {
  return 'OAuth ${params.keys.map((k) {
    return '$k="${Uri.encodeComponent(params[k] as String)}"';
  }).join(', ')}';
}

class TwitterApiResponse {
  final String? id;
  final int statusCode;
  final String? message;

  TwitterApiResponse({
    this.id,
    required this.statusCode,
    this.message,
  });
}

Future<TwitterApiResponse> httpPost(
  String url,
  Map<String, dynamic> authParams,
  Map<String, dynamic> body,
  String apiKey,
  String apiSecretKey,
  String tokenSecret,
) async {
  try {
    final signature = Signature(
      url: url,
      params: authParams,
      apiKey: apiKey,
      apiSecretKey: apiSecretKey,
      tokenSecretKey: tokenSecret,
    );
    authParams['oauth_signature'] = signature.signatureHmacSha1();
    print(authParams['oauth_signature']);
    final header = generateAuthHeader(authParams);

    final res = await EdgeHttpClient().post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {
        'Authorization': header!,
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode != 201) {
      return TwitterApiResponse(
        statusCode: res.statusCode,
        message: res.reasonPhrase,
      );
    }
    return TwitterApiResponse(
      statusCode: 200,
      message: 'Tweet created successfully',
      id: jsonDecode(res.body)['data']['id'],
    );
  } catch (e) {
    return TwitterApiResponse(
      statusCode: 500,
      message: 'INTERNAL SERVER ERROR',
    );
  }
}

Future<TwitterApiResponse> httpPostMedia(
  String url,
  Uint8List body,
  Map<String, dynamic> authParams,
  String apiKey,
  String apiSecretKey,
  String tokenSecret,
) async {
  final data = await http.runWithClient(() async {
    try {
      final signature = Signature(
        url: url,
        params: authParams,
        apiKey: apiKey,
        apiSecretKey: apiSecretKey,
        tokenSecretKey: tokenSecret,
      );
      authParams['oauth_signature'] = signature.signatureHmacSha1();
      print(authParams['oauth_signature']);
      final header = generateAuthHeader(authParams);

      final res = http.MultipartRequest(
        'POST',
        Uri.parse(
          url,
        ),
      );
      print(body);
      res.fields.addAll({
        'media_data': base64Encode(body),
      });
      res.headers['Authorization'] = header!;
      final response = await res.send();

      final resstr = await response.stream.bytesToString();

      if (response.statusCode != 200) {
        print(resstr);
        return TwitterApiResponse(
          statusCode: response.statusCode,
          message: resstr,
        );
      }
      final mediaId = jsonDecode(resstr)['media_id'];
      return TwitterApiResponse(
        statusCode: 200,
        message: 'Done',
        id: mediaId,
      );
    } catch (e) {
      return TwitterApiResponse(
        statusCode: 500,
        message: 'INTERNAL SERVER ERROR',
      );
    }
  }, () => EdgeHttpClient());
  return data;
}
