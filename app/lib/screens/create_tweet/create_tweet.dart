// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/helpers.dart';
import 'package:schedurio/models/queue_tweets.dart';

import '../../widgets/create_tweet_widget.dart';
import '../../widgets/custom_pull_down_button.dart';
import '../../widgets/custom_push_button.dart';
import 'cubit/create_tweet_cubit.dart';

class CreateTweet extends StatefulWidget {
  const CreateTweet({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateTweet> createState() => _CreateTweetState();
}

class _CreateTweetState extends State<CreateTweet> {
  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
        toolBar: ToolBar(
          height: 45,
          title: const Text(
            "Create Tweet",
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
            builder: (context, scrollController) =>
                BlocBuilder<CreateTweetCubit, CreateTweetState>(
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
                                  ...state.tweets
                                      .map((tweet) => CreateTweetWidget(
                                            media: tweet.media,
                                            isEdit: false,
                                            onMediaChange:
                                                (List<QueueMedia> media) {
                                              BlocProvider.of<CreateTweetCubit>(
                                                      context)
                                                  .onMediaChange(
                                                      tweet.id, media);
                                            },
                                            controller: tweet.controller,
                                            onAdd: BlocProvider.of<
                                                    CreateTweetCubit>(context)
                                                .addNewTweet,
                                            onTweetRemove: BlocProvider.of<
                                                    CreateTweetCubit>(context)
                                                .removeTweet,
                                            onTextChanged: BlocProvider.of<
                                                    CreateTweetCubit>(context)
                                                .updateTweet,
                                            tweet: tweet,
                                            tweets: state.tweets,
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
                                    color: MacosTheme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                MacosPopupButton(
                                    onChanged: (value) {
                                      BlocProvider.of<CreateTweetCubit>(context)
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
                                                        hour: e.toLocal().hour,
                                                        minute: e.toLocal().day)
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
                                      onPressed: state.tweets.every((e) =>
                                                  e.content != '' ||
                                                  e.media.isNotEmpty) &&
                                              state.status !=
                                                  CreateTweetStatus.loading
                                          ? () {
                                              BlocProvider.of<CreateTweetCubit>(
                                                      context)
                                                  .onAddToQueue();
                                            }
                                          : null,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      buttonSize: CustomButtonSize.large,
                                      child: state.status !=
                                              CreateTweetStatus.loading
                                          ? const Text(
                                              "Add",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            )
                                          : const ProgressCircle(
                                              value: null,
                                            )),
                                  CustomMacosPulldownButton(items: [
                                    CustomMacosPulldownMenuItem(
                                      enabled: state.tweets.every((e) =>
                                          e.content != '' ||
                                          e.media.isNotEmpty),
                                      title: const Text("Post now"),
                                    ),
                                    CustomMacosPulldownMenuItem(
                                      enabled: state.tweets.every((e) =>
                                          e.content != '' ||
                                          e.media.isNotEmpty),
                                      onTap: () {
                                        BlocProvider.of<CreateTweetCubit>(
                                                context)
                                            .saveToDraft();
                                      },
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
        ]);
  }
}
