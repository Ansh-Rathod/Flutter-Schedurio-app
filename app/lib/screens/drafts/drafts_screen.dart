import 'package:flutter/cupertino.dart';
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
                      ...state.tweets.map(
                        (e) => QueueDraftTweet(
                          tweets: e['tweets'],
                          id: e['id'],
                          onAddToQueue: (int id) {},
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
                          onPostNow: () {},
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
