// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:desktop_drop/desktop_drop.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:path/path.dart' as path;
import 'package:schedurio/models/queue_tweets.dart';
import 'package:schedurio/widgets/image_widget/image.dart';

import '../config.dart';
import '../services/hive_cache.dart';

class CreateTweetWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String id, String? value) onTextChanged;
  final Function(String id) onTweetRemove;
  final Function() onAdd;
  final List<QueueTweetModel> tweets;
  final List<QueueMedia> media;
  final Function(List<QueueMedia> list) onMediaChange;
  final QueueTweetModel tweet;
  final bool isEdit;
  const CreateTweetWidget({
    Key? key,
    required this.controller,
    required this.onTextChanged,
    required this.onAdd,
    required this.tweets,
    required this.media,
    required this.onMediaChange,
    required this.tweet,
    required this.isEdit,
    required this.onTweetRemove,
  }) : super(key: key);

  @override
  State<CreateTweetWidget> createState() => _CreateTweetWidgetState();
}

class _CreateTweetWidgetState extends State<CreateTweetWidget> {
  bool isDragging = false;
  void onFilesPick(List<String> paths) {
    if (widget.media.length + paths.length > 4) {
      showAlert(context);
    } else if ((widget.media.map((e) => e.path).toList() + paths)
            .where((element) =>
                element!.substring(element.lastIndexOf('.') + 1) == 'mp4')
            .length >
        1) {
      showAlert(context);
    } else {
      if (widget.media.isEmpty) {
        widget.onMediaChange(paths
            .map((e) => QueueMedia(
                mediaId: uuid.v4(),
                path: e,
                type: e.substring(e.lastIndexOf('.') + 1) == 'mp4'
                    ? 'video'
                    : e.substring(e.lastIndexOf('.') + 1) == 'gif'
                        ? 'gif'
                        : 'image',
                name: path.basename(e),
                extensionName: e.substring(e.lastIndexOf('.') + 1)))
            .toList());
      } else {
        setState(() {
          final list = widget.media +
              paths
                  .map((e) => QueueMedia(
                      mediaId: uuid.v4(),
                      path: e,
                      type: e.substring(e.lastIndexOf('.') + 1) == 'mp4'
                          ? 'video'
                          : e.substring(e.lastIndexOf('.') + 1) == 'gif'
                              ? 'gif'
                              : 'image',
                      name: path.basename(e),
                      extensionName: e.substring(e.lastIndexOf('.') + 1)))
                  .toList();

          List<QueueMedia> distinctList = [];

          for (var item in list) {
            bool isDuplicate = false;
            for (var distinctItem in distinctList) {
              if (item.name == distinctItem.name) {
                isDuplicate = true;
                break;
              }
            }
            if (!isDuplicate) {
              distinctList.add(item);
            }
          }
          widget.onMediaChange(distinctList);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      enable: true,
      onDragDone: (detail) {
        onFilesPick(detail.files.map((e) => e.path).toList());
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
                  cache: true,
                  loadStateChanged: (ExtendedImageState state) {
                    if (state.extendedImageLoadState == LoadState.loading) {
                      return Container(
                        color: MacosTheme.of(context).dividerColor,
                        child: const ProgressCircle(value: null),
                      );
                    }
                    return null;
                  },
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
                            style: TextStyle(
                              color: MacosTheme.brightnessOf(context) ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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
                          widget.onTextChanged(widget.tweet.id, value);
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
                    if (widget.media.isNotEmpty) ...[
                      Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (var file in widget.media)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: MacosTheme.of(context)
                                              .dividerColor,
                                        ),
                                        child: file.type == 'video'
                                            ? Container()
                                            : file.path == null
                                                ? ImageWidget(
                                                    imgFile: file.url!)
                                                : ImageWidget(
                                                    imgFile: file.path!),
                                      ),
                                      Positioned(
                                        bottom: 5,
                                        left: 5,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              file.type,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          child: MacosIconButton(
                                            boxConstraints:
                                                const BoxConstraints(
                                                    minWidth: 12,
                                                    minHeight: 12,
                                                    maxHeight: 20,
                                                    maxWidth: 20),
                                            padding: const EdgeInsets.all(4),
                                            icon: const MacosIcon(
                                              CupertinoIcons.clear,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              widget.media.remove(file);
                                              widget
                                                  .onMediaChange(widget.media);
                                            },
                                          ),
                                        ),
                                      )
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
                                onPressed: widget.media.length < 4
                                    ? () async {
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
                                          onFilesPick(result.files
                                              .map((e) => e.path!)
                                              .toList());
                                        }
                                      }
                                    : null,
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
                                  onPressed:
                                      widget.controller.text.isNotEmpty ||
                                              widget.media.isNotEmpty
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
                                    widget.onTweetRemove.call(widget.tweet.id);
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

  void showAlert(BuildContext context) {
    showMacosAlertDialog(
        context: context,
        builder: (_) => MacosAlertDialog(
              appIcon: const FlutterLogo(size: 55),
              title: const Text(
                "Oops!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
}
