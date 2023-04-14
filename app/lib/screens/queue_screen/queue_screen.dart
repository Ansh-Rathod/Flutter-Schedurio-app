// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/helpers.dart';
import 'package:schedurio/screens/queue_screen/cubit/queue_screen_cubit.dart';

import '../../config.dart';
import '../../models/queue_tweets.dart';
import '../../supabase.dart';
import '../edit_tweet/edit_tweet.dart';

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
      setState(() {});
      BlocProvider.of<QueueScreenCubit>(context).init();
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
              child: BlocBuilder<QueueScreenCubit, QueueScreenState>(
                builder: (context, state) {
                  if (state.status == FetchTweetsStatus.loading) {
                    return const Center(
                      child: ProgressCircle(value: null),
                    );
                  }
                  if (state.status == FetchTweetsStatus.error) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Something went wrong!"),
                          const SizedBox(
                            height: 10,
                          ),
                          PushButton(
                            buttonSize: ButtonSize.small,
                            child: const Text("Try again!"),
                            onPressed: () {
                              BlocProvider.of<QueueScreenCubit>(context).init();
                            },
                          )
                        ],
                      ),
                    );
                  }

                  if (state.status == FetchTweetsStatus.inital) {
                    return Container();
                  }

                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        ...state.queue
                            .map((queueItem) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      queueItem.dateTime.getQueueString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ...queueItem.times.map(
                                      (e) {
                                        final isAfter =
                                            e.fullDate.isBefore(DateTime.now());

                                        return Opacity(
                                          opacity: isAfter ? 0.5 : 1,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                color: MacosTheme.brightnessOf(
                                                            context) !=
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        e.time.format(context),
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 7,
                                                      ),
                                                      if (e.tweets != null &&
                                                          e.tweets!.length > 1)
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 4,
                                                                  vertical: 2),
                                                          decoration: BoxDecoration(
                                                              color: MacosTheme
                                                                      .of(context)
                                                                  .canvasColor),
                                                          child: Text(
                                                            e.tweets!.length > 1
                                                                ? "Thread"
                                                                : "",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: e.tweets != null
                                                        ? QueueTweetWidget(
                                                            tweet: e.tweets![0],
                                                          )
                                                        : Container(),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  if (e.tweets != null &&
                                                      !isAfter) ...[
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            final updayedTweets =
                                                                await showMacosSheet(
                                                                    barrierDismissible:
                                                                        true,
                                                                    context:
                                                                        context,
                                                                    builder: (_) =>
                                                                        MacosSheet(
                                                                          child:
                                                                              EditTweet(
                                                                            tweets:
                                                                                e.copy().tweets!,
                                                                            selected:
                                                                                queueItem.dateTime.toUtc(),
                                                                          ),
                                                                        ));
                                                            print(
                                                                updayedTweets);
                                                            if (updayedTweets !=
                                                                null) {
                                                              e.tweets =
                                                                  updayedTweets;
                                                            }
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                border: Border.all(
                                                                    color: MacosTheme.of(
                                                                            context)
                                                                        .dividerColor)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(6.0),
                                                              child: Icon(
                                                                Icons.edit,
                                                                size: 16,
                                                                color: MacosTheme.brightnessOf(
                                                                            context) ==
                                                                        Brightness
                                                                            .dark
                                                                    ? Colors
                                                                        .grey
                                                                        .shade300
                                                                    : MacosColors
                                                                        .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                              color: MacosTheme
                                                                      .of(context)
                                                                  .dividerColor)),
                                                      child:
                                                          MacosPulldownButton(
                                                              icon:
                                                                  CupertinoIcons
                                                                      .ellipsis,
                                                              items: [
                                                            const MacosPulldownMenuItem(
                                                              title: Text(
                                                                  "Post now"),
                                                            ),
                                                            const MacosPulldownMenuDivider(),
                                                            MacosPulldownMenuItem(
                                                              onTap: () async {
//TODO delete from the local cache
                                                                await supabase
                                                                    .from(
                                                                        'queue')
                                                                    .delete()
                                                                    .eq(
                                                                        'scheduled_at',
                                                                        queueItem
                                                                            .dateTime
                                                                            .toUtc()
                                                                            .toString());
                                                              },
                                                              title: const Text(
                                                                  "Delete"),
                                                            ),
                                                          ]),
                                                    )
                                                  ]
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
                                ))
                            .toList()
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ]);
  }
}

class QueueTweetWidget extends StatelessWidget {
  final QueueTweetModel tweet;
  const QueueTweetWidget({
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
              if (tweet.content.isNotEmpty)
                Flexible(
                  child: Text(
                    tweet.content,
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
              if (tweet.media.isNotEmpty) ...[
                if (tweet.content.isNotEmpty)
                  const SizedBox(
                    height: 10,
                  ),
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var file in tweet.media)
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
                                  child: file.type == 'video'
                                      ? Container()
                                      : ExtendedImage.network(
                                          file.url!,
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
                                        file.type,
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
