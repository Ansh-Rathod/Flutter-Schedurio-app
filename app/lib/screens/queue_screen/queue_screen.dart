// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/helpers.dart';
import 'package:schedurio/screens/queue_screen/cubit/queue_screen_cubit.dart';

import '../../widgets/queue_item/queue_item.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
        toolBar: ToolBar(
          height: 45,
          title: const Text(
            "Queue",
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
              child: BlocBuilder<QueueScreenCubit, QueueScreenState>(
                builder: (context, state) {
                  if (state.status == FetchTweetsStatus.loading) {
                    return Center(
                      child: CupertinoActivityIndicator(
                        color:
                            MacosTheme.brightnessOf(context) == Brightness.dark
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
                              BlocProvider.of<QueueScreenCubit>(context).init();
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
                        ...state.queue
                            .map((queueItem) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      queueItem.dateTime.getQueueString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ...queueItem.times.map(
                                      (e) {
                                        return QueueItemWidget(
                                          e: e,
                                          onDelete: () async {
                                            await BlocProvider.of<
                                                    QueueScreenCubit>(context)
                                                .delete(queueItem.dateTime,
                                                    e.fullDate, e.id);
                                            BlocProvider.of<QueueScreenCubit>(
                                                    context)
                                                .removeTweet(queueItem.dateTime,
                                                    e.fullDate);
                                          },
                                          dateTime: queueItem.dateTime,
                                          onPostNow: (fullDate, tweets,
                                              dateTime) async {
                                            final status = await BlocProvider
                                                    .of<QueueScreenCubit>(
                                                        context)
                                                .postNow(
                                                    fullDate.toUtc(),
                                                    tweets,
                                                    queueItem.dateTime,
                                                    e.id);

                                            BlocProvider.of<QueueScreenCubit>(
                                                    context)
                                                .removeTweet(queueItem.dateTime,
                                                    e.fullDate);
                                            if (status == 'error') {
                                              // ignore: use_build_context_synchronously
                                              showMacosAlertDialog(
                                                barrierDismissible: true,
                                                context: context,
                                                builder: (_) =>
                                                    MacosAlertDialog(
                                                  appIcon: const FlutterLogo(
                                                    size: 50,
                                                  ),
                                                  title: const Text(
                                                    "Error!!",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  message: const Text(
                                                      "Something went wrong"),
                                                  primaryButton: PushButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    buttonSize:
                                                        ButtonSize.large,
                                                    child: const Text("OK"),
                                                  ),
                                                ),
                                              );
                                            }
                                            if (status == 'success') {
                                              showMacosAlertDialog(
                                                barrierDismissible: true,
                                                context: context,
                                                builder: (_) =>
                                                    MacosAlertDialog(
                                                  appIcon: const Icon(
                                                    CupertinoIcons
                                                        .check_mark_circled_solid,
                                                    color: Colors.green,
                                                    size: 50,
                                                  ),
                                                  title: const Text(
                                                    "Posted!!",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  message: const Text(
                                                      "Your tweet has been posted successfully."),
                                                  primaryButton: PushButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    buttonSize:
                                                        ButtonSize.large,
                                                    child: const Text("OK"),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ))
                            .toList()
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
