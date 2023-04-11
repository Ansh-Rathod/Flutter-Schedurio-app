// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

import '../config.dart';
import '../services/hive_cache.dart';

class CreateTweetWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(int id, String? value) onTextChanged;
  final Function(int value) onRemove;
  final Function() onAdd;
  final List<dynamic> tweets;
  final dynamic tweet;
  const CreateTweetWidget({
    Key? key,
    required this.controller,
    required this.onTextChanged,
    required this.onRemove,
    required this.onAdd,
    required this.tweets,
    required this.tweet,
  }) : super(key: key);

  @override
  State<CreateTweetWidget> createState() => _CreateTweetWidgetState();
}

class _CreateTweetWidgetState extends State<CreateTweetWidget> {
  bool isDragging = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      enable: true,
      onDragDone: (detail) {
        print(detail.files.map((e) => e.name).toList());

        if (detail.files.length > 4) {
          showMacosAlertDialog(
              context: context,
              builder: (_) => MacosAlertDialog(
                    appIcon: const FlutterLogo(size: 55),
                    title: const Text(
                      "Oops!",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    message: const Text(
                        "Sorry, you can only upload a maximum of 4 images/gifs and one video in a single tweet."),
                    primaryButton: PushButton(
                      buttonSize: ButtonSize.large,
                      child: const Text("Ok"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ));
        }
      },
      onDragEntered: (detail) {
        setState(() {
          isDragging = true;
        });
      },
      onDragExited: (detail) {
        setState(() {
          isDragging = false;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              border:
                  isDragging ? Border.all(width: 2, color: Colors.blue) : null,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: MacosTheme.brightnessOf(context) != Brightness.dark
                  ? const Color(0xfff1f0f5)
                  : const Color(0xff2e2e2e),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ExtendedImage.network(
                  LocalCache.currentUser.get(AppConfig.hiveKeys.profilePicture),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  shape: BoxShape.circle,
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: LocalCache.currentUser
                                .get(AppConfig.hiveKeys.displayName),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          TextSpan(
                            text: ' @' +
                                LocalCache.currentUser
                                    .get(AppConfig.hiveKeys.username),
                            style: TextStyle(
                                color: MacosTheme.brightnessOf(context) ==
                                        Brightness.dark
                                    ? Colors.white54
                                    : Colors.black54,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: MacosTextField.borderless(
                        controller: widget.controller,
                        padding: EdgeInsets.zero,
                        maxLines: null,
                        maxLength: 280,
                        onChanged: (value) {
                          widget.onTextChanged(widget.tweet['id'], value);
                        },
                        placeholder: 'What\'s happening?',
                        style: TextStyle(
                          color: MacosTheme.brightnessOf(context) ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              "${widget.controller.text.length}/280",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: MacosTheme.brightnessOf(context) ==
                                          Brightness.dark
                                      ? Colors.white38
                                      : Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MacosIconButton(
                                boxConstraints: const BoxConstraints(
                                    minWidth: 30,
                                    minHeight: 30,
                                    maxHeight: 40,
                                    maxWidth: 40),
                                onPressed: () {},
                                icon: const MacosIcon(
                                    Icons.emoji_emotions_outlined),
                              ),
                              MacosIconButton(
                                boxConstraints: const BoxConstraints(
                                    minWidth: 30,
                                    minHeight: 30,
                                    maxHeight: 40,
                                    maxWidth: 40),
                                onPressed: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                          allowMultiple: true,
                                          type: FileType.custom,
                                          allowedExtensions: [
                                        'jpg',
                                        'png',
                                        'gif',
                                        'mp4',
                                        'jpeg',
                                        'webp',
                                      ]);

                                  if (result != null) {
                                    List<File> files = result.paths
                                        .map((path) => File(path!))
                                        .toList();
                                  }
                                },
                                icon: const MacosIcon(Icons.photo_outlined),
                              ),
                              MacosIconButton(
                                boxConstraints: const BoxConstraints(
                                    minWidth: 30,
                                    minHeight: 30,
                                    maxHeight: 40,
                                    maxWidth: 40),
                                onPressed: () {},
                                icon: const MacosIcon(Icons.poll_outlined),
                              ),
                              MacosIconButton(
                                boxConstraints: const BoxConstraints(
                                    minWidth: 30,
                                    minHeight: 30,
                                    maxHeight: 40,
                                    maxWidth: 40),
                                onPressed: () {},
                                icon: const MacosIcon(Icons.gif_box_outlined),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              if (widget.tweets.indexOf(widget.tweet) ==
                                  widget.tweets.length - 1)
                                MacosIconButton(
                                  onPressed: widget.controller.text.isNotEmpty
                                      ? widget.onAdd
                                      : null,
                                  hoverColor: Colors.blue.withOpacity(0.6),
                                  backgroundColor: Colors.blue,
                                  icon: const MacosIcon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              const SizedBox(
                                width: 10,
                              ),
                              if (widget.tweets.indexOf(widget.tweet) != 0)
                                MacosIconButton(
                                  onPressed: () {
                                    widget.onRemove.call(widget.tweet['id']);
                                  },
                                  hoverColor:
                                      MacosTheme.brightnessOf(context) ==
                                              Brightness.dark
                                          ? Colors.white.withOpacity(0.6)
                                          : Colors.black87
                                              .withOpacity(0.4)
                                              .withOpacity(0.6),
                                  backgroundColor:
                                      MacosTheme.brightnessOf(context) ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black87,
                                  icon: MacosIcon(
                                    Icons.close,
                                    color: MacosTheme.brightnessOf(context) !=
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          if (widget.tweets.length > 1 &&
              widget.tweets.indexOf(widget.tweet) != widget.tweets.length - 1)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              height: 20,
              width: 100,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                      color: MacosTheme.of(context).dividerColor, width: 3),
                ),
              ),
            )
        ],
      ),
    );
  }
}
