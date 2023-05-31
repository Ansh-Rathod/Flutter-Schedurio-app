import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:schedurio/models/queue_tweets.dart';

import '../../../apis/tweet_api.dart';
import '../../../config.dart';
import '../../../helpers.dart';
import '../../../services/hive_cache.dart';
import '../../../supabase.dart';

part 'drafts_screen_state.dart';

class DraftsScreenCubit extends Cubit<DraftsScreenState> {
  DraftsScreenCubit() : super(DraftsScreenState.initial());

  Future<void> init() async {
    try {
      emit(state.copyWith(status: FetchTweetsStatus.loading));

      final tweets = await supabase
          .from('drafts')
          .select('tweets,id')
          .limit(100)
          .order('created_at', ascending: false);

      final List<dynamic> encoded = tweets.map((e) {
        final list = (e['tweets'] as List)
            .map((tweet) => QueueTweetModel.fromMap(tweet))
            .toList();
        final map = {'id': e['id'], 'tweets': list};
        return map;
      }).toList();
      emit(state.copyWith(tweets: encoded, status: FetchTweetsStatus.loaded));
    } catch (e) {
      print(e);
      emit(state.copyWith(status: FetchTweetsStatus.error));
    }
  }

  void removeTweet(int id) {
    state.tweets.removeWhere((element) => element['id'] == id);

    emit(state.copyWith(tweets: state.tweets));
  }

  Future<String> postNow(String draftId, List<QueueTweetModel> tweets) async {
    int mediaCount = 0;

    try {
      // await LocalCache.filledQueue.clear();
      // await LocalCache.queue.clear();
      for (var tweet in tweets) {
        for (var media in tweet.media) {
          mediaCount++;
        }
      }

      final supaQueue = await supabase.from('queue').insert({
        "tweets": tweets.map((e) => e.toJson()).toList(),
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

      await supabase.from('drafts').delete().eq('id', draftId);

      removeTweet(int.parse(draftId));
      return 'success';
    } catch (e) {
      print(e.toString());
      return 'error';
    }
  }

  Future<String> addToQueue(
      String draftId, List<QueueTweetModel> tweets) async {
    try {
      int mediaCount = 0;
      final queue = await getAvailableQueue()
        ..sort();
      final selectedTime = queue.first;
      await supabase.from('drafts').delete().eq('id', draftId);
      for (var tweet in tweets) {
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
        "tweets": tweets.map((e) => e.toJson()).toList(),
        "scheduled_at": selectedTime.toUtc().toString(),
        "status": "pending",
        "cron_text": dateTimeToCron(selectedTime),
      }).select('id');

      final queueId = supaQueue.map((e) => e['id']).toList().first;

      if (!DateTime.now()
              .toUtc()
              .add(const Duration(minutes: 5))
              .isBefore(selectedTime.toUtc()) &&
          mediaCount != 0) {
        await Api.scheduleTask(
          name: 'media-$queueId',
          expression: dateTimeToCron(
              selectedTime.subtract(const Duration(minutes: 5)).toUtc()),
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
              .isAfter(selectedTime.toUtc()) &&
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
        expression: dateTimeToCron(selectedTime.toUtc()),
        url: AppConfig.postTweetUrl,
        queueId: queueId.toString(),
        userId: LocalCache.currentUser
            .get(AppConfig.hiveKeys.currenUserSupabaseId)
            .toString(),
      );

      final id =
          removeLastFourZeros(selectedTime.toUtc().millisecondsSinceEpoch);

      await LocalCache.filledQueue.put(id, id);
      await LocalCache.queue.put(id, id);
      removeTweet(int.parse(draftId));
      return 'success';
    } catch (e) {
      return 'error';
    }
  }
}
