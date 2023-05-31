// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:schedurio/models/queue_tweets.dart';

class QueueModel {
  DateTime dateTime;
  List<QueueDayTime> times;
  QueueModel({
    required this.dateTime,
    required this.times,
  });
}

class QueueDayTime {
  TimeOfDay time;
  DateTime fullDate;
  String id;
  List<QueueTweetModel>? tweets;
  QueueDayTime({
    required this.time,
    required this.fullDate,
    required this.id,
    this.tweets,
  });

  QueueDayTime copy() {
    return QueueDayTime(
        time: time,
        id: id,
        fullDate: fullDate,
        tweets: tweets != null
            ? tweets!.map((tweet) => tweet.copy()).toList()
            : null);
  }
}
