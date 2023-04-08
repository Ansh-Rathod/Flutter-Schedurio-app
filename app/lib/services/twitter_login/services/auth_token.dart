///The access token for using Twitter API.
class AuthToken {
  /// Oauth token
  final String _authToken;

  /// Oauth token secret
  final String _authTokenSecret;

  String get authToken => _authToken;
  String get authTokenSecret => _authTokenSecret;

  AuthToken(
    Map<String, dynamic> params,
  )   : _authToken = params['oauth_token'],
        _authTokenSecret = params['oauth_token_secret'];
}
