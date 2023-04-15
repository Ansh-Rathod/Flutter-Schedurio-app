// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/config.dart';
import 'package:schedurio/screens/posting_schedule/posting_schedule.dart';
import 'package:schedurio/services/hive_cache.dart';

import '../../widgets/about_walk_through.dart';
import '../../widgets/bring_your_tweets.dart';
import '../../widgets/get_api_keys.dart';

class WalkThroughScreen extends StatefulWidget {
  final Function() onDone;
  const WalkThroughScreen({
    Key? key,
    required this.onDone,
  }) : super(key: key);

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
                setState(() {});
              },
            );
          } else if (walkThrough == 'api_keys') {
            return GetApiKeys(
              onNext: () => setState(() {}),
            );
            // } else if (walkThrough == 'authenticate') {
            //   return Authenticate(
            //     onNext: () => setState(() {}),
            //   );
            // } else if (walkThrough == 'get_auth_result') {
            //   return GetAuthResult(
            //     onNext: () => setState(() {}),
            //   );
          } else if (walkThrough == 'tweets') {
            return GetTweetsWidget(
              onNext: () => setState(() {}),
            );
          } else if (walkThrough == 'posting_schedule') {
            return Container(
              constraints: const BoxConstraints(maxWidth: 500),
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: PostingScheduleWidget(
                  onNext: () async {
                    await LocalCache.currentUser
                        .put(AppConfig.hiveKeys.walkThrough, 'done');
                    setState(() {
                      widget.onDone();
                    });
                  },
                ),
              ),
            );
          } else if (walkThrough == 'done') {
            return Container();
          }
          return const SizedBox();
        }),
      ),
    );
  }
}
