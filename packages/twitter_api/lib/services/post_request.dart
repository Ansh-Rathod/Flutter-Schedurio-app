import 'dart:convert';
import 'dart:typed_data';

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

Future<dynamic> httpGet(
  String url,
  Map<String, dynamic> authParams,
  String apiKey,
  String apiSecretKey,
  String tokenSecret,
) async {
  try {
    final signature = Signature(
      url: url,
      params: authParams,
      apiKey: apiKey,
      method: "GET",
      apiSecretKey: apiSecretKey,
      tokenSecretKey: tokenSecret,
    );
    authParams['oauth_signature'] = signature.signatureHmacSha1();
    final header = generateAuthHeader(authParams);

    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': header!,
      },
    );

    if (res.statusCode != 200) {
      return {"statusCode": res.statusCode, "message": res.reasonPhrase};
    }
    return jsonDecode(res.body);
  } catch (e) {
    rethrow;
  }
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

    final res = await http.post(
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

/// uploads media to twitter
Future<dynamic> httpPostMedia(
  String url,
  Uint8List body,
  Map<String, dynamic> authParams,
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

    // final data = http.MultipartFile.fromBytes(
    //   'media_data',
    //   body,
    //   filename: 'media_data',
    // );

    final res = http.MultipartRequest(
      'POST',
      Uri.parse(
        url,
      ),
    );

    res.fields.addAll({
      'media_data': base64Encode(body),
    });
    res.headers['Authorization'] = header!;
    res.headers['Content-Type'] = 'multipart/form-data';
    final response = await res.send();

    final resstr = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      print(resstr);
      return {
        'statusCode': response.statusCode,
        'message': response.reasonPhrase,
      };
    }
    final mediaId = jsonDecode(resstr)['media_id'];
    return {
      'statusCode': 200,
      'id': mediaId,
      'message': 'Done',
    };
  } catch (e) {
    return {
      'statusCode': 500,
      'message': 'INTERNAL SERVER ERROR',
    };
  }
}
