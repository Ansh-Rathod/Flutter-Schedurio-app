import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:schedurio_utils/schedurio_utils.dart';

import '../../../services/hive_cache.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit() : super(HomeScreenState.initial());

  void init() {
    final datasets = LocalCache.tweets.values
        .map((e) => DateTime.parse(e['posted_at']))
        .toList()
      ..sort();

    final firstTweetYear = datasets.first.year;
    final lastTweetYear = datasets.last.year;

    var year = firstTweetYear;

    var years = [year];
    while (year != lastTweetYear) {
      year = year + 1;
      years.add(year);
    }
    genrateNoOfTweet(lastTweetYear);
    emit(state.copyWith(
      years: years,
      tweets:
          LocalCache.tweets.values.map((e) => TweetModel.fromJson(e)).toList()
            ..sort((a, b) => b.postedAt.compareTo(a.postedAt)),
      data: dataSet(datasets),
      streak: countStreaks(),
      longestStreak: countLongestStreak(),
    ));
  }

  void changeDate(int year) {
    emit(state.copyWith(
        startDate: DateTime(year, 1, 1),
        endDate: DateTime(year, 1, 1).add(const Duration(days: 365))));
    genrateNoOfTweet(year);
    if (year == DateTime.now().year) {
      emit(state.copyWith(reverse: false));
      if (DateTime.now().month > 6) {
        state.scrollController.animateTo(
          state.scrollController.position.maxScrollExtent,
          duration: const Duration(microseconds: 300),
          curve: Curves.bounceInOut,
        );
      } else {
        state.scrollController.animateTo(
          state.scrollController.position.minScrollExtent,
          duration: const Duration(microseconds: 300),
          curve: Curves.bounceInOut,
        );
      }
    } else {
      emit(state.copyWith(reverse: true));
    }
  }

  void openModel(DateTime value) {
    final datasets = LocalCache.tweets.values
        .map((e) => {'id': e['id'], 'time': DateTime.parse(e['posted_at'])})
        .toList();
    var ids = [];
    for (var element in datasets) {
      if (element['time'].day == value.day &&
          element['time'].month == value.month &&
          element['time'].year == value.year) {
        ids.add(element['id']);
      }
    }

    emit(state.copyWith(
        selectedDate: value,
        tweets: ids
            .map((e) => TweetModel.fromJson(LocalCache.tweets.get(e)))
            .toList()));
  }

  Map<DateTime, int> dataSet(datasets) {
    Map<DateTime, int> map = {};

    for (var data in datasets) {
      List<DateTime> tweetsOnDay = datasets
          .where((tweetTime) =>
              tweetTime.day == data.day &&
              tweetTime.month == data.month &&
              tweetTime.year == data.year)
          .toList();

      int tweetCount = tweetsOnDay.length;
      map.addEntries(
          [MapEntry(DateTime(data.year, data.month, data.day), tweetCount)]);
    }
    return map;
  }

  void genrateNoOfTweet(int year) {
    final datasets = LocalCache.tweets.values
        .map((e) => DateTime.parse(e['posted_at']))
        .toList()
      ..sort();
    var noOfTweets = 0;
    for (var i in datasets) {
      if (i.year == year) {
        noOfTweets++;
      }
    }
    emit(state.copyWith(noOftweets: noOfTweets));
  }

  int countLongestStreak() {
    var datasets = [];
    datasets = LocalCache.tweets.values
        .map((e) => DateTime.parse(e['posted_at']))
        .toList();
    datasets = datasets
        .map((e) => DateTime(e.year, e.month, e.day))
        .toList()
        .toSet()
        .toList()
      ..sort();

    if (datasets.isEmpty) return 0;

    if (DateTime.now().difference(datasets.last).inDays > 1) {
      return 0;
    }

    int currentStreak = 1;
    int longestStreak = 1;

    // iterate through the dates and check for streaks
    for (int i = 1; i < datasets.length; i++) {
      Duration diff = datasets[i].difference(datasets[i - 1]);
      if (diff.inDays == 1) {
        currentStreak++;
      } else {
        longestStreak =
            currentStreak > longestStreak ? currentStreak : longestStreak;
        currentStreak = 1;
      }
    }

    // check the last streak in case it's the longest
    longestStreak =
        currentStreak > longestStreak ? currentStreak : longestStreak;

    return longestStreak;
  }

  void toggleCount() {
    emit(state.copyWith(showCount: !state.showCount));
  }

  int countStreaks() {
    var datasets = [];
    datasets = LocalCache.tweets.values
        .map((e) => DateTime.parse(e['posted_at']))
        .toList();

    datasets = datasets
        .map((e) => DateTime(e.year, e.month, e.day))
        .toList()
        .toSet()
        .toList()
      ..sort();
    if (datasets.isEmpty) return 0;

    if (DateTime.now().difference(datasets.last).inDays > 1) {
      return 0;
    }

    int currentStreak = 1;

    // iterate through the dates and check for streaks
    for (int i = 1; i < datasets.length; i++) {
      Duration diff = datasets[i].difference(datasets[i - 1]);
      if (diff.inDays == 1) {
        currentStreak++;
      } else {
        currentStreak = 1;
      }
    }

    return currentStreak;
  }
}
