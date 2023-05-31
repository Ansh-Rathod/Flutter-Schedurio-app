// ignore_for_file: public_member_api_docs

class AppConfig {
  /// hive keys
  static final hiveKeys = HiveKeys();

  /// hive box names
  static final hiveBoxNames = HiveBoxNames();

  /// UrLS
  static const String version = '1.0.1-beta';

  ///
  static const String supabaseUrl = 'https://<id>.supabase.co';

  static const String supabaseToken = "token";
  static const String dbPassowrd = 'supabase postgres db password';
  // Post tweeet BackendUrL
  static const String postTweetUrl = " backend server url to post tweet";
  static const String updateMediaOnTweetUrl =
      "backend server url to update media tweet url";

  ///
  static const String gitHubRepoUrl =
      'https://github.com/Ansh-Rathod/Flutter-Schedurio-app';
  static const String myWebsite = 'https://anshrathod.com';
  static const String schedurioWeb = 'https://schedurio.anshrathod.com';
  static const String contributionUrl =
      'https://github.com/Ansh-Rathod/Flutter-Schedurio-app/contribute.md';
  static const String issuesUrl =
      'https://github.com/Ansh-Rathod/Flutter-Schedurio-app/issues';
  static const String email = 'mailto:anshrathodfr@gmail.com';
  static const String github = 'https://github.com/Ansh-Rathod';
  static const String twitter = 'https://twitter.com/anshrathodfr';
  static const String linkedIn = 'https://www.linkedin.com/in/anshrathodfr/';
  static const String instagram = 'https://www.instagram.com/anshrathodfr/';
  static const String discordLink = 'https://discord.gg/QcStXmWVSm';
}

/// hive keys class
class HiveKeys {
  // current user box
  /// NOTE:only use in currentUser box
  final String username = 'username';

  /// NOTE:only use in currentUser box
  final String userId = 'userId';

  final String currenUserSupabaseId = 'currenUserSupabaseId';

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
