// ignore_for_file: public_member_api_docs

class AppConfig {
  /// hive keys
  static final hiveKeys = HiveKeys();

  /// hive box names
  static final hiveBoxNames = HiveBoxNames();
}

/// hive keys class
class HiveKeys {
  /// current user
  final String currentUser = 'currentUser';
}

/// Hive box names
class HiveBoxNames {
  /// current user box
  final String users = 'users';
  final String subscriptions = 'subscriptions';
}
