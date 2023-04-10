import 'dart:math';

import 'package:flutter/material.dart';

class PostingSchedule {
  final String day;
  final List<TimeOfDay> times;
  PostingSchedule({
    required this.day,
    required this.times,
  });

  void randomizeTimes() {
    final random = Random();
    for (int i = 0; i < times.length; i++) {
      final time = times[i];
      final hour = time.hour;
      final minute = time.minute;
      var ranges = [];

      for (var t = 1; t <= 5; t++) {
        ranges.add(TimeOfDay.fromDateTime(
            DateTime(2021, 1, 1, hour, minute).add(Duration(minutes: t + 1))));
      }
      for (var t = 1; t <= 5; t++) {
        ranges.add(TimeOfDay.fromDateTime(
            DateTime(2021, 1, 1, hour, minute).subtract(Duration(minutes: t))));
      }

      final newTime = ranges[random.nextInt(ranges.length)];
      times[i] = newTime;
    }
  }

  factory PostingSchedule.fromJson(Map<String, dynamic> json) {
    return PostingSchedule(
      day: json['day'],
      times: (json['times'] as List<dynamic>)
          .map((e) => TimeOfDay(
                hour: int.parse(e.split(':')[0]),
                minute: int.parse(e.split(':')[1]),
              ))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'times': times.map((e) => '${e.hour}:${e.minute}').toList(),
    };
  }
}
