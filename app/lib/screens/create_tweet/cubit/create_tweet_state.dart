// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_tweet_cubit.dart';

class CreateTweetState {
  final List<dynamic> tweets;
  CreateTweetState({
    required this.tweets,
  });

  factory CreateTweetState.initial() {
    return CreateTweetState(
      tweets: [
        {
          "id": 1,
          "content": "",
          "controller": TextEditingController(),
          "media": [],
          "polls": [],
        }
      ],
    );
  }

  CreateTweetState copyWith({
    List<dynamic>? tweets,
  }) {
    return CreateTweetState(
      tweets: tweets ?? this.tweets,
    );
  }
}
