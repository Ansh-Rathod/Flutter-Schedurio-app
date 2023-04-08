// ignore_for_file: public_member_api_docs

class AppConfig {
  /// hive keys
  static final hiveKeys = HiveKeys();

  /// hive box names
  static final hiveBoxNames = HiveBoxNames();
}

/// hive keys class
class HiveKeys {
  // current user box
  /// NOTE:only use in currentUser box
  final String username = 'username';

  /// NOTE:only use in currentUser box
  final String userId = 'userId';

  /// NOTE:only use in currentUser box
  final String displayName = 'displayName';

  /// NOTE:only use in currentUser box
  final String email = 'email';

  /// NOTE:only use in currentUser box
  final String profilePicture = 'email';

  /// NOTE:only use in currentUser box
  final String walkThrough = 'walkThrough';

  // tweets box
  // twitterApiConfig box
  /// NOTE:only use in twitterAPi box
  final String apiKey = 'apiKey';

  /// NOTE:only use in twitterAPi box
  final String apiSecretKey = 'apiSecretKey';

  /// NOTE:only use in twitterAPi box
  final String authToken = 'AuthToken';

  /// NOTE:only use in twitterAPi box
  final String authSecretToken = 'AuthSecretToken';

  /// NOTE:only use in twitterAPi box
  final String redirectURI = 'redirectURI';
}

/// Hive box names
class HiveBoxNames {
  /// current user box
  final String currentUser = 'currentUser';
  final String twitterApiConfig = 'twitterApiConfig';
  final String tweets = 'tweets';
}
