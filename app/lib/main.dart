import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

import 'widgets/heatmap/src/data/heatmap_color_mode.dart';
import 'widgets/heatmap/src/heatmap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      title: 'Schedurio',
      theme: MacosThemeData.light(),
      darkTheme: MacosThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const WidgetGallery(),
    );
  }
}

class WidgetGallery extends StatefulWidget {
  const WidgetGallery({super.key});

  @override
  State<WidgetGallery> createState() => _WidgetGalleryState();
}

class _WidgetGalleryState extends State<WidgetGallery> {
  double ratingValue = 0;
  double sliderValue = 0;
  bool value = false;

  int pageIndex = 0;

  late final searchFieldController = TextEditingController();

  final List<Widget> pages = [
    MacosScaffold(
      children: [
        ContentArea(builder: (context, scrollController) {
          return Container(
            color: MacosTheme.of(context).dividerColor.withOpacity(0.1),
            padding: const EdgeInsets.all(20),
            child: HeatMap(
              size: 14,
              fontSize: 12,
              startDate: DateTime(2022, 5, 11),
              textColor: Colors.white,
              defaultColor: Colors.grey.shade300,
              scrollable: true,
              showColorTip: false,
              datasets: {DateTime(2023, 2, 12): 3},
              colorMode: ColorMode.opacity,
              showText: false,
              colorsets: const {
                1: Colors.blue,
              },
              onClick: (value) async {},
            ),
          );
        }),
      ],
    )
  ];

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
            "Ansh rathod's Twitter",
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
          bottom: const MacosListTile(
            leading: MacosIcon(CupertinoIcons.profile_circled),
            title: Text('Ansh Rathod'),
            subtitle: Text('@anshrathodfr'),
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
