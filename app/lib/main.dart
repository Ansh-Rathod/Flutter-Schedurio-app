import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/screens/analytics/analytics_screen.dart';
import 'package:schedurio/screens/create_tweet/create_tweet.dart';
import 'package:schedurio/screens/create_tweet/cubit/create_tweet_cubit.dart';
import 'package:schedurio/screens/drafts/cubit/drafts_screen_cubit.dart';
import 'package:schedurio/screens/drafts/drafts_screen.dart';
import 'package:schedurio/screens/posting_schedule/posting_schedule.dart';
import 'package:schedurio/screens/queue_screen/cubit/queue_screen_cubit.dart';
import 'package:window_size/window_size.dart';

import 'config.dart';
import 'screens/queue_screen/queue_screen.dart';
import 'services/hive_cache.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalCache.init();

  if (!kIsWeb) {
    if (Platform.isMacOS || Platform.isWindows) {
      setWindowTitle("Schedurio");
      setWindowMaxSize(const Size(1000, 600));
      setWindowMinSize(const Size(800, 500));
    }
  }
  runApp(const SchedurioApp());
}

class SchedurioApp extends StatelessWidget {
  const SchedurioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      title: 'Schedurio',
      theme: MacosThemeData.light(),
      darkTheme: MacosThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      // home: LocalCache.currentUser.get(AppConfig.hiveKeys.walkThrough) == 'done'
      // ? const AppLayout()
      // : const WalkThroughScreen(),
      home: const AppLayout(),
    );
  }
}

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int pageIndex = 0;

  final List<Widget> pages = [
    BlocProvider(
      create: (context) => CreateTweetCubit()..init(),
      child: const CreateTweet(),
    ),
    LocalCache.schedule.values.isEmpty
        ? const PostingScheduleWidget()
        : BlocProvider<QueueScreenCubit>(
            create: (context) => QueueScreenCubit()..init(),
            child: const QueueScreen(),
          ),
    BlocProvider(
      create: (context) => DraftsScreenCubit()..init(),
      child: const DraftsScreen(),
    ),
    const AnalyticScreen(),
    Container(),
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return MacosWindow(
      backgroundColor: const Color.fromARGB(255, 34, 32, 34),
      titleBar: const TitleBar(
        height: 35,
        title: Text(
          "Schedurio",
          style: TextStyle(fontSize: 14),
        ),
      ),
      sidebar: Sidebar(
        minWidth: 200,
        maxWidth: 200,
        dragClosed: false,
        builder: (context, scrollController) {
          return SidebarItems(
            currentIndex: pageIndex,
            onChanged: (i) => setState(() => pageIndex = i),
            scrollController: scrollController,
            itemSize: SidebarItemSize.large,
            items: [
              const SidebarItem(
                leading: MacosIcon(CupertinoIcons.add),
                label: Text('Create'),
              ),
              SidebarItem(
                  leading: const MacosIcon(CupertinoIcons.collections),
                  label: const Text('Queue'),
                  trailing: ValueListenableBuilder(
                    valueListenable:
                        Hive.box(AppConfig.hiveBoxNames.queue).listenable(),
                    builder: (conext, value, child) {
                      if (LocalCache.queue.values.isNotEmpty) {
                        return Text(
                          LocalCache.queue.values.length.toString(),
                          style: TextStyle(
                            color: MacosTheme.brightnessOf(context) ==
                                    Brightness.dark
                                ? MacosColors.tertiaryLabelColor.darkColor
                                : MacosColors.tertiaryLabelColor,
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  )),
              const SidebarItem(
                leading: MacosIcon(CupertinoIcons.doc_plaintext),
                label: Text('Drafts'),
              ),
              const SidebarItem(
                leading: MacosIcon(CupertinoIcons.graph_circle),
                label: Text('Analytics'),
              ),
              const SidebarItem(
                leading: MacosIcon(CupertinoIcons.clock),
                label: Text('History'),
              ),
              const SidebarItem(
                leading: MacosIcon(CupertinoIcons.star),
                label: Text('Favorites'),
              ),
              const SidebarItem(
                leading: MacosIcon(CupertinoIcons.settings),
                label: Text('Settings'),
              ),
            ],
          );
        },
        bottom: MacosListTile(
          leading: CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
                LocalCache.currentUser.get(AppConfig.hiveKeys.profilePicture)),
          ),
          title:
              Text(LocalCache.currentUser.get(AppConfig.hiveKeys.displayName)),
          subtitle:
              Text(LocalCache.currentUser.get(AppConfig.hiveKeys.username)),
        ),
      ),
      child: pages[pageIndex],
    );
  }
}
