import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:schedurio/models/queue_tweets.dart';

import '../../../helpers.dart';
import '../../../supabase.dart';

part 'edit_tweet_state.dart';

class EditTweetCubit extends Cubit<EditTweetState> {
  EditTweetCubit() : super(EditTweetState.initial());

  void init({
    required int? isDraft,
    required DateTime selected,
    required List<QueueTweetModel> tweets,
  }) async {
    if (isDraft == null) {
      final newTweets = tweets;
      final selec = selected;
      for (var element in newTweets) {
        element.controller.text = element.content;
      }

      emit(
        state.copyWith(
          selected: selec,
          availableTimesForDay: [selec],
          editedTweets: newTweets,
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
      final newTweets = tweets;
      for (var element in newTweets) {
        element.controller.text = element.content;
      }

      emit(
        state.copyWith(
          availableQueue: queue,
          availableTimesForDay: availableTimes,
          selected: queue.first,
          isDraft: isDraft,
          editedTweets: newTweets,
        ),
      );
    }
  }

  void changeSelected(DateTime s) {
    emit(state.copyWith(selected: s));
  }

  void addNewTweet() {
    state.editedTweets.add(QueueTweetModel.inital());
    emit(state.copyWith(editedTweets: state.editedTweets));
  }

  void removeTweet(String id) {
    state.editedTweets.removeWhere((element) => element.id == id);
    emit(state.copyWith(editedTweets: state.editedTweets));
  }

  void updateTweet(String id, String? value) {
    state.editedTweets.where((element) => element.id == id).first.content =
        value!;
    emit(state.copyWith(editedTweets: state.editedTweets));
  }

  void onMediaChange(String id, List<QueueMedia> media) {
    state.editedTweets.where((element) => element.id == id).first.media = media;
    emit(state.copyWith(editedTweets: state.editedTweets));
  }

  Future<void> onUpdate() async {
    try {
      emit(state.copyWith(status: EditTweetStatus.loading));

      for (var tweet in state.editedTweets) {
        for (var media in tweet.media) {
          if (media.path != null) {
            final url = await supabase.storage.from('public').upload(
                "${media.type}/${tweet.id}_${media.name.replaceAll(' ', '')}",
                File(media.path!));
            media.url = "${supabase.storageUrl}/object/public/$url";
          }
        }
      }
      if (state.isDraft != null) {
        await supabase.from('drafts').update({
          "tweets": state.editedTweets.map((e) => e.toJson()).toList(),
        }).eq('id', state.isDraft);
      } else {
        await supabase.from('queue').update({
          "tweets": state.editedTweets.map((e) => e.toJson()).toList(),
          "scheduled_at": state.selected.toUtc().toString(),
        }).eq('scheduled_at', state.selected.toUtc().toString());
      }
      emit(state.copyWith(status: EditTweetStatus.success));
    } catch (e) {
      print(e);
      emit(state.copyWith(status: EditTweetStatus.error));
    }
  }
}
