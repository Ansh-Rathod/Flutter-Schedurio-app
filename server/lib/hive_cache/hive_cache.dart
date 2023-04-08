// ignore_for_file: public_member_api_docs

import 'package:hive/hive.dart';
import 'package:schedurio_utils/schedurio_utils.dart';
import 'package:server/server_config.dart';

/// localcache is a class that implements HiveContract and is used to access the hive box methods
class LocalCache {
  /// users box
  static late HiveContract<dynamic> users;
  static late HiveContract<List<String>> subscriptions;

  ///  checks if Localcache is initialized or not
  static bool isInitialized = false;

  /// init hive box
  static Future<void> init() async {
    Hive.init(ServerConfig.hiveDbPath);
    users = HiveStorageImplementation(
      await Hive.openBox(ServerConfig.hiveBoxNames.users),
    );

    subscriptions = HiveStorageImplementation(
      await Hive.openBox(ServerConfig.hiveBoxNames.subscriptions),
    );

    isInitialized = true;
  }
}
