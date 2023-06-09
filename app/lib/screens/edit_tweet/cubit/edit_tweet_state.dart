// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'edit_tweet_cubit.dart';

enum EditTweetStatus { initial, loading, success, error }

class EditTweetState {
  final EditTweetStatus status;
  final List<QueueTweetModel> editedTweets;
  final List<DateTime> availableQueue;
  final DateTime selected;
  final int? isDraft;
  final List<DateTime> availableTimesForDay;

  EditTweetState({
    required this.status,
    required this.editedTweets,
    required this.availableQueue,
    required this.selected,
    required this.isDraft,
    required this.availableTimesForDay,
  });

  factory EditTweetState.initial() {
    return EditTweetState(
      availableQueue: [],
      isDraft: null,
      status: EditTweetStatus.initial,
      selected: DateTime.now(),
      availableTimesForDay: [],
      editedTweets: [],
    );
  }

  EditTweetState copyWith({
    EditTweetStatus? status,
    List<QueueTweetModel>? editedTweets,
    List<DateTime>? availableQueue,
    DateTime? selected,
    int? isDraft,
    List<DateTime>? availableTimesForDay,
  }) {
    return EditTweetState(
      status: status ?? this.status,
      editedTweets: editedTweets ?? this.editedTweets,
      availableQueue: availableQueue ?? this.availableQueue,
      selected: selected ?? this.selected,
      isDraft: isDraft ?? this.isDraft,
      availableTimesForDay: availableTimesForDay ?? this.availableTimesForDay,
    );
  }
}
