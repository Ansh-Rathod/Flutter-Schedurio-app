// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'posting_schedule_cubit_cubit.dart';

class PostingScheduleState {
  final List<PostingSchedule> schedule;
  final TimeOfDay time;
  final String addAt;
  PostingScheduleState({
    required this.schedule,
    required this.time,
    required this.addAt,
  });

  factory PostingScheduleState.initial() {
    return PostingScheduleState(
      addAt: 'All',
      time: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
      schedule: [
        PostingSchedule(day: 'Monday', times: [
          const TimeOfDay(hour: 10, minute: 18),
          const TimeOfDay(hour: 13, minute: 12),
        ]),
        PostingSchedule(day: 'Tuesday', times: [
          const TimeOfDay(hour: 10, minute: 18),
          const TimeOfDay(hour: 13, minute: 12),
        ]),
        PostingSchedule(day: 'Wednesday', times: [
          const TimeOfDay(hour: 10, minute: 18),
          const TimeOfDay(hour: 13, minute: 12),
        ]),
        PostingSchedule(day: 'Thursday', times: [
          const TimeOfDay(hour: 10, minute: 18),
          const TimeOfDay(hour: 13, minute: 12),
        ]),
        PostingSchedule(day: 'Friday', times: [
          const TimeOfDay(hour: 10, minute: 18),
          const TimeOfDay(hour: 13, minute: 12),
        ]),
        PostingSchedule(day: 'Saturday', times: [
          const TimeOfDay(hour: 10, minute: 18),
          const TimeOfDay(hour: 13, minute: 12),
        ]),
        PostingSchedule(day: 'Sunday', times: [
          const TimeOfDay(hour: 10, minute: 18),
          const TimeOfDay(hour: 13, minute: 12),
        ]),
      ],
    );
  }

  PostingScheduleState copyWith({
    List<PostingSchedule>? schedule,
    TimeOfDay? time,
    String? addAt,
  }) {
    return PostingScheduleState(
      schedule: schedule ?? this.schedule,
      time: time ?? this.time,
      addAt: addAt ?? this.addAt,
    );
  }
}
