import 'package:bloc/bloc.dart';
import 'package:schedurio/models/queue_model.dart';
import 'package:schedurio/models/queue_tweets.dart';
import 'package:schedurio/supabase.dart';

import '../../../helpers.dart';

part 'queue_screen_state.dart';

class QueueScreenCubit extends Cubit<QueueScreenState> {
  QueueScreenCubit() : super(QueueScreenState.initial());

  void init() async {
    try {
      emit(state.copyWith(status: FetchTweetsStatus.loading));
      final tweets = await supabase
          .from('queue')
          .select('tweets,scheduled_at')
          .eq('status', 'pending');

      final List<dynamic> encoded = tweets.map((e) {
        final list = (e['tweets'] as List)
            .map((tweet) => QueueTweetModel.fromMap(tweet))
            .toList();

        final map = {
          'scheduled_at': DateTime.parse(e['scheduled_at']).toUtc().toString(),
          'tweets': list
        };
        return map;
      }).toList();
      print(encoded);
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
}
