// ignore_for_file: public_member_api_docs

class AppConfig {
  /// hive keys
  static final hiveKeys = HiveKeys();

  /// hive box names
  static final hiveBoxNames = HiveBoxNames();

  /// UrLS
  static const String version = '1.0.0-beta';

  ///
  static const String gitHubRepoUrl =
      'https://github.com/Ansh-Rathod/schedurio';
  static const String myWebsite = 'https://anshrathod.com';
  static const String schedurioWeb = 'https://schedurio.anshrathod.com';
  static const String contributionUrl =
      'https://github.com/Ansh-Rathod/schedurio/contribute.md';
  static const String issuesUrl =
      'https://github.com/Ansh-Rathod/schedurio/issues';
  static const String email = 'mailto:anshrathodfr@gmail.com';
  static const String github = 'https://github.com/Ansh-Rathod';
  static const String twitter = 'https://twitter.com/anshrathodfr';
  static const String linkedIn = 'https://www.linkedin.com/in/anshrathodfr/';
  static const String instagram = 'https://www.instagram.com/anshrathodfr/';
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
  final String verified = 'verified';

  /// NOTE:only use in currentUser box
  final String profilePicture = 'profilePicture';

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
  final String schedule = 'schedule';
  final String filledQueue = 'filled_queue';
  final String queue = 'queue';
}
