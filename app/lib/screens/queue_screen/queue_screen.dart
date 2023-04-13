// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/helpers.dart';
import 'package:schedurio/screens/create_tweet/create_tweet.dart';
import 'package:schedurio/services/hive_cache.dart';

import '../../config.dart';
import '../../supabase.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  ValueListenable get listenable =>
      Hive.box(AppConfig.hiveBoxNames.queue).listenable();

  @override
  void initState() {
    listenable.addListener(() {
      print("value");
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
        toolBar: ToolBar(
          height: 45,
          title: const Text(
            "Queue",
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
          ContentArea(
            builder: (context, scrollController) => Container(
              color: MacosTheme.of(context).canvasColor,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 30,
                      itemBuilder: (context, i) {
                        final dateTime = DateTime.now().add(Duration(days: i));
                        final times =
                            LocalCache.schedule.get(dateTime.getWeekDayName());

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dateTime.getQueueString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: times.length,
                              itemBuilder: (context, i) {
                                final time = TimeOfDay(
                                    hour: int.parse(times[i].split(':')[0]),
                                    minute: int.parse(times[i].split(':')[1]));
                                final isAfter = DateTime(
                                        dateTime.year,
                                        dateTime.month,
                                        dateTime.day,
                                        time.hour,
                                        time.minute)
                                    .isBefore(DateTime.now());

                                final getTweet = LocalCache.queue.get(DateTime(
                                        dateTime.year,
                                        dateTime.month,
                                        dateTime.day,
                                        time.hour,
                                        time.minute)
                                    .toUtc()
                                    .toString());

                                return Opacity(
                                  opacity: isAfter ? 0.5 : 1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color:
                                            MacosTheme.brightnessOf(context) !=
                                                    Brightness.dark
                                                ? const Color(0xfff1f0f5)
                                                : const Color(0xff2e2e2e),
                                      ),
                                      padding: const EdgeInsets.all(20),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                time.format(context),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 7,
                                              ),
                                              if (getTweet != null &&
                                                  getTweet.length > 1)
                                                Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 4,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          MacosTheme.of(context)
                                                              .canvasColor),
                                                  child: Text(
                                                    getTweet != null &&
                                                            getTweet.length > 1
                                                        ? "Thread"
                                                        : "",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                )
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          if (getTweet != null)
                                            Expanded(
                                              child: QueueTweet(
                                                tweet: getTweet,
                                              ),
                                            ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          if (getTweet != null && !isAfter)
                                            MacosPulldownButton(
                                                icon: CupertinoIcons.ellipsis,
                                                items: [
                                                  const MacosPulldownMenuItem(
                                                    title: Text("Post now"),
                                                  ),
                                                  const MacosPulldownMenuDivider(),
                                                  MacosPulldownMenuItem(
                                                    onTap: () async {
                                                      await LocalCache.queue
                                                          .remove(DateTime(
                                                                  dateTime.year,
                                                                  dateTime
                                                                      .month,
                                                                  dateTime.day,
                                                                  time.hour,
                                                                  time.minute)
                                                              .toUtc()
                                                              .toString());

                                                      await supabase
                                                          .from('queue')
                                                          .delete()
                                                          .eq(
                                                              'scheduled_at',
                                                              DateTime(
                                                                      dateTime
                                                                          .year,
                                                                      dateTime
                                                                          .month,
                                                                      dateTime
                                                                          .day,
                                                                      time.hour,
                                                                      time.minute)
                                                                  .toUtc()
                                                                  .toString());
                                                    },
                                                    title: const Text("Delete"),
                                                  ),
                                                  MacosPulldownMenuItem(
                                                    title: const Text("Edit"),
                                                    onTap: () {
                                                      print("hee");

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              CreateTweet(
                                                            tweets: getTweet,
                                                            selected: DateTime(
                                                                    dateTime
                                                                        .year,
                                                                    dateTime
                                                                        .month,
                                                                    dateTime
                                                                        .day,
                                                                    time.hour,
                                                                    time.minute)
                                                                .toUtc(),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ])
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ]);
  }
}

class QueueTweet extends StatelessWidget {
  final dynamic tweet;
  const QueueTweet({
    Key? key,
    required this.tweet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (tweet[0]['content'].isNotEmpty)
                Flexible(
                  child: Text(
                    tweet[0]['content'],
                    maxLines: 2,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: MacosTheme.brightnessOf(context) == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),
              if (tweet[0]['media'].isNotEmpty) ...[
                if (tweet[0]['content'].isNotEmpty)
                  const SizedBox(
                    height: 10,
                  ),
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var file in tweet[0]['media'])
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Stack(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: MacosTheme.of(context).dividerColor,
                                  ),
                                  child: file['type'] == 'video'
                                      ? Container()
                                      : ExtendedImage.network(
                                          file['url'],
                                          fit: BoxFit.cover,
                                          loadStateChanged:
                                              (ExtendedImageState state) {
                                            if (state.extendedImageLoadState ==
                                                LoadState.loading) {
                                              return Container(
                                                color: MacosTheme.of(context)
                                                    .dividerColor,
                                                child: const ProgressCircle(
                                                    value: null),
                                              );
                                            }
                                            return null;
                                          },
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                ),
                                Positioned(
                                  bottom: 2,
                                  left: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        file['type'] == 'video'
                                            ? 'VID'
                                            : file['type'] == 'gif'
                                                ? 'GIF'
                                                : 'IMG',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}
