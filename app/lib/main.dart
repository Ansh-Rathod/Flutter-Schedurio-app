import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/screens/home/home_screen.dart';

import 'config.dart';
import 'screens/walk_through/walk_through_screen.dart';
import 'services/hive_cache.dart';

void main() async {
  await LocalCache.init();
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
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: LocalCache.currentUser.get(AppConfig.hiveKeys.walkThrough) == 'done'
          ? const AppLayout()
          : const WalkThroughScreen(),
    );
  }
}

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  double ratingValue = 0;
  double sliderValue = 0;
  bool value = false;

  int pageIndex = 0;

  late final searchFieldController = TextEditingController();

  final List<Widget> pages = [const HomeScreen()];

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
        backgroundColor: const Color.fromARGB(255, 34, 32, 34),
        titleBar: const TitleBar(
          height: 35,
          title: Text(
            "Schedurio",
            style: TextStyle(fontSize: 14),
          ),
        ),
        sidebar: Sidebar(
          top: MacosSearchField(
            placeholder: 'Search',
            controller: searchFieldController,
            onResultSelected: (result) {
              switch (result.searchKey) {
                case 'Buttons':
                  setState(() {
                    pageIndex = 0;
                    searchFieldController.clear();
                  });
                  break;
                case 'Indicators':
                  setState(() {
                    pageIndex = 1;
                    searchFieldController.clear();
                  });
                  break;
                case 'Fields':
                  setState(() {
                    pageIndex = 2;
                    searchFieldController.clear();
                  });
                  break;
                case 'Colors':
                  setState(() {
                    pageIndex = 3;
                    searchFieldController.clear();
                  });
                  break;
                case 'Dialogs and Sheets':
                  setState(() {
                    pageIndex = 5;
                    searchFieldController.clear();
                  });
                  break;
                case 'Toolbar':
                  setState(() {
                    pageIndex = 6;
                    searchFieldController.clear();
                  });
                  break;
                case 'Selectors':
                  setState(() {
                    pageIndex = 7;
                    searchFieldController.clear();
                  });
                  break;
                default:
                  searchFieldController.clear();
              }
            },
            results: const [
              SearchResultItem('Buttons'),
              SearchResultItem('Indicators'),
              SearchResultItem('Fields'),
              SearchResultItem('Colors'),
              SearchResultItem('Dialogs and Sheets'),
              SearchResultItem('Toolbar'),
              SearchResultItem('Selectors'),
            ],
          ),
          minWidth: 200,
          builder: (context, scrollController) {
            return SidebarItems(
              currentIndex: pageIndex,
              onChanged: (i) => setState(() => pageIndex = i),
              scrollController: scrollController,
              itemSize: SidebarItemSize.large,
              items: [
                const SidebarItem(
                  leading: MacosIcon(CupertinoIcons.home),
                  label: Text('Home'),
                ),
                const SidebarItem(
                  leading: MacosIcon(CupertinoIcons.add),
                  label: Text('Create'),
                ),
                SidebarItem(
                  leading: const MacosIcon(CupertinoIcons.collections),
                  label: const Text('Queue'),
                  trailing: Text(
                    '2',
                    style: TextStyle(
                      color: MacosTheme.brightnessOf(context) == Brightness.dark
                          ? MacosColors.tertiaryLabelColor.darkColor
                          : MacosColors.tertiaryLabelColor,
                    ),
                  ),
                ),
                SidebarItem(
                  leading: const MacosIcon(CupertinoIcons.doc_plaintext),
                  label: const Text('Drafts'),
                  trailing: Text(
                    '3',
                    style: TextStyle(
                      color: MacosTheme.brightnessOf(context) == Brightness.dark
                          ? MacosColors.tertiaryLabelColor.darkColor
                          : MacosColors.tertiaryLabelColor,
                    ),
                  ),
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
                  leading: MacosIcon(CupertinoIcons.lightbulb),
                  label: Text('Tips'),
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
              backgroundImage: NetworkImage(LocalCache.currentUser
                  .get(AppConfig.hiveKeys.profilePicture)),
            ),
            title: Text(
                LocalCache.currentUser.get(AppConfig.hiveKeys.displayName)),
            subtitle:
                Text(LocalCache.currentUser.get(AppConfig.hiveKeys.username)),
          ),
        ),
        endSidebar: Sidebar(
          startWidth: 200,
          minWidth: 200,
          maxWidth: 300,
          shownByDefault: false,
          builder: (context, _) {
            return const Center(
              child: Text('End Sidebar'),
            );
          },
        ),
        child: IndexedStack(
          index: pageIndex,
          children: pages,
        ),
      ),
    );
  }
}
