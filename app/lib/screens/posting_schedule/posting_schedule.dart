// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../widgets/expandable_list.dart';
import 'cubit/posting_schedule_cubit_cubit.dart';

class PostingScheduleWidget extends StatefulWidget {
  const PostingScheduleWidget({super.key});

  @override
  State<PostingScheduleWidget> createState() => _PostingScheduleWidgetState();
}

class _PostingScheduleWidgetState extends State<PostingScheduleWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostingScheduleCubit(),
      child: BlocBuilder<PostingScheduleCubit, PostingScheduleState>(
        builder: (context, state) {
          return Center(
            child: Container(
              color: MacosTheme.of(context).canvasColor,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color:
                            MacosTheme.brightnessOf(context) != Brightness.dark
                                ? const Color(0xfff1f0f5)
                                : const Color(0xff2e2e2e),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Posting Schedule',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Select the days and times you want to post your content.',
                            style: TextStyle(
                              color: MacosTheme.brightnessOf(context) ==
                                      Brightness.dark
                                  ? Colors.white54
                                  : Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              MacosPopupButton<String>(
                                value: state.addAt,
                                onChanged:
                                    BlocProvider.of<PostingScheduleCubit>(
                                            context)
                                        .changeAddAt,
                                items: [
                                  'All',
                                  ...state.schedule.map((e) => e.day).toList()
                                ].map<MacosPopupMenuItem<String>>(
                                    (String value) {
                                  return MacosPopupMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(width: 10),
                              const Text("at"),
                              const SizedBox(width: 10),
                              MacosTimePicker(
                                style: TimePickerStyle.textual,
                                onTimeChanged:
                                    BlocProvider.of<PostingScheduleCubit>(
                                            context)
                                        .changeTime,
                              ),
                              const SizedBox(width: 10),
                              PushButton(
                                onPressed: () {
                                  BlocProvider.of<PostingScheduleCubit>(context)
                                      .addTime();
                                },
                                buttonSize: ButtonSize.small,
                                child: const Text('Add'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                  color: MacosTheme.of(context).dividerColor,
                                  width: 1),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...state.schedule
                                      .map(
                                        (e) => Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              constraints: const BoxConstraints(
                                                  minWidth: 100),
                                              child: Text(
                                                e.day,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      MacosTheme.brightnessOf(
                                                                  context) ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              constraints: const BoxConstraints(
                                                  minWidth: 100),
                                              child: Column(
                                                children: [
                                                  ...e.times
                                                      .map(
                                                        (time) => Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                            onTap: () {
                                                              BlocProvider.of<
                                                                          PostingScheduleCubit>(
                                                                      context)
                                                                  .removeTime(
                                                                      time,
                                                                      e.day);
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical:
                                                                      4.0),
                                                              child: Text(
                                                                time.format(
                                                                    context),
                                                                style:
                                                                    TextStyle(
                                                                  color: MacosTheme.brightnessOf(
                                                                              context) ==
                                                                          Brightness
                                                                              .dark
                                                                      ? Colors
                                                                          .white54
                                                                      : Colors
                                                                          .black54,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                  const SizedBox(height: 6),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                      .toList()
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ExpandablePanel(
                            heading:
                                'Make your posting times more natural and less robotic',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  '• If your schedule contains multiple round times, such as 9:00 AM, 1:30 PM and 7:00PM, it lacks realness and this will provide some variance and make it feel more authentic.',
                                  style: TextStyle(
                                    color: MacosTheme.brightnessOf(context) ==
                                            Brightness.dark
                                        ? Colors.white54
                                        : Colors.black54,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '• It will change every time slot of your schedule to a new time in a range of ± 5 minutes of the original time.',
                                  style: TextStyle(
                                    color: MacosTheme.brightnessOf(context) ==
                                            Brightness.dark
                                        ? Colors.white54
                                        : Colors.black54,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '• Example: 1:00PM will be changed to a time between 12:55PM and 1:05PM.',
                                  style: TextStyle(
                                    color: MacosTheme.brightnessOf(context) ==
                                            Brightness.dark
                                        ? Colors.white54
                                        : Colors.black54,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                PushButton(
                                    buttonSize: ButtonSize.small,
                                    onPressed: () {
                                      BlocProvider.of<PostingScheduleCubit>(
                                              context)
                                          .randomizeTime();
                                    },
                                    child: const Text(
                                        'Make my Schedule more natural')),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                style: ButtonStyle(
                                    side: MaterialStateProperty.all(BorderSide(
                                  color: MacosTheme.of(context).dividerColor,
                                  width: 1,
                                ))),
                                onPressed: () {
                                  BlocProvider.of<PostingScheduleCubit>(context)
                                      .reset();
                                },
                                child: const Text('Reset'),
                              ),
                              const SizedBox(width: 10),
                              PushButton(
                                buttonSize: ButtonSize.large,
                                onPressed: () {
                                  BlocProvider.of<PostingScheduleCubit>(context)
                                      .save();
                                },
                                child: const Text('Done'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
