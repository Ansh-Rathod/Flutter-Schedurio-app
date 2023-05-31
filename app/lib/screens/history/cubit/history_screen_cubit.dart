import 'package:bloc/bloc.dart';

import '../../../models/queue_tweets.dart';
import '../../../supabase.dart';
import '../../drafts/cubit/drafts_screen_cubit.dart';

part 'history_screen_state.dart';

class HistoryScreenCubit extends Cubit<HistoryScreenState> {
  HistoryScreenCubit() : super(HistoryScreenState.initial());

  Future<void> init() async {
    try {
      emit(state.copyWith(status: FetchTweetsStatus.loading));

      final tweets = await supabase
          .from('queue')
          .select('tweets,id,status, scheduled_at,twitter_id')
          .neq('status', 'pending')
          .limit(100)
          .order('created_at', ascending: false);

      final List<dynamic> encoded = tweets.map((e) {
        final list = (e['tweets'] as List)
            .map((tweet) => QueueTweetModel.fromMap(tweet))
            .toList();
        print(e['twitter_id']);
        final map = {
          'id': e['id'],
          'twitter_id': e['twitter_id'],
          'tweets': list,
          'status': e['status']
        };
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
}
