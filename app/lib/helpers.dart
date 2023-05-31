// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedurio/services/hive_cache.dart';

import 'models/queue_model.dart';

extension DateTimeHelper on DateTime {
  //To weekDay Fri or Fri 04
  String formatedString() {
    DateTime datetime = DateTime.parse(toIso8601String());
    DateFormat dateFormat = DateFormat('EEE dd MMM${','} yyyy');
    return dateFormat.format(datetime);
  }

  String getWeekDayName() {
    return getDayOfWeek(weekday);
  }

  String getQueueString() {
    final today = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 0, 0, 0, 0, 0);
    final comp = DateTime(year, month, day, 0, 0, 0, 0, 0);

    // ignore: unnecessary_string_interpolations
    DateFormat dateFormat = DateFormat('MMMM dd');

    return getWeekDay(comp, today) == "Today" ||
            getWeekDay(comp, today) == "Tomorrow"
        ? getWeekDay(comp, today)
        : "${getWeekDay(comp, today)} ${dateFormat.format(this)}";
  }
}

String getWeekDay(DateTime comp, DateTime today) {
  if (comp.difference(today).inDays == 0) {
    return "Today";
  } else if (comp.difference(today).inDays == 1) {
    return "Tomorrow";
  } else {
    return getDayOfWeek(comp.weekday);
  }
}

String getDayOfWeek(int day) {
  switch (day) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      return 'Unknown';
  }
}

String dateTimeToCron(DateTime dateTime) {
  String cronExpression =
      '${dateTime.minute} ${dateTime.hour} ${dateTime.day} ${dateTime.month} *';
  return cronExpression;
}

Future<List<DateTime>> getAvailableQueue() async {
  List<DateTime> queue = [];
  for (int i = 0; i < 15; i++) {
    final dateTime = DateTime.now().add(Duration(days: i));
    final times = LocalCache.schedule.get(dateTime.getWeekDayName());

    for (var j in times) {
      final time = TimeOfDay(
          hour: int.parse(j.split(':')[0]), minute: int.parse(j.split(':')[1]));
      final date = DateTime(
          dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute);

      final isAfter = date.isBefore(DateTime.now());

      if (!isAfter) {
        queue.add(
          date.toUtc(),
        );
      }
    }
  }
  final unAvalableList = LocalCache.filledQueue.values
      .toList()
      .map((e) =>
          DateTime.fromMillisecondsSinceEpoch(int.parse("${e}0000")).toUtc())
      .toList();
  final alreadyInQueue = LocalCache.queue.values
      .toList()
      .map((e) =>
          DateTime.fromMillisecondsSinceEpoch(int.parse("${e}0000")).toUtc())
      .toList();

  for (var time in unAvalableList) {
    queue.remove(time);
    if (queue.first.isBefore(time)) {
      await LocalCache.filledQueue
          .remove(removeLastFourZeros(time.millisecondsSinceEpoch));
    }
  }

  for (var time in alreadyInQueue) {
    if (time.isBefore(DateTime.now().toUtc())) {
      await LocalCache.queue
          .remove(removeLastFourZeros(time.millisecondsSinceEpoch));
    }
  }

  return queue;
}

Future<List<QueueModel>> createQueueList(List<dynamic> tweets) async {
  List<QueueModel> queue = [];
  for (int i = 0; i < 15; i++) {
    final dateTime = DateTime.now().add(Duration(days: i));
    final times = LocalCache.schedule.get(dateTime.getWeekDayName());

    List<QueueDayTime> allTimes = [];
    for (var j in times) {
      final time = TimeOfDay(
          hour: int.parse(j.split(':')[0]), minute: int.parse(j.split(':')[1]));
      final date = DateTime(
          dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute);

      // final isAfter = date.isBefore(DateTime.now());
      final tweetsOnTime = tweets.firstWhere(
        (e) => e['scheduled_at'] == date.toUtc().toString(),
        orElse: () => null,
      );
      allTimes.add(QueueDayTime(
          id: tweetsOnTime != null ? tweetsOnTime['id'].toString() : "",
          time: time,
          fullDate: date,
          tweets: tweetsOnTime != null ? tweetsOnTime['tweets'] : null));
    }
    queue.add(
      QueueModel(
        dateTime: DateTime(dateTime.year, dateTime.month, dateTime.day),
        times: allTimes,
      ),
    );
  }

  // final unAvalableList = LocalCache.filledQueue.values.toList();

  // for (var time in unAvalableList) {
  //   queue.remove(DateTime.parse(time).toUtc());
  //   if (queue.first.isBefore(DateTime.parse(time).toUtc())) {
  //     await LocalCache.filledQueue.deleteAt(unAvalableList.indexOf(time));
  //   }
  // }

  return queue;
}

int removeLastFourZeros(int number) {
  final numberString = number.toString();
  int endIndex = numberString.length - 4;
  return int.parse(numberString.substring(0, endIndex));
}
