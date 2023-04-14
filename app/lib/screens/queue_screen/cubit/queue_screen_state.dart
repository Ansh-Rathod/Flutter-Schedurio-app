// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'queue_screen_cubit.dart';

enum FetchTweetsStatus { loading, loaded, error, inital }

class QueueScreenState {
  final List<dynamic> tweets;
  final FetchTweetsStatus status;
  final List<QueueModel> queue;
  QueueScreenState({
    required this.tweets,
    required this.status,
    required this.queue,
  });

  factory QueueScreenState.initial() {
    return QueueScreenState(
      tweets: [],
      queue: [],
      status: FetchTweetsStatus.inital,
    );
  }
  QueueScreenState copyWith({
    List<dynamic>? tweets,
    FetchTweetsStatus? status,
    List<QueueModel>? queue,
  }) {
    return QueueScreenState(
      tweets: tweets ?? this.tweets,
      status: status ?? this.status,
      queue: queue ?? this.queue,
    );
  }
}
