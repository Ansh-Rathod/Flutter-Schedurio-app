import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/animations/delayed_animation.dart';
import 'package:schedurio/config.dart';
import 'package:schedurio/main.dart';
import 'package:schedurio/services/hive_cache.dart';
import 'package:schedurio/widgets/authentication.dart';

import '../../widgets/about_walk_through.dart';
import '../../widgets/bring_your_tweets.dart';
import '../../widgets/get_api_keys.dart';
import '../../widgets/get_auth_result.dart';

class WalkThroughScreen extends StatefulWidget {
  const WalkThroughScreen({super.key});

  @override
  State<WalkThroughScreen> createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  bool showButton = false;

  @override
  Widget build(BuildContext context) {
    return PlatformMenuBar(
      menus: const [
        PlatformMenu(
          label: 'Schedurio',
          menus: [
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.about,
            ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.quit,
            ),
          ],
        ),
        PlatformMenu(
          label: 'View',
          menus: [
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.toggleFullScreen,
            ),
          ],
        ),
        PlatformMenu(
          label: 'Window',
          menus: [
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.minimizeWindow,
            ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.zoomWindow,
            ),
          ],
        ),
      ],
      child: MacosWindow(
        titleBar: const TitleBar(
          height: 35,
          title: Text(
            "Schedurio",
            style: TextStyle(fontSize: 14),
          ),
        ),
        child: Builder(builder: (context) {
          final walkThrough =
              LocalCache.currentUser.get(AppConfig.hiveKeys.walkThrough);

          if (walkThrough == null) {
            return AboutWalkThrough(
              onNext: () {
                Navigator.pushReplacement(
                    context, createRoute(const AppLayout()));
              },
            );
          } else if (walkThrough == 'api_keys') {
            return GetApiKeys(
              onNext: () => setState(() {}),
            );
          } else if (walkThrough == 'authenticate') {
            return Authenticate(
              onNext: () => setState(() {}),
            );
          } else if (walkThrough == 'get_auth_result') {
            return GetAuthResult(
              onNext: () => setState(() {}),
            );
          } else if (walkThrough == 'tweets') {
            return GetTweetsWidget(
              onNext: () => setState(() {}),
            );
          }
          return Container();
        }),
      ),
    );
  }
}
