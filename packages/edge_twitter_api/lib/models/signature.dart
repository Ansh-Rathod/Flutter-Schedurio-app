import 'dart:convert';

import 'package:crypto/crypto.dart';

/// OAuth 1.0a HMAC-SHA1 signature for an HTTP request
class Signature {
  /// EndpointURL
  final String? url;

  /// Request method
  final String? method;

  /// Request Parameter
  final Map<String, dynamic>? params;

  /// Oauth Consumer Key
  final String? apiKey;

  /// Oauth　token secret
  final String? apiSecretKey;

  /// Oauth Consumer Secret Key
  final String? tokenSecretKey;

  /// constructor
  Signature({
    this.url,
    this.method = 'POST',
    this.params,
    this.apiKey,
    this.apiSecretKey,
    this.tokenSecretKey,
  });

  ///
  String? signatureHmacSha1() {
    final key = getSignatureKey();
    final text = signatureDate();
    final bytes = Hmac(sha1, key!.codeUnits).convert(text!.codeUnits).bytes;
    return base64.encode(bytes);
  }

  ///
  String? signatureDate() {
    final uri = Uri.parse(url!);
    final encodedParams = encodeParams(uri, params!);
    final sortedEncodedKeys = encodedParams!.keys.toList()..sort();
    final baseParams = sortedEncodedKeys.map((String k) {
      return '$k=${encodedParams[k]}';
    }).join('&');
    final base = appendParams(method!, uri, baseParams);
    return base;
  }

  /// Percent encode every key and value that will be signed and Sort
  /// the list of parameters alphabetically by encoded key.
  Map<String, dynamic>? encodeParams(Uri uri, Map<String, dynamic> params) {
    final encodedParams = <String, String>{};
    params.forEach((k, v) {
      encodedParams[Uri.encodeComponent(k)] = Uri.encodeComponent(v as String);
    });
    uri.queryParameters.forEach((k, v) {
      encodedParams[Uri.encodeComponent(k)] = Uri.encodeComponent(v);
    });
    return encodedParams;
  }

  /// Create a Http Request
  String? appendParams(
    String method,
    Uri uri,
    String baseParams,
  ) {
    final base = StringBuffer();
    base.write(method.toUpperCase());
    base.write('&');
    base.write(Uri.encodeComponent(uri.origin + uri.path));
    base.write('&');
    base.write(Uri.encodeComponent(baseParams));
    return base.toString();
  }

  /// create a signing key which will be used to generate the signature
  String? getSignatureKey() {
    final consumerSecret = Uri.encodeComponent(apiSecretKey!);
    final tokenSecret =
        tokenSecretKey != null ? Uri.encodeComponent(tokenSecretKey!) : '';
    return '$consumerSecret&$tokenSecret';
  }
}

Map<String, String?> requestHeader({
  String? apiKey,
  String? oauthToken = '',
  String? redirectURI = '',
  String? oauthVerifier = '',
}) {
  final dtNow = DateTime.now().millisecondsSinceEpoch;
  final params = {
    'oauth_consumer_key': apiKey,
    'oauth_token': oauthToken,
    'oauth_signature_method': 'HMAC-SHA1',
    'oauth_timestamp': (dtNow / 1000).floor().toString(),
    'oauth_nonce': dtNow.toString(),
    'oauth_version': '1.0',
  };
  if (redirectURI?.isNotEmpty ?? true) {
    params.addAll({'oauth_callback': redirectURI});
  }
  if (oauthVerifier?.isNotEmpty ?? true) {
    params.addAll({'oauth_verifier': oauthVerifier});
  }
  return params;
}
