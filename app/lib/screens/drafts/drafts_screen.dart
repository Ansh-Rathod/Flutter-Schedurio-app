// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/supabase.dart';

import '../../models/queue_tweets.dart';
import '../../widgets/queue_tweet_widget.dart';
import 'cubit/drafts_screen_cubit.dart';

class DraftsScreen extends StatefulWidget {
  const DraftsScreen({Key? key}) : super(key: key);

  @override
  State<DraftsScreen> createState() => _DraftsScreenState();
}

class _DraftsScreenState extends State<DraftsScreen> {
  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        height: 45,
        title: const Text(
          "Drafts",
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
            child: BlocBuilder<DraftsScreenCubit, DraftsScreenState>(
              builder: (context, state) {
                if (state.status == FetchTweetsStatus.loading) {
                  return Center(
                    child: CupertinoActivityIndicator(
                      color: MacosTheme.brightnessOf(context) == Brightness.dark
                          ? const Color.fromARGB(255, 228, 228, 232)
                          : const Color.fromARGB(255, 59, 58, 58),
                    ),
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
                            BlocProvider.of<DraftsScreenCubit>(context).init();
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
                      if (state.tweets.isEmpty)
                        const Center(
                          child: Text("No drafts found!"),
                        ),
                      ...state.tweets.map(
                        (e) => QueueDraftTweet(
                          tweets: e['tweets'],
                          id: e['id'],
                          onPostNow: () async {
                            final status =
                                await BlocProvider.of<DraftsScreenCubit>(
                                        context)
                                    .postNow(e['id'].toString(), e['tweets']);
                            if (status == 'error') {
                              // ignore: use_build_context_synchronously
                              showMacosAlertDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (_) => MacosAlertDialog(
                                  appIcon: const FlutterLogo(
                                    size: 50,
                                  ),
                                  title: const Text(
                                    "Error!!",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  message: const Text("Something went wrong"),
                                  primaryButton: PushButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    buttonSize: ButtonSize.large,
                                    child: const Text("OK"),
                                  ),
                                ),
                              );
                            }
                            if (status == 'success') {
                              showMacosAlertDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (_) => MacosAlertDialog(
                                  appIcon: const Icon(
                                    CupertinoIcons.check_mark_circled_solid,
                                    color: Colors.green,
                                    size: 50,
                                  ),
                                  title: const Text(
                                    "Posted!!",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  message: const Text(
                                      "Your tweet has been posted successfully."),
                                  primaryButton: PushButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    buttonSize: ButtonSize.large,
                                    child: const Text("OK"),
                                  ),
                                ),
                              );
                            }
                          },
                          onDelete: (int id) async {
                            BlocProvider.of<DraftsScreenCubit>(context)
                                .removeTweet(id);
                            await supabase.from('drafts').delete().eq('id', id);
                          },
                          onEdit: (List<QueueTweetModel> tweets) {
                            setState(() {
                              e['tweets'] = tweets;
                            });
                          },
                          onAddToQueue: (int id) async {
                            final status = await BlocProvider.of<
                                    DraftsScreenCubit>(context)
                                .addToQueue(e['id'].toString(), e['tweets']);
                            if (status == 'error') {
                              // ignore: use_build_context_synchronously
                              showMacosAlertDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (_) => MacosAlertDialog(
                                  appIcon: const FlutterLogo(
                                    size: 50,
                                  ),
                                  title: const Text(
                                    "Error!!",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  message: const Text("Something went wrong"),
                                  primaryButton: PushButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    buttonSize: ButtonSize.large,
                                    child: const Text("OK"),
                                  ),
                                ),
                              );
                            }
                            if (status == 'success') {
                              showMacosAlertDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (_) => MacosAlertDialog(
                                  appIcon: const Icon(
                                    CupertinoIcons.check_mark_circled_solid,
                                    color: Colors.green,
                                    size: 50,
                                  ),
                                  title: const Text(
                                    "Added!!",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  message: const Text(
                                      "Your tweet has been Scheduled successfully."),
                                  primaryButton: PushButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    buttonSize: ButtonSize.large,
                                    child: const Text("OK"),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
