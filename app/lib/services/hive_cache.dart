// ignore_for_file: public_member_api_docs

import 'package:hive_flutter/hive_flutter.dart';
import 'package:schedurio_utils/schedurio_utils.dart';

import '../config.dart';

/// localcache is a class that implements HiveContract and is used to access the hive box methods
class LocalCache {
  /// users box
  static late HiveContract<dynamic> users;
  static late HiveContract<List<String>> subscriptions;

  ///  checks if Localcache is initialized or not
  static bool isInitialized = false;

  /// init hive box
  static Future<void> init() async {
    await Hive.initFlutter();
    users = HiveStorageImplementation(
      await Hive.openBox(AppConfig.hiveBoxNames.users),
    );

    subscriptions = HiveStorageImplementation(
      await Hive.openBox(AppConfig.hiveBoxNames.subscriptions),
    );

    isInitialized = true;
  }
}
