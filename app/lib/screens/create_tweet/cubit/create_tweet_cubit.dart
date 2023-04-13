import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:schedurio/helpers.dart';
import 'package:schedurio/services/hive_cache.dart';
import 'package:schedurio/supabase.dart';

part 'create_tweet_state.dart';

class CreateTweetCubit extends Cubit<CreateTweetState> {
  CreateTweetCubit() : super(CreateTweetState.initial());

  void init({
    bool? isEdit,
    DateTime? selected,
    List<dynamic>? tweets,
  }) async {
    if (isEdit != null) {
      emit(
        state.copyWith(
          selected: selected,
          tweets: tweets!
              .map((e) => {"controller": TextEditingController(), ...e})
              .toList(),
        ),
      );
    } else {
      final queue = await getAvailableQueue()
        ..sort();
      List<DateTime> availableTimes = [];

      for (int i = 0; i < 5; i++) {
        if (queue.first.day == queue[i].day) {
          availableTimes.add(queue[i]);
        }
      }

      emit(
        state.copyWith(
          availableQueue: queue,
          availableTimesForDay: availableTimes,
          selected: queue.first,
        ),
      );
    }
  }

  void changeSelected(DateTime s) {
    emit(state.copyWith(selected: s));
  }

  void addNewTweet() {
    state.tweets.add({
      "id": Random().nextInt(100000000),
      "content": "",
      "controller": TextEditingController(),
      "media": [],
      "polls": [],
      "created_at": DateTime.now().toString(),
    });
    emit(state.copyWith(tweets: state.tweets));
  }

  void removeTweet(int id) {
    state.tweets.removeWhere((element) => element["id"] == id);
    emit(state.copyWith(tweets: state.tweets));
  }

  void updateTweet(int id, String? value) {
    state.tweets.where((element) => element["id"] == id).first["content"] =
        value;
    emit(state.copyWith(tweets: state.tweets));
  }

  void onMediaChange(int id, List<dynamic> media) {
    state.tweets.where((element) => element["id"] == id).first["media"] = media;
    emit(state.copyWith(tweets: state.tweets));
  }

  void onAddToQueue() async {
    try {
      emit(state.copyWith(status: CreateTweetStatus.loading));
      //   await LocalCache.filledQueue.clear();
      // await LocalCache.queue.clear();
      await LocalCache.filledQueue.add(state.selected.toString());

      List<dynamic> tweets = [];
      for (var tweet in state.tweets) {
        List<dynamic> urls = [];

        for (var media in tweet['media']) {
          final url = await supabase.storage.from('public').upload(
              "${media['type']}/${tweet['id'].toString()}_${media['name']}",
              File(media['path']));
          urls.add({
            'url': "${supabase.storageUrl}/object/public/$url",
            'type': media['type'],
            'name': media['name'],
            'extension': media['extension'],
          });
        }

        tweets.add({
          "id": tweet["id"],
          "content": tweet["content"],
          "media": urls,
          "polls": tweet["polls"],
          "created_at": tweet["created_at"],
        });
      }

      await supabase.from('queue').insert({
        "tweets": tweets,
        "scheduled_at": state.selected.toString(),
        "status": "pending",
        "cron_text": dateTimeToCron(state.selected),
        "cron_media":
            dateTimeToCron(state.selected.subtract(const Duration(minutes: 10)))
      });

      await LocalCache.queue.put(state.selected.toString(), tweets);
      emit(state.copyWith(status: CreateTweetStatus.success));
      emit(CreateTweetState.initial());
      init();
    } catch (e) {
      emit(state.copyWith(status: CreateTweetStatus.error));
    }
  }
}
