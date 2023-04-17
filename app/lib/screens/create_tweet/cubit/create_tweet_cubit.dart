import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:schedurio/helpers.dart';
import 'package:schedurio/services/hive_cache.dart';
import 'package:schedurio/supabase.dart';

import '../../../config.dart';
import '../../../models/queue_tweets.dart';

part 'create_tweet_state.dart';

class CreateTweetCubit extends Cubit<CreateTweetState> {
  CreateTweetCubit() : super(CreateTweetState.initial());

  void init() async {
    // await LocalCache.filledQueue.clear();
    // await LocalCache.queue.clear();

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

  void onAddToQueue() async {
    try {
      emit(state.copyWith(status: CreateTweetStatus.loading));
      // await LocalCache.filledQueue.clear();
      // await LocalCache.queue.clear();
      for (var tweet in state.tweets) {
        for (var media in tweet.media) {
          final url = await supabase.storage.from('public').upload(
              "${media.type}/${tweet.id}_${media.name}", File(media.path!));

          media.url = "${supabase.storageUrl}/object/public/$url";
        }
      }

      final supaQueue = await supabase.from('queue').insert({
        "tweets": state.tweets.map((e) => e.toJson()).toList(),
        "scheduled_at": state.selected.toUtc().toString(),
        "status": "pending",
        "cron_text": dateTimeToCron(state.selected),
        "cron_media":
            dateTimeToCron(state.selected.subtract(const Duration(minutes: 10)))
      }).select('id');
      final queueId = supaQueue.map((e) => e['id']).toList().first;

// name TEXT, expression TEXT,queue_id INTEGER, user_id INTEGER,headers_input TEXT,url TEXT,body TEXT
      await supabase.rpc('schedule_tweet_post', params: {
        'name':
            'queue-$queueId-${LocalCache.currentUser.get(AppConfig.hiveKeys.currenUserSupabaseId)}',
        'expression': dateTimeToCron(state.selected),
        'queue_id': queueId,
        'user_id':
            LocalCache.currentUser.get(AppConfig.hiveKeys.currenUserSupabaseId),
        'headers_input':
            '{"Content-Type": "application/json", "Authorization": "Bearer ${LocalCache.currentUser.get(AppConfig.supabaseToken)}"}',
        'url': AppConfig.postTweetEdgeUrl,
        'body':
            '{"queueId": $queueId, "userId": "${LocalCache.currentUser.get(AppConfig.hiveKeys.currenUserSupabaseId)}"}'
      });

      final id =
          removeLastFourZeros(state.selected.toUtc().millisecondsSinceEpoch);
      print(id);
      await LocalCache.filledQueue.put(id, id);
      await LocalCache.queue.put(id, id);

      print('added to queue');

      emit(state.copyWith(status: CreateTweetStatus.success));
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
          final url = await supabase.storage.from('public').upload(
              "${media.type}/${tweet.id}_${media.name}", File(media.path!));

          media.url = "${supabase.storageUrl}/object/public/$url";
        }
      }

      await supabase.from('drafts').insert({
        "tweets": state.tweets.map((e) => e.toJson()).toList(),
      });

      print("saved");
      emit(state.copyWith(status: CreateTweetStatus.success));
      emit(CreateTweetState.initial());
      init();
    } catch (e) {
      print(e);
      emit(state.copyWith(status: CreateTweetStatus.error));
    }
  }
}
