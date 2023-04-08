import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/screens/home/cubit/home_screen_cubit.dart';
import 'package:schedurio/services/hive_cache.dart';

import '../../widgets/heatmap/src/data/heatmap_color_mode.dart';
import '../../widgets/heatmap/src/heatmap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeScreenCubit()..init(),
      child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
        builder: (context, state) {
          return Container(
            color: MacosTheme.of(context).canvasColor,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: MacosColors.windowBackgroundColor,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tweets Heatmap",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              MacosPopupButton<String>(
                                value: state.startDate.year.toString(),
                                onChanged: (String? newValue) {
                                  BlocProvider.of<HomeScreenCubit>(context)
                                      .changeDate(int.parse(newValue!));
                                },
                                items: state.years
                                    .map((e) => e.toString())
                                    .toList()
                                    .map<MacosPopupMenuItem<String>>(
                                        (String value) {
                                  return MacosPopupMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              MacosPulldownButton(
                                title: 'More',
                                // Or provide an icon to use as title:
                                items: [
                                  MacosPulldownMenuItem(
                                    title: const Text(
                                        'Show tweet count in heatmap'),
                                    onTap: () {
                                      BlocProvider.of<HomeScreenCubit>(context)
                                          .toggleCount();
                                    },
                                  ),
                                  MacosPulldownMenuItem(
                                    title: const Text('Share'),
                                    onTap: () =>
                                        debugPrint("Opening Save As dialog..."),
                                  ),
                                  const MacosPulldownMenuDivider(),
                                  MacosPulldownMenuItem(
                                    enabled: false,
                                    title: const Text('Export'),
                                    onTap: () => debugPrint("Exporting"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Divider(
                        color: MacosTheme.of(context).dividerColor,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Tweets',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: MacosTheme.brightnessOf(context) ==
                                          Brightness.dark
                                      ? Colors.grey.shade300
                                      : MacosColors.tertiaryLabelColor,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(LocalCache.tweets.values.length.toString(),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'In ${state.startDate.year.toString()}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: MacosTheme.brightnessOf(context) ==
                                          Brightness.dark
                                      ? Colors.grey.shade300
                                      : MacosColors.tertiaryLabelColor,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(state.noOftweets.toString(),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Longest streak',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: MacosTheme.brightnessOf(context) ==
                                          Brightness.dark
                                      ? Colors.grey.shade300
                                      : MacosColors.tertiaryLabelColor,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(state.longestStreak.toString(),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Container()
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Divider(
                        color: MacosTheme.of(context).dividerColor,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      HeatMap(
                        reverse: state.reverse,
                        size: 16,
                        scrollController: state.scrollController,
                        fontSize: 12,
                        startDate: state.startDate,
                        endDate: state.endDate,
                        textColor: Colors.grey.shade300,
                        defaultColor: Colors.grey.withOpacity(0.2),
                        scrollable: true,
                        showColorTip: true,
                        datasets: state.data,
                        colorMode: ColorMode.color,
                        showText: state.showCount,
                        colorsets: {
                          1: Colors.blue.withOpacity(0.4),
                          2: Colors.blue.withOpacity(0.7),
                          3: Colors.blue.withOpacity(0.9),
                          4: Colors.blue,
                          5: Colors.blue
                        },
                        onClick: (value) async {},
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Divider(
                        color: MacosTheme.of(context).dividerColor,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.local_fire_department_sharp,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(state.streak.toString(),
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ],
                              ))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
