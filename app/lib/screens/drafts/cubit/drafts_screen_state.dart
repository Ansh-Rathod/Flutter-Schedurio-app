// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'drafts_screen_cubit.dart';

enum FetchTweetsStatus { loading, loaded, error, inital }

class DraftsScreenState {
  final List<dynamic> tweets;
  final FetchTweetsStatus status;
  DraftsScreenState({
    required this.tweets,
    required this.status,
  });
  factory DraftsScreenState.initial() {
    return DraftsScreenState(
      tweets: [],
      status: FetchTweetsStatus.inital,
    );
  }

  DraftsScreenState copyWith({
    List<dynamic>? tweets,
    FetchTweetsStatus? status,
  }) {
    return DraftsScreenState(
      tweets: tweets ?? this.tweets,
      status: status ?? this.status,
    );
  }
}
