// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/helpers.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/queue_tweets.dart';
import 'image_widget/_image_web.dart';

class HistoryTweetWidget extends StatelessWidget {
  final List<QueueTweetModel> tweets;
  final int id;
  final Function(List<QueueTweetModel> tweets) onEdit;
  final Function() onPostNow;
  final String status;
  final Function(int id) onDelete;
  final Function(int id) onAddToQueue;

  const HistoryTweetWidget({
    Key? key,
    required this.tweets,
    required this.id,
    required this.onEdit,
    required this.onPostNow,
    required this.status,
    required this.onDelete,
    required this.onAddToQueue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(tweets.first.createdAt).toLocal();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: status == 'error'
              ? Border.all(color: Colors.red)
              : MacosTheme.brightnessOf(context) == Brightness.dark
                  ? Border.all(color: const Color.fromARGB(255, 69, 69, 71))
                  : Border.all(color: const Color.fromARGB(255, 225, 224, 224)),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: MacosTheme.brightnessOf(context) != Brightness.dark
              ? const Color(0xfff1f0f5)
              : const Color(0xff2e2e2e),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${date.formatedString()} ${TimeOfDay(hour: date.hour, minute: date.minute).format(context)}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color:
                          MacosTheme.brightnessOf(context) == Brightness.light
                              ? const Color.fromARGB(255, 31, 29, 29)
                              : const Color.fromARGB(255, 183, 182, 182),
                    ),
                  ),
                  Row(
                    children: [
                      if (status == 'posted')
                        TextButton(
                          onPressed: () {
                            // launchUrlString(
                            // 'https://twitter.com/${LocalCache.currentUser.get(AppConfig.hiveKeys.username)}/status/');
                          },
                          child: const Text(
                            "View on Twitter",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      if (status == 'error') ...[
                        TextButton(
                          onPressed: () {
                            // launchUrlString(
                            // 'https://twitter.com/${LocalCache.currentUser.get(AppConfig.hiveKeys.username)}/status/');
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 16,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "Failed",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: MacosTheme.of(context).dividerColor)),
                          child: MacosPulldownButton(
                            icon: CupertinoIcons.ellipsis,
                            items: [
                              MacosPulldownMenuItem(
                                onTap: () {
                                  onPostNow.call();
                                },
                                title: const Text("Post now"),
                              ),
                              MacosPulldownMenuItem(
                                onTap: () {
                                  onAddToQueue.call(id);
                                },
                                title: const Text("Add to Queue"),
                              ),
                              const MacosPulldownMenuDivider(),
                              MacosPulldownMenuItem(
                                onTap: () {
                                  onDelete.call(id);
                                },
                                title: const Text("Delete"),
                              ),
                            ],
                          ),
                        ),
                      ]
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ...tweets
                .map((tweet) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: MacosTheme.of(context).canvasColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration:
                                    const BoxDecoration(shape: BoxShape.circle),
                                child: Text(
                                  "${tweets.indexOf(tweet) + 1}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xffa0a0a0),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tweet.content,
                                      style: TextStyle(
                                        color:
                                            MacosTheme.brightnessOf(context) ==
                                                    Brightness.dark
                                                ? Colors.white54
                                                : Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    if (tweet.media.isNotEmpty) ...[
                                      Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 400),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              for (var file in tweet.media)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                          width: 120,
                                                          height: 120,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: MacosTheme
                                                                    .of(context)
                                                                .dividerColor,
                                                          ),
                                                          child: file.type ==
                                                                  'tweet_video'
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    if (file.url !=
                                                                        null) {
                                                                      launchUrlString(
                                                                          file.url!);
                                                                    } else if (file
                                                                            .path !=
                                                                        null) {
                                                                      launchUrlString(
                                                                          "file:///Users/${file.path!.split("Users")[1]}");
                                                                    }
                                                                  },
                                                                  child: SizedBox(
                                                                      width: 120,
                                                                      height: 120,
                                                                      child: Center(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Text(
                                                                            "Tap to view in video browser".toUpperCase(),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 10,
                                                                              color: Colors.grey.shade200,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )),
                                                                )
                                                              : ImageWidget(
                                                                  imgFile: file
                                                                      .url!)),
                                                      Positioned(
                                                        bottom: 5,
                                                        left: 5,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(
                                                              file.type ==
                                                                      'tweet_video'
                                                                  ? 'VID'
                                                                  : file.type ==
                                                                          'tweet_image'
                                                                      ? 'IMG'
                                                                      : 'GIF',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10),
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
                                      const SizedBox(
                                        height: 16,
                                      )
                                    ],
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        if (tweets.indexOf(tweet) != tweets.length - 1)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              height: 20,
                              width: 5,
                              decoration: BoxDecoration(
                                // borderRadius:
                                //     const BorderRadius.all(Radius.circular(10)),
                                color: MacosTheme.of(context).canvasColor,
                              ),
                            ),
                          )
                        else
                          const SizedBox(
                            height: 10,
                          ),
                      ],
                    ))
                .toList()
          ],
        ),
      ),
    );
  }
}
