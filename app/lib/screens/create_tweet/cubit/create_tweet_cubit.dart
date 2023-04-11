import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'create_tweet_state.dart';

class CreateTweetCubit extends Cubit<CreateTweetState> {
  CreateTweetCubit() : super(CreateTweetState.initial());

  void addNewTweet() {
    state.tweets.add({
      "id": Random().nextInt(100000),
      "content": "",
      "controller": TextEditingController(),
      "media": [],
      "polls": [],
    });
    emit(state.copyWith(tweets: state.tweets));
  }

  void removeTweet(int id) {
    state.tweets.removeWhere((element) => element["id"] == id);
    emit(state.copyWith(tweets: state.tweets));
  }

  void updateTweet(int id, String? value) {
    state.tweets.where((element) => element["id"] == id).first["content"] =
        value;
    emit(state.copyWith(tweets: state.tweets));
  }
}
