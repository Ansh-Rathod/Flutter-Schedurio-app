// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_tweet_cubit.dart';

enum CreateTweetStatus { initial, loading, success, error }

class CreateTweetState {
  final CreateTweetStatus status;
  final List<dynamic> tweets;
  final List<DateTime> availableQueue;
  final DateTime selected;
  final List<DateTime> availableTimesForDay;

  CreateTweetState({
    required this.status,
    required this.tweets,
    required this.availableQueue,
    required this.selected,
    required this.availableTimesForDay,
  });

  factory CreateTweetState.initial() {
    return CreateTweetState(
      availableQueue: [],
      status: CreateTweetStatus.initial,
      selected: DateTime.now(),
      availableTimesForDay: [],
      tweets: [
        {
          "id": Random().nextInt(100000000),
          "content": "",
          "controller": TextEditingController(),
          "media": [],
          "polls": [],
          "created_at": DateTime.now().toString(),
        }
      ],
    );
  }

  CreateTweetState copyWith({
    CreateTweetStatus? status,
    List<dynamic>? tweets,
    List<DateTime>? availableQueue,
    DateTime? selected,
    List<DateTime>? availableTimesForDay,
  }) {
    return CreateTweetState(
      status: status ?? this.status,
      tweets: tweets ?? this.tweets,
      availableQueue: availableQueue ?? this.availableQueue,
      selected: selected ?? this.selected,
      availableTimesForDay: availableTimesForDay ?? this.availableTimesForDay,
    );
  }
}
