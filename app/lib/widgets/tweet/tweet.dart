// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/apis/get_tweets.dart';
import 'package:schedurio/helpers.dart';
import 'package:schedurio_utils/schedurio_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../config.dart';
import '../../services/hive_cache.dart';
import '../photo_grid.dart';

class TweetWidget extends StatefulWidget {
  final TweetModel tweet;
  final bool fullFormate;
  const TweetWidget({
    Key? key,
    required this.tweet,
    required this.fullFormate,
  }) : super(key: key);

  @override
  State<TweetWidget> createState() => _TweetWidgetState();
}

class _TweetWidgetState extends State<TweetWidget> {
  bool loading = false;
  late String content = widget.tweet.content;

  @override
  void initState() {
    formateText();
    super.initState();
  }

  void formateText() async {
    try {
      setState(() {
        loading = true;
      });

      final newText = await GetTweets.formateText(content);
      setState(() {
        content = newText;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: MacosTheme.brightnessOf(context) != Brightness.dark
            ? const Color(0xfff1f0f5)
            : const Color(0xff2e2e2e),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              widget.fullFormate
                  ? '${widget.tweet.postedAt.formatedString()} ${widget.tweet.postedAt.toLocal().hour}:${widget.tweet.postedAt.toLocal().minute}'
                  : '${widget.tweet.postedAt.toLocal().hour}:${widget.tweet.postedAt.toLocal().minute}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xffa0a0a0),
              )),
          const SizedBox(height: 10),
          Text(content),
          const SizedBox(height: 16),
          if (widget.tweet.media!.isEmpty) ...[
            const SizedBox(height: 10),
            Divider(color: MacosTheme.of(context).dividerColor),
            const SizedBox(height: 10),
          ],
          if (widget.tweet.media!.isNotEmpty)
            SizedBox(
              height: 200,
              child: PhotoGrid(
                maxImages: 4,
                isFile: false,
                imageUrls: widget.tweet.media!,
                onImageClicked: (i) {
                  // Navigator.push(
                  //     context,
                  //     createRoute(ViewPhotos(
                  //       imageIndex: i,
                  //       isFiles: false,
                  //       data: model.media!.data,
                  //     )));
                },
                onExpandClicked: () {
                  // Navigator.push(
                  //     context,
                  //     createRoute(ViewPhotos(
                  //       imageIndex: 4,
                  //       isFiles: false,
                  //       data: model.media!.data,
                  //     )));
                },
              ),
            ),
          if (widget.tweet.media!.isNotEmpty) ...[
            const SizedBox(height: 16),
          ],
          Row(
            children: [
              Text("${widget.tweet.publicMetrics.likeCount} Likes",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xffa0a0a0),
                  )),
              const SizedBox(width: 10),
              Text("${widget.tweet.publicMetrics.retweetCount} Retweets",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xffa0a0a0),
                  )),
              const SizedBox(width: 10),
              Text("${widget.tweet.publicMetrics.replyCount} replies",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xffa0a0a0),
                  )),
              const SizedBox(
                width: 10,
              ),
              Text("${widget.tweet.publicMetrics.impressionCount} impressions",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xffa0a0a0),
                  )),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: MacosTheme.of(context).dividerColor),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  launchUrlString(
                      'https://twitter.com/${LocalCache.currentUser.get(AppConfig.hiveKeys.username)}/status/${widget.tweet.id}');
                },
                child: const Text("View on Twitter",
                    style: TextStyle(
                      color: Colors.blue,
                    )),
              ),
              Row(
                children: [
                  MacosTooltip(
                    message: 'Copy full text',
                    child: MacosIconButton(
                        icon: const MacosIcon(Icons.copy),
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: content));
                        }),
                  ),
                  MacosTooltip(
                    message: 'Copy Tweet Link',
                    child: MacosIconButton(
                        icon: const MacosIcon(CupertinoIcons.link),
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(
                              text:
                                  'https://twitter.com/${LocalCache.currentUser.get(AppConfig.hiveKeys.username)}/status/${widget.tweet.id}'));
                        }),
                  ),
                  MacosTooltip(
                    message: 'Add to favorites',
                    child: MacosIconButton(
                        icon: const MacosIcon(CupertinoIcons.star),
                        onPressed: () {}),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
