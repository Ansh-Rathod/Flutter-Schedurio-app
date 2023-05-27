import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/helpers.dart';
import 'package:schedurio/services/hive_cache.dart';

import '../../widgets/heatmap/src/data/heatmap_color_mode.dart';
import '../../widgets/heatmap/src/heatmap.dart';
import '../../widgets/tweet/tweet.dart';
import 'cubit/analytics_screen_cubit.dart';

class AnalyticScreen extends StatefulWidget {
  const AnalyticScreen({super.key});

  @override
  State<AnalyticScreen> createState() => AnalyticScreenState();
}

class AnalyticScreenState extends State<AnalyticScreen> {
  final dataKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        height: 45,
        title: const Text(
          "Overview",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        titleWidth: 250,
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
        ContentArea(
          builder: (context, s) => BlocProvider(
            create: (context) => AnalyticsScreenCubit()..init(),
            child: BlocBuilder<AnalyticsScreenCubit, AnalyticsScreenState>(
              builder: (context, state) {
                return Container(
                  color: MacosTheme.of(context).canvasColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: MacosTheme.brightnessOf(context) !=
                                    Brightness.dark
                                ? const Color(0xfff1f0f5)
                                : const Color(0xff2e2e2e),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Tweets Heatmap",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      MacosPopupButton<String>(
                                        value: state.startDate.year.toString(),
                                        onChanged: (String? newValue) {
                                          BlocProvider.of<AnalyticsScreenCubit>(
                                                  context)
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
                                              BlocProvider.of<
                                                          AnalyticsScreenCubit>(
                                                      context)
                                                  .toggleCount();
                                            },
                                          ),
                                          MacosPulldownMenuItem(
                                            title: const Text('Share'),
                                            onTap: () {},
                                          ),
                                          const MacosPulldownMenuDivider(),
                                          MacosPulldownMenuItem(
                                            enabled: false,
                                            title: const Text('Export'),
                                            onTap: () =>
                                                debugPrint("Exporting"),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Tweets',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: MacosTheme.brightnessOf(
                                                      context) ==
                                                  Brightness.dark
                                              ? Colors.grey.shade300
                                              : MacosColors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          LocalCache.tweets.values.length
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'In ${state.startDate.year.toString()}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: MacosTheme.brightnessOf(
                                                      context) ==
                                                  Brightness.dark
                                              ? Colors.grey.shade300
                                              : MacosColors.black,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Longest streak',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: MacosTheme.brightnessOf(
                                                      context) ==
                                                  Brightness.dark
                                              ? Colors.grey.shade300
                                              : MacosColors.black,
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
                                textColor: MacosTheme.brightnessOf(context) ==
                                        Brightness.dark
                                    ? Colors.grey.shade300
                                    : MacosColors.black,
                                //  Colors.grey.shade300,
                                defaultColor:
                                    MacosTheme.brightnessOf(context) ==
                                            Brightness.dark
                                        ? Colors.grey.withOpacity(0.2)
                                        : Colors.grey.withOpacity(0.4),
                                //  Colors.grey.withOpacity(0.2),
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
                                onClick: (value) async {
                                  BlocProvider.of<AnalyticsScreenCubit>(context)
                                      .openModel(value);
                                  await Scrollable.ensureVisible(
                                      dataKey.currentContext!,
                                      duration:
                                          const Duration(milliseconds: 600));
                                },
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          key: dataKey,
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: Text(
                            state.selectedDate == null
                                ? "All Tweets"
                                : "${state.tweets.length} Tweets on ${state.selectedDate!.formatedString()}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: MacosTheme.brightnessOf(context) ==
                                      Brightness.dark
                                  ? Colors.grey.shade300
                                  : MacosColors.black,
                            ),
                          ),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.tweets.length + 1,
                          itemBuilder: (context, i) {
                            if (i == state.tweets.length) {
                              return const SizedBox(
                                height: 500,
                              );
                            }
                            return TweetWidget(
                              key: ValueKey(state.tweets[i].id),
                              tweet: state.tweets[i],
                              fullFormate: state.selectedDate == null,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
