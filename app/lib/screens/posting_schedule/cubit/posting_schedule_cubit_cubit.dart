import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:schedurio/helpers.dart';

import '../../../models/posting_schedule.dart';
import '../../../services/hive_cache.dart';

part 'posting_schedule_cubit_state.dart';

class PostingScheduleCubit extends Cubit<PostingScheduleState> {
  PostingScheduleCubit() : super(PostingScheduleState.initial());

  void changeTime(TimeOfDay time) {
    emit(state.copyWith(time: time));
  }

  void init() {
    try {
      List<PostingSchedule> schedule = [];
      for (int i = 0; i < 7; i++) {
        if (LocalCache.schedule.get(getDayOfWeek(i)) != null) {
          final times = LocalCache.schedule.get(getDayOfWeek(i)).toList();
          schedule.add(PostingSchedule.fromJson({
            'day': getDayOfWeek(i),
            'times': times,
          }));
        }

        if (schedule.isNotEmpty) {
          emit(state.copyWith(schedule: schedule));
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void changeAddAt(String? addAt) {
    emit(state.copyWith(addAt: addAt));
  }

  void removeTime(TimeOfDay time, String day) {
    final List<PostingSchedule> schedule = state.schedule;

    final item = schedule
        .where((element) => element.day.toLowerCase() == day.toLowerCase())
        .first;

    item.times.remove(time);
    item.times.sort((a, b) => a.toString().compareTo(b.toString()));

    emit(state.copyWith(schedule: schedule));
  }

  void addTime() {
    final List<PostingSchedule> schedule = state.schedule;

    if (state.addAt == 'All') {
      for (var item in schedule) {
        if (!item.times.contains(state.time)) {
          item.times.add(state.time);
        }
        item.times.sort((a, b) => a.toString().compareTo(b.toString()));
      }

      emit(state.copyWith(schedule: schedule));
    } else {
      final item = schedule
          .where((element) =>
              element.day.toLowerCase() == state.addAt.toLowerCase())
          .first;

      if (!item.times.contains(state.time)) {
        item.times.add(state.time);
      }
      item.times.sort((a, b) => a.toString().compareTo(b.toString()));

      emit(state.copyWith(schedule: schedule));
    }
  }

  void randomizeTime() {
    for (var item in state.schedule) {
      item.randomizeTimes();
    }
    emit(state.copyWith(schedule: state.schedule));
  }

  void reset() {
    emit(PostingScheduleState.initial());
  }

  void save() async {
    for (var item in state.schedule) {
      await LocalCache.schedule.put(item.day, item.toJson()['times']);
    }
  }
}
