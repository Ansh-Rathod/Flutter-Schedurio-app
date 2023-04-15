// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'history_screen_cubit.dart';

class HistoryScreenState {
  final FetchTweetsStatus status;
  final List<dynamic> tweets;
  HistoryScreenState({
    required this.status,
    required this.tweets,
  });

  factory HistoryScreenState.initial() {
    return HistoryScreenState(
      status: FetchTweetsStatus.inital,
      tweets: [],
    );
  }

  HistoryScreenState copyWith({
    FetchTweetsStatus? status,
    List<dynamic>? tweets,
  }) {
    return HistoryScreenState(
      status: status ?? this.status,
      tweets: tweets ?? this.tweets,
    );
  }
}
