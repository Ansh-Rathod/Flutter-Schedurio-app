import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/services/hive_cache.dart';
import 'package:schedurio/theme/cubit/theme_provider_cubit.dart';

import '../../config.dart';
import '../../main.dart';
import '../posting_schedule/posting_schedule.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        height: 45,
        title: const Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        titleWidth: 150.0,
        actions: [
          ToolBarIconButton(
            label: 'Toggle Sidebar',
            icon: const MacosIcon(
              CupertinoIcons.sidebar_left,
            ),
            onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
            showLabel: false,
            tooltipMessage: 'Toggle Sidebar',
          ),
        ],
      ),
      children: [
        ContentArea(builder: (context, scrollController) {
          return BlocBuilder(
            bloc: BlocProvider.of<ThemeProviderCubit>(context),
            builder: (BuildContext context, ThemeProviderState state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: MacosTheme.brightnessOf(context) ==
                                  Brightness.dark
                              ? Border.all(
                                  color: const Color.fromARGB(255, 69, 69, 71))
                              : Border.all(
                                  color:
                                      const Color.fromARGB(255, 225, 224, 224)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: MacosTheme.brightnessOf(context) !=
                                  Brightness.dark
                              ? const Color(0xfff1f0f5)
                              : const Color(0xff2e2e2e),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "General",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const MacosPulldownMenuDivider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Theme",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                            "Enable night mode inside the app or use the system settings."
                                                .toUpperCase(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                              color: MacosTheme.brightnessOf(
                                                          context) ==
                                                      Brightness.dark
                                                  ? const Color(0xffa1a1a1)
                                                  : const Color(0xff6f6f6f),
                                            )),
                                      ],
                                    ),
                                  ),
                                  MacosPulldownButton(
                                      title: state.mode == ThemeMode.light
                                          ? "Light"
                                          : state.mode == ThemeMode.dark
                                              ? "Dark"
                                              : "System",
                                      items: [
                                        MacosPulldownMenuItem(
                                          onTap: () {
                                            BlocProvider.of<ThemeProviderCubit>(
                                                    context)
                                                .setTheme(ThemeMode.dark);
                                          },
                                          title: const Text("Dark"),
                                        ),
                                        MacosPulldownMenuItem(
                                          onTap: () {
                                            BlocProvider.of<ThemeProviderCubit>(
                                                    context)
                                                .setTheme(ThemeMode.light);
                                          },
                                          title: const Text("Light"),
                                        ),
                                        MacosPulldownMenuItem(
                                          onTap: () {
                                            BlocProvider.of<ThemeProviderCubit>(
                                                    context)
                                                .setTheme(ThemeMode.system);
                                          },
                                          title: const Text("System"),
                                        ),
                                      ]),
                                ],
                              ),
                            ),
                            const MacosPulldownMenuDivider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Account",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                            "You're logged in as ${LocalCache.currentUser.get(AppConfig.hiveKeys.username)}'s twitter account."
                                                .toUpperCase(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                              color: MacosTheme.brightnessOf(
                                                          context) ==
                                                      Brightness.dark
                                                  ? const Color(0xffa1a1a1)
                                                  : const Color(0xff6f6f6f),
                                            )),
                                      ],
                                    ),
                                  ),
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage: NetworkImage(
                                        LocalCache.currentUser.get(
                                            AppConfig.hiveKeys.profilePicture)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const PostingScheduleWidget(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: MacosTheme.brightnessOf(context) ==
                                  Brightness.dark
                              ? Border.all(
                                  color: const Color.fromARGB(255, 69, 69, 71))
                              : Border.all(
                                  color:
                                      const Color.fromARGB(255, 225, 224, 224)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: MacosTheme.brightnessOf(context) !=
                                  Brightness.dark
                              ? const Color(0xfff1f0f5)
                              : const Color(0xff2e2e2e),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "Danger Zone",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const MacosPulldownMenuDivider(),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Row(
                          //     children: [
                          //       Expanded(
                          //         child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           children: [
                          //             const Text(
                          //               "Delete local cache",
                          //               style: TextStyle(
                          //                 fontWeight: FontWeight.w400,
                          //                 fontSize: 16,
                          //               ),
                          //             ),
                          //             const SizedBox(
                          //               height: 3,
                          //             ),
                          //             Text(
                          //                 "Delete all local cache will be clear your queue and tweets from the app you have to pull them again."
                          //                     .toUpperCase(),
                          //                 style: TextStyle(
                          //                   fontWeight: FontWeight.w400,
                          //                   fontSize: 10,
                          //                   color: MacosTheme.brightnessOf(
                          //                               context) ==
                          //                           Brightness.dark
                          //                       ? const Color(0xffa1a1a1)
                          //                       : const Color(0xff6f6f6f),
                          //                 )),
                          //           ],
                          //         ),
                          //       ),
                          //       TextButton(
                          //         onPressed: () async {
                          //           await LocalCache.queue.clear();
                          //           await LocalCache.filledQueue.clear();
                          //           await LocalCache.schedule.clear();
                          //           await LocalCache.currentUser.put(
                          //               AppConfig.hiveKeys.walkThrough, null);
                          //           await LocalCache.twitterApi.clear();
                          //           await LocalCache.tweets.clear();
                          //         },
                          //         // buttonSize: ButtonSize.large,
                          //         child: const Text("CLEAR",
                          //             style: TextStyle(
                          //               color: Colors.red,
                          //               fontWeight: FontWeight.w400,
                          //               fontSize: 14,
                          //             )),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PushButton(
                                  color: Colors.red,
                                  onPressed: () async {
                                    await LocalCache.queue.clear();
                                    await LocalCache.filledQueue.clear();
                                    await LocalCache.schedule.clear();
                                    await LocalCache.currentUser.put(
                                        AppConfig.hiveKeys.walkThrough, null);
                                    await LocalCache.twitterApi.clear();
                                    SchedurioHome.restartApp(context);
                                  },
                                  buttonSize: ButtonSize.large,
                                  child: const Text("Logout",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        })
      ],
    );
  }
}
