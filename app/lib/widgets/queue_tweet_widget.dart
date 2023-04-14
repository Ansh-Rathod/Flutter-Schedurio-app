// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/helpers.dart';

import '../models/queue_tweets.dart';
import '../screens/edit_tweet/edit_tweet.dart';
import 'image_widget/image.dart';

class QueueDraftTweet extends StatelessWidget {
  final List<QueueTweetModel> tweets;
  final int id;
  final Function(List<QueueTweetModel> tweets) onEdit;
  final Function() onPostNow;
  final Function(int id) onDelete;
  final Function(int id) onAddToQueue;

  const QueueDraftTweet({
    Key? key,
    required this.tweets,
    required this.id,
    required this.onEdit,
    required this.onPostNow,
    required this.onDelete,
    required this.onAddToQueue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: MacosTheme.of(context).dividerColor,
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
                      DateTime.parse(tweets.first.createdAt)
                          .toLocal()
                          .formatedString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xffa0a0a0),
                      )),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final updatedTweets = await showMacosSheet(
                              barrierDismissible: true,
                              context: context,
                              builder: (_) => MacosSheet(
                                    child: EditTweet(
                                      isDraft: id,
                                      tweets:
                                          tweets.map((e) => e.copy()).toList(),
                                      selected: DateTime.now().toUtc(),
                                    ),
                                  ));

                          if (updatedTweets != null) {
                            onEdit.call(updatedTweets);
                          }
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
                    ],
                  ),
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
                            color: MacosTheme.brightnessOf(context) !=
                                    Brightness.dark
                                ? const Color(0xfff1f0f5)
                                : const Color(0xff2e2e2e),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
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
                                                ? Colors.white
                                                : Colors.black87,
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
                                                                  .circular(10),
                                                          color: MacosTheme.of(
                                                                  context)
                                                              .dividerColor,
                                                        ),
                                                        child: file.type ==
                                                                'video'
                                                            ? Container()
                                                            : file.path == null
                                                                ? ImageWidget(
                                                                    imgFile: file
                                                                        .url!)
                                                                : ImageWidget(
                                                                    imgFile: file
                                                                        .path!),
                                                      ),
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
                                                              file.type,
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
                                color: MacosTheme.brightnessOf(context) !=
                                        Brightness.dark
                                    ? const Color(0xfff1f0f5)
                                    : const Color(0xff2e2e2e),
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
