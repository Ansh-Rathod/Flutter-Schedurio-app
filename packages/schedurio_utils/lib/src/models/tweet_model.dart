// ignore_for_file:  sort_constructors_first, avoid_dynamic_calls
// ignore_for_file: public_member_api_docs

class TweetModel {
  TweetModel({
    required this.id,
    required this.authorId,
    required this.content,
    required this.scrapedAt,
    required this.postedAt,
    required this.publicMetrics,
    required this.media,
    required this.polls,
  });

  factory TweetModel.fromJson(dynamic json) {
    return TweetModel(
      id: json['id'] as String,
      authorId: json['author_id'] as String,
      content: json['text'] as String,
      scrapedAt: json['scraped_at'] != null
          ? DateTime.parse(json['scraped_at'] as String)
          : DateTime.now(),
      postedAt: DateTime.parse(json['created_at'] as String),
      publicMetrics: PublicMetrics.fromJson(
        json['public_metrics'] as Map<String, dynamic>,
      ),
      media: json['media'] != null
          ? (json['media'] as List<dynamic>)
              .map((e) => Media.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      polls: json['polls'] != null
          ? Poll.fromJson((json['polls'] as List<Map<String, dynamic>>).first)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_id': authorId,
      'content': content,
      'scraped_at': scrapedAt.toIso8601String(),
      'posted_at': postedAt.toIso8601String(),
      'public_metrics': publicMetrics.toJson(),
      'media': media?.map((e) => e.toJson()).toList(),
      'polls': polls != null ? polls?.toJson() : [],
    };
  }

  final String id;
  final String authorId;
  final String content;
  final DateTime scrapedAt;
  final DateTime postedAt;
  final PublicMetrics publicMetrics;
  final List<Media>? media;
  final Poll? polls;
}

class Poll {
  final String id;
  final int durationMinutes;
  final DateTime endDatetime;
  final String votingStatus;
  final List<PollOptions> options;
  Poll({
    required this.id,
    required this.durationMinutes,
    required this.endDatetime,
    required this.votingStatus,
    required this.options,
  });
  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      id: json['id'] as String,
      durationMinutes: json['duration_minutes'] as int,
      endDatetime: DateTime.parse(json['end_datetime'] as String),
      votingStatus: json['voting_status'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => PollOptions.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'duration_minutes': durationMinutes,
      'end_datetime': endDatetime.toIso8601String(),
      'voting_status': votingStatus,
      'options': options.map((e) => e.toJson()).toList(),
    };
  }
}

class PollOptions {
  final String label;
  final int position;
  final int votes;
  PollOptions({
    required this.label,
    required this.position,
    required this.votes,
  });
  factory PollOptions.fromJson(Map<String, dynamic> json) {
    return PollOptions(
      label: json['label'] as String,
      position: json['position'] as int,
      votes: json['votes'] as int,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'position': position,
      'votes': votes,
    };
  }
}

class Media {
  Media({
    required this.type,
    required this.key,
    required this.url,
    required this.width,
    required this.height,
    this.duration,
    this.variants,
    this.views,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      type: json['type'] as String,
      key: json['media_key'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      duration: json['duration_ms'] as int?,
      views: json['public_metrics'] != null
          ? json['public_metrics']['view_count'] as int?
          : null,
      url: (json['url'] ?? json['preview_image_url']) as String,
      variants: json['variants'] != null
          ? (json['variants'] as List<dynamic>)
              .map((e) => Varients.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'media_key': key,
      'type': type,
      'url': url,
      'width': width,
      'height': height,
      'duration': duration,
      'variants': variants?.map((e) => e.toJson()).toList(),
      'views': views,
    };
  }

  final String type;
  final String key;
  final String url;
  final int width;
  final int height;
  final int? duration;
  final List<Varients>? variants;
  final int? views;
}

class Varients {
  Varients({
    required this.url,
    required this.bitRate,
    required this.contentType,
  });
  final String url;
  final int? bitRate;
  final String contentType;
  factory Varients.fromJson(Map<String, dynamic> json) {
    return Varients(
      url: json['url'] as String,
      bitRate: json['bit_rate'] != null ? json['bit_rate'] as int : null,
      contentType: json['content_type'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'bit_rate': bitRate,
      'content_type': contentType,
    };
  }
}

class PublicMetrics {
  PublicMetrics({
    required this.retweetCount,
    required this.replyCount,
    required this.likeCount,
    required this.quoteCount,
    required this.impressionCount,
  });

  factory PublicMetrics.fromJson(Map<String, dynamic> json) {
    return PublicMetrics(
      retweetCount: json['retweet_count'] as int,
      replyCount: json['reply_count'] as int,
      likeCount: json['like_count'] as int,
      quoteCount: json['quote_count'] as int,
      impressionCount: json['impression_count'] as int,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'retweet_count': retweetCount,
      'reply_count': replyCount,
      'like_count': likeCount,
      'quote_count': quoteCount,
      'impression_count': impressionCount,
    };
  }

  int retweetCount;
  int replyCount;
  int likeCount;
  int quoteCount;
  int impressionCount;
}
