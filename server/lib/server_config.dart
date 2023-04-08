// ignore_for_file: public_member_api_docs

class ServerConfig {
  /// hive keys
  static final hiveKeys = HiveKeys();

  /// hive box names
  static final hiveBoxNames = HiveBoxNames();
  static const hiveDbPath = 'database/hive/';
  static const sqliteDbPath = 'database/sqlite/sqlite.db';
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
