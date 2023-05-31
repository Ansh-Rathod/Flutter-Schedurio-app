// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/models/queue_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../models/queue_tweets.dart';
import '../../screens/edit_tweet/edit_tweet.dart';

class QueueItemWidget extends StatefulWidget {
  final QueueDayTime e;
  final DateTime dateTime;
  final Future Function() onDelete;
  final Future Function(DateTime, List<QueueTweetModel>, DateTime) onPostNow;

  const QueueItemWidget({
    Key? key,
    required this.e,
    required this.dateTime,
    required this.onDelete,
    required this.onPostNow,
  }) : super(key: key);

  @override
  State<QueueItemWidget> createState() => _QueueItemWidgetState();
}

class _QueueItemWidgetState extends State<QueueItemWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final isAfter = widget.e.fullDate.isBefore(DateTime.now());

    return Opacity(
      opacity: isAfter ? 0.5 : 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: MacosTheme.brightnessOf(context) == Brightness.dark
                ? Border.all(color: const Color.fromARGB(255, 69, 69, 71))
                : Border.all(color: const Color.fromARGB(255, 225, 224, 224)),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: MacosTheme.brightnessOf(context) != Brightness.dark
                ? const Color(0xfff1f0f5)
                : const Color(0xff2e2e2e),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    widget.e.time.format(context),
                    style: TextStyle(
                      fontSize: 14,
                      color: MacosTheme.brightnessOf(context) == Brightness.dark
                          ? Colors.grey.shade400
                          : Colors.grey.shade700,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  if (widget.e.tweets != null && widget.e.tweets!.length > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                          color: MacosTheme.of(context).canvasColor),
                      child: Text(
                        widget.e.tweets!.length > 1 ? "Thread" : "",
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
              Expanded(
                child: widget.e.tweets != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...widget.e.tweets!
                              .map(
                                (tweet) => QueueTweetWidget(
                                  tweet: tweet,
                                ),
                              )
                              .toList()
                        ],
                      )
                    : Container(),
              ),
              const SizedBox(
                width: 10,
              ),
              if (widget.e.tweets != null && !isAfter) ...[
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final updayedTweets = await showMacosSheet(
                            barrierDismissible: true,
                            context: context,
                            builder: (_) => MacosSheet(
                                  child: EditTweet(
                                    isDraft: null,
                                    tweets: widget.e.copy().tweets!,
                                    selected: widget.e.fullDate.toUtc(),
                                  ),
                                ));

                        if (updayedTweets != null) {
                          widget.e.tweets = updayedTweets;
                        }
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: MacosTheme.of(context).dividerColor)),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.edit,
                            size: 16,
                            color: MacosTheme.brightnessOf(context) ==
                                    Brightness.dark
                                ? Colors.grey.shade300
                                : MacosColors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                if (!isLoading)
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: MacosTheme.of(context).dividerColor)),
                    child: MacosPulldownButton(
                        icon: CupertinoIcons.ellipsis,
                        items: [
                          MacosPulldownMenuItem(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await widget.onPostNow(widget.e.fullDate.toUtc(),
                                  widget.e.tweets!, widget.dateTime);
                              setState(() {
                                isLoading = false;
                              });
                            },
                            title: const Text("Post now"),
                          ),
                          const MacosPulldownMenuDivider(),
                          MacosPulldownMenuItem(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await widget.onDelete();
                              setState(() {
                                isLoading = false;
                              });
                            },
                            title: const Text("Delete"),
                          ),
                        ]),
                  ),
                if (isLoading)
                  Container(
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: MacosTheme.of(context).dividerColor)),
                      child: const Center(child: CupertinoActivityIndicator()))
              ]
            ],
          ),
        ),
      ),
    );
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: MacosTheme.of(context).canvasColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
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
                        color:
                            MacosTheme.brightnessOf(context) == Brightness.dark
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
                                      color:
                                          MacosTheme.of(context).dividerColor,
                                    ),
                                    child: file.type == 'tweet_video'
                                        ? GestureDetector(
                                            onTap: () {
                                              if (file.url != null) {
                                                launchUrlString(file.url!);
                                              } else if (file.path != null) {
                                                launchUrlString(
                                                    "file:///Users/${file.path!.split("Users")[1]}");
                                              }
                                            },
                                            child: SizedBox(
                                                width: 60,
                                                height: 60,
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Tap to view video in browser"
                                                          .toUpperCase(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 8,
                                                        color: Colors
                                                            .grey.shade200,
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                          )
                                        : ExtendedImage.network(
                                            file.url!,
                                            fit: BoxFit.cover,
                                            loadStateChanged:
                                                (ExtendedImageState state) {
                                              if (state
                                                      .extendedImageLoadState ==
                                                  LoadState.loading) {
                                                return Container(
                                                  color: MacosTheme.of(context)
                                                      .dividerColor,
                                                  child:
                                                      CupertinoActivityIndicator(
                                                    color: MacosTheme
                                                                .brightnessOf(
                                                                    context) ==
                                                            Brightness.dark
                                                        ? const Color.fromARGB(
                                                            255, 228, 228, 232)
                                                        : const Color.fromARGB(
                                                            255, 59, 58, 58),
                                                  ),
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
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          file.type == 'tweet_video'
                                              ? 'VID'
                                              : file.type == 'tweet_image'
                                                  ? 'IMG'
                                                  : 'GIF',
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
      ),
    );
  }
}
