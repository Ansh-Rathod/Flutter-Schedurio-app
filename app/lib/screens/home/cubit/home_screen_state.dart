// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_screen_cubit.dart';

class HomeScreenState {
  final DateTime startDate;
  final int noOftweets;
  final int streak;
  final int longestStreak;
  final DateTime? selectedDate;
  final DateTime endDate;
  final Map<DateTime, int> data;
  final DateTime firstTweetYear;
  final bool showCount;
  final ScrollController scrollController;
  final List<int> years;
  final List<TweetModel> tweets;
  final bool reverse;
  HomeScreenState({
    required this.startDate,
    required this.noOftweets,
    required this.streak,
    required this.longestStreak,
    this.selectedDate,
    required this.endDate,
    required this.data,
    required this.firstTweetYear,
    required this.showCount,
    required this.scrollController,
    required this.years,
    required this.tweets,
    required this.reverse,
  });

  factory HomeScreenState.initial() {
    return HomeScreenState(
      longestStreak: 0,
      streak: 0,
      years: [],
      noOftweets: 0,
      tweets: [],
      scrollController: ScrollController(),
      firstTweetYear: DateTime(2021, 1, 1),
      showCount: false,
      startDate: DateTime(DateTime.now().year, 1, 1),
      endDate:
          DateTime(DateTime.now().year, 1, 1).add(const Duration(days: 365)),
      data: {},
      reverse: false,
    );
  }

  HomeScreenState copyWith({
    DateTime? startDate,
    int? noOftweets,
    int? streak,
    int? longestStreak,
    DateTime? selectedDate,
    DateTime? endDate,
    Map<DateTime, int>? data,
    DateTime? firstTweetYear,
    bool? showCount,
    ScrollController? scrollController,
    List<int>? years,
    List<TweetModel>? tweets,
    bool? reverse,
  }) {
    return HomeScreenState(
      startDate: startDate ?? this.startDate,
      noOftweets: noOftweets ?? this.noOftweets,
      streak: streak ?? this.streak,
      longestStreak: longestStreak ?? this.longestStreak,
      selectedDate: selectedDate ?? this.selectedDate,
      endDate: endDate ?? this.endDate,
      data: data ?? this.data,
      firstTweetYear: firstTweetYear ?? this.firstTweetYear,
      showCount: showCount ?? this.showCount,
      scrollController: scrollController ?? this.scrollController,
      years: years ?? this.years,
      tweets: tweets ?? this.tweets,
      reverse: reverse ?? this.reverse,
    );
  }
}
