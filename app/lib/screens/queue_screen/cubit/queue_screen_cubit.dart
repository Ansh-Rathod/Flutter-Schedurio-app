import 'package:bloc/bloc.dart';
import 'package:schedurio/models/queue_model.dart';
import 'package:schedurio/models/queue_tweets.dart';
import 'package:schedurio/supabase.dart';

import '../../../apis/tweet_api.dart';
import '../../../config.dart';
import '../../../helpers.dart';
import '../../../services/hive_cache.dart';

part 'queue_screen_state.dart';

class QueueScreenCubit extends Cubit<QueueScreenState> {
  QueueScreenCubit() : super(QueueScreenState.initial());

  void init() async {
    try {
      emit(state.copyWith(status: FetchTweetsStatus.loading));
      final tweets = await supabase
          .from('queue')
          .select('id,tweets,scheduled_at')
          .gt(
              'scheduled_at',
              DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
              ).toUtc().toString())
          .order('scheduled_at');

      final List<dynamic> encoded = tweets.map((e) {
        final list = (e['tweets'] as List)
            .map((tweet) => QueueTweetModel.fromMap(tweet))
            .toList();

        final map = {
          'id': e['id'],
          'scheduled_at': DateTime.parse(e['scheduled_at']).toUtc().toString(),
          'tweets': list
        };
        return map;
      }).toList();
      final queue = await createQueueList(encoded);
      emit(
        state.copyWith(
          tweets: encoded,
          queue: queue,
          status: FetchTweetsStatus.loaded,
        ),
      );
    } catch (e) {
      print(e);
      emit(state.copyWith(status: FetchTweetsStatus.error));
    }
  }

  void removeTweet(DateTime dateTime, DateTime fullDate) {
    state.queue
        .where((element) => element.dateTime == dateTime)
        .first
        .times
        .where((element) => element.fullDate == fullDate)
        .first
        .tweets = null;

    emit(state.copyWith(queue: state.queue));
  }

  Future<String> postNow(DateTime date, List<QueueTweetModel> tweets,
      DateTime dateTime, String queueId) async {
    int mediaCount = 0;

    try {
      // await LocalCache.filledQueue.clear();
      // await LocalCache.queue.clear();
      for (var tweet in tweets) {
        for (var media in tweet.media) {
          mediaCount++;
        }
      }
      await Future.wait([
        supabase.from('queue').update({
          "scheduled_at": DateTime.now().toUtc().toString(),
          "cron_text": 'RIGHT AWAY',
        }).eq('id', queueId),
        supabaseCron.from('job').delete().eq('jobname', 'post-$queueId'),
        supabaseCron.from('job').delete().eq('jobname', 'media-$queueId'),
      ]);
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

      await LocalCache.filledQueue
          .remove(removeLastFourZeros(date.millisecondsSinceEpoch));

      await LocalCache.queue
          .remove(removeLastFourZeros(date.millisecondsSinceEpoch));

      return 'success';
    } catch (e) {
      print(e.toString());

      return 'error';
    }
  }

  Future<void> delete(
      DateTime fullDate, DateTime dateTime, String queueID) async {
    await Future.wait([
      supabase.from('queue').delete().eq('id', queueID),
      supabaseCron.from('job').delete().eq('jobname', 'post-$queueID'),
      supabaseCron.from('job').delete().eq('jobname', 'media-$queueID'),
      LocalCache.filledQueue
          .remove(removeLastFourZeros(fullDate.millisecondsSinceEpoch)),
      LocalCache.queue
          .remove(removeLastFourZeros(fullDate.millisecondsSinceEpoch)),
    ]);
  }
}
