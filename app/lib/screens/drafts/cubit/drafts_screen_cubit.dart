import 'package:bloc/bloc.dart';
import 'package:schedurio/models/queue_tweets.dart';

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
}
