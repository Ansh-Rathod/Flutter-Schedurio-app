import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:schedurio/helpers.dart';
import 'package:schedurio/services/hive_cache.dart';

class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MacosTheme.of(context).canvasColor,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Queue",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "See all your scheduled tweets here",
              style: TextStyle(
                color: MacosTheme.brightnessOf(context) == Brightness.dark
                    ? Colors.grey.shade300
                    : MacosColors.black,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 30,
              itemBuilder: (context, i) {
                final dateTime = DateTime.now().add(Duration(days: i));
                final times =
                    LocalCache.schedule.get(dateTime.getWeekDayName());
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateTime.getQueueString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: times.length,
                      itemBuilder: (context, i) {
                        final time = TimeOfDay(
                            hour: int.parse(times[i].split(':')[0]),
                            minute: int.parse(times[i].split(':')[1]));
                        final isAfter = DateTime(dateTime.year, dateTime.month,
                                dateTime.day, time.hour, time.minute)
                            .isBefore(DateTime.now());
                        if (isAfter) {
                          return Container();
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: MacosTheme.brightnessOf(context) !=
                                      Brightness.dark
                                  ? const Color(0xfff1f0f5)
                                  : const Color(0xff2e2e2e),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Text(
                                  time.format(context),
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
