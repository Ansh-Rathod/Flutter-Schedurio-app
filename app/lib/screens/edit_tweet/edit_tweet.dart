// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/helpers.dart';
import 'package:schedurio/models/queue_tweets.dart';

import '../../widgets/create_tweet_widget.dart';
import '../../widgets/custom_pull_down_button.dart';
import '../../widgets/custom_push_button.dart';
import 'cubit/edit_tweet_cubit.dart';

class EditTweet extends StatelessWidget {
  final DateTime selected;
  final List<QueueTweetModel> tweets;

  const EditTweet({
    Key? key,
    required this.selected,
    required this.tweets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
        toolBar: ToolBar(
          automaticallyImplyLeading: false,
          height: 45,
          actions: [
            ToolBarIconButton(
              label: 'Toggle Sidebar',
              icon: const MacosIcon(
                Icons.close,
              ),
              onPressed: () => Navigator.of(context).pop(),
              showLabel: false,
              tooltipMessage: 'Close Dialog',
            ),
          ],
        ),
        children: [
          ContentArea(
            builder: (context, scrollController) => BlocProvider(
              create: (context) =>
                  EditTweetCubit()..init(selected: selected, tweets: tweets),
              child: BlocConsumer<EditTweetCubit, EditTweetState>(
                listener: (context, state) {
                  if (state.status == EditTweetStatus.success) {
                    Navigator.of(context).pop(state.editedTweets);
                  }
                },
                builder: (context, state) {
                  return Container(
                    color: MacosTheme.of(context).canvasColor,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            child: SingleChildScrollView(
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ...state.editedTweets
                                        .map((tweet) => CreateTweetWidget(
                                              media: tweet.media,
                                              isEdit: true,
                                              onMediaChange:
                                                  (List<QueueMedia> media) {
                                                BlocProvider.of<EditTweetCubit>(
                                                        context)
                                                    .onMediaChange(
                                                        tweet.id, media);
                                              },
                                              controller: tweet.controller,
                                              onAdd: BlocProvider.of<
                                                      EditTweetCubit>(context)
                                                  .addNewTweet,
                                              onTweetRemove: BlocProvider.of<
                                                      EditTweetCubit>(context)
                                                  .removeTweet,
                                              onTextChanged: BlocProvider.of<
                                                      EditTweetCubit>(context)
                                                  .updateTweet,
                                              tweet: tweet,
                                              tweets: state.editedTweets,
                                            ))
                                        .toList(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: MacosTheme.of(context).canvasColor,
                            border: Border(
                              top: BorderSide(
                                  width: 1,
                                  color: MacosTheme.of(context).dividerColor),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Text(
                                    state.selected.toLocal().formatedString(),
                                    style: TextStyle(
                                      color:
                                          MacosTheme.of(context).primaryColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  MacosPopupButton(
                                      onChanged: (value) {
                                        BlocProvider.of<EditTweetCubit>(context)
                                            .changeSelected(value!);
                                      },
                                      value: state.selected,
                                      items: [
                                        ...state.availableTimesForDay
                                            .map(
                                              (e) => MacosPopupMenuItem(
                                                value: e,
                                                child: Text(
                                                  TimeOfDay(
                                                          hour:
                                                              e.toLocal().hour,
                                                          minute:
                                                              e.toLocal().day)
                                                      .format(context),
                                                ),
                                              ),
                                            )
                                            .toList()
                                      ]),
                                ]),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomPushButton(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(7),
                                          bottomLeft: Radius.circular(7),
                                        ),
                                        onPressed: state.editedTweets.every(
                                                    (e) =>
                                                        e.content != '' ||
                                                        e.media.isNotEmpty) &&
                                                state.status !=
                                                    EditTweetStatus.loading
                                            ? () async {
                                                await BlocProvider.of<
                                                        EditTweetCubit>(context)
                                                    .onUpdate();
                                              }
                                            : null,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        buttonSize: CustomButtonSize.large,
                                        child: state.status !=
                                                EditTweetStatus.loading
                                            ? const Text(
                                                "Update",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              )
                                            : const ProgressCircle(
                                                value: null,
                                              )),
                                    CustomMacosPulldownButton(items: [
                                      CustomMacosPulldownMenuItem(
                                        enabled: state.editedTweets.every((e) =>
                                            e.content != '' ||
                                            e.media.isNotEmpty),
                                        title: const Text("Post now"),
                                      ),
                                      CustomMacosPulldownMenuItem(
                                        enabled: state.editedTweets.every((e) =>
                                            e.content != '' ||
                                            e.media.isNotEmpty),
                                        title: const Text("Save as draft"),
                                      ),
                                    ])
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
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
