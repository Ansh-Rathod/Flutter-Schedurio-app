import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:schedurio/helpers.dart';
import 'package:schedurio/services/hive_cache.dart';
import 'package:schedurio/supabase.dart';

import '../../../apis/tweet_api.dart';
import '../../../config.dart';
import '../../../models/queue_tweets.dart';

part 'create_tweet_state.dart';

class CreateTweetCubit extends Cubit<CreateTweetState> {
  CreateTweetCubit() : super(CreateTweetState.initial());

  void init() async {
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

  void changeSelected(DateTime s) {
    emit(state.copyWith(selected: s));
  }

  void addNewTweet() {
    state.tweets.add(QueueTweetModel.inital());
    emit(state.copyWith(tweets: state.tweets));
  }

  void removeTweet(String id) {
    state.tweets.removeWhere((element) => element.id == id);
    emit(state.copyWith(tweets: state.tweets));
  }

  void updateTweet(String id, String? value) {
    state.tweets.where((element) => element.id == id).first.content = value!;
    emit(state.copyWith(tweets: state.tweets));
  }

  void onMediaChange(String id, List<QueueMedia> media) {
    state.tweets.where((element) => element.id == id).first.media = media;
    emit(state.copyWith(tweets: state.tweets));
  }

  void postNow() async {
    int mediaCount = 0;

    try {
      emit(state.copyWith(status: CreateTweetStatus.loading));
      // await LocalCache.filledQueue.clear();
      // await LocalCache.queue.clear();
      for (var tweet in state.tweets) {
        for (var media in tweet.media) {
          if (media.path != null) {
            final url = await supabase.storage.from('public').upload(
                "${media.type}/${tweet.id}_${media.name.replaceAll(' ', '')}",
                File(media.path!));
            media.url = "${supabase.storageUrl}/object/public/$url";
          }
          mediaCount++;
        }
      }

      final supaQueue = await supabase.from('queue').insert({
        "tweets": state.tweets.map((e) => e.toJson()).toList(),
        "scheduled_at": DateTime.now().toUtc().toString(),
        "status": "pending",
        "cron_text": 'RIGHT AWAY',
      }).select('id');

      final queueId = supaQueue.map((e) => e['id']).toList().first;
      if (mediaCount != 0) {
        await Api.updateMediaOnTweet(
          queueId: queueId.toString(),
          userId: LocalCache.currentUser
              .get(AppConfig.hiveKeys.currenUserSupabaseId)
              .toString(),
        );
      }

      await Api.postTweet(
        queueId: queueId.toString(),
        userId: LocalCache.currentUser
            .get(AppConfig.hiveKeys.currenUserSupabaseId)
            .toString(),
      );

      emit(state.copyWith(
          status: CreateTweetStatus.success, tweetStatus: 'success'));
      emit(CreateTweetState.initial());
      init();
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(status: CreateTweetStatus.error));
    }
  }

  void onAddToQueue() async {
    int mediaCount = 0;
    try {
      emit(state.copyWith(status: CreateTweetStatus.loading));
      // await LocalCache.filledQueue.clear();
      // await LocalCache.queue.clear();
      for (var tweet in state.tweets) {
        for (var media in tweet.media) {
          if (media.path != null) {
            final url = await supabase.storage.from('public').upload(
                "${media.type}/${tweet.id}_${media.name.replaceAll(' ', '')}",
                File(media.path!));
            media.url = "${supabase.storageUrl}/object/public/$url";
          }
          mediaCount++;
        }
      }

      final supaQueue = await supabase.from('queue').insert({
        "tweets": state.tweets.map((e) => e.toJson()).toList(),
        "scheduled_at": state.selected.toUtc().toString(),
        "status": "pending",
        "cron_text": dateTimeToCron(state.selected),
      }).select('id');

      final queueId = supaQueue.map((e) => e['id']).toList().first;

      if (!DateTime.now()
              .toUtc()
              .add(const Duration(minutes: 5))
              .isBefore(state.selected.toUtc()) &&
          mediaCount != 0) {
        await Api.scheduleTask(
          name: 'media-$queueId',
          expression: dateTimeToCron(
              state.selected.subtract(const Duration(minutes: 5)).toUtc()),
          url: AppConfig.updateMediaOnTweetUrl,
          queueId: queueId.toString(),
          userId: LocalCache.currentUser
              .get(AppConfig.hiveKeys.currenUserSupabaseId)
              .toString(),
        );
      }

      if (!DateTime.now()
              .toUtc()
              .add(const Duration(minutes: 5))
              .isAfter(state.selected.toUtc()) &&
          mediaCount != 0) {
        await Api.updateMediaOnTweet(
          queueId: queueId.toString(),
          userId: LocalCache.currentUser
              .get(AppConfig.hiveKeys.currenUserSupabaseId)
              .toString(),
        );
      }

      await Api.scheduleTask(
        name: 'post-$queueId',
        expression: dateTimeToCron(state.selected.toUtc()),
        url: AppConfig.postTweetUrl,
        queueId: queueId.toString(),
        userId: LocalCache.currentUser
            .get(AppConfig.hiveKeys.currenUserSupabaseId)
            .toString(),
      );

      final id =
          removeLastFourZeros(state.selected.toUtc().millisecondsSinceEpoch);

      await LocalCache.filledQueue.put(id, id);
      await LocalCache.queue.put(id, id);

      emit(state.copyWith(
          status: CreateTweetStatus.success, tweetStatus: 'success'));
      emit(CreateTweetState.initial());
      init();
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(status: CreateTweetStatus.error));
    }
  }

  void saveToDraft() async {
    try {
      emit(state.copyWith(status: CreateTweetStatus.loading));
      // await LocalCache.filledQueue.clear();
      // await LocalCache.queue.clear();
      for (var tweet in state.tweets) {
        for (var media in tweet.media) {
          if (media.path != null) {
            final url = await supabase.storage.from('public').upload(
                "${media.type}/${tweet.id}_${media.name.replaceAll(' ', '')}",
                File(media.path!));
            media.url = "${supabase.storageUrl}/object/public/$url";
          }
        }
      }

      await supabase.from('drafts').insert({
        "tweets": state.tweets.map((e) => e.toJson()).toList(),
      });

      emit(state.copyWith(
          status: CreateTweetStatus.success, tweetStatus: 'success'));
      emit(CreateTweetState.initial());
      init();
    } catch (e) {
      print(e);
      emit(state.copyWith(status: CreateTweetStatus.error));
    }
  }
}
