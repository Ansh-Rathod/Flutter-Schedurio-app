// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();

class QueueTweetModelEdge {
  String id;
  String content;
  List<QueueMedia> media;
  List<dynamic> polls;
  List<dynamic> mediaIds;
  String createdAt;

  QueueTweetModelEdge({
    required this.id,
    required this.content,
    required this.media,
    required this.polls,
    required this.mediaIds,
    required this.createdAt,
  });

  factory QueueTweetModelEdge.fromMap(dynamic map) {
    return QueueTweetModelEdge(
      id: map['id'] as String,
      content: map['content'] as String,
      media: (map['media'] as List).map(QueueMedia.fromMap).toList() ?? [],
      polls: map['polls'] as List<dynamic>,
      mediaIds: (map['media_ids'] ?? []) as List<dynamic>,
      createdAt: map['created_at'] as String,
    );
  }

  dynamic toJson() {
    return {
      'id': id,
      'content': content,
      'media': media.map((e) => e.toJson()).toList(),
      'polls': polls,
      'media_ids': mediaIds,
      'created_at': createdAt,
    };
  }
}

class QueueMedia {
  String mediaId;
  String? url;
  String type;
  String name;
  String extensionName;
  QueueMedia({
    required this.mediaId,
    this.url,
    required this.type,
    required this.name,
    required this.extensionName,
  });

  factory QueueMedia.fromMap(map) {
    return QueueMedia(
      mediaId: map['media_id'] as String,
      url: map['url'] as String?,
      type: map['type'] as String,
      name: map['name'] as String,
      extensionName: map['extension_name'] as String,
    );
  }

  dynamic toJson() {
    return {
      'media_id': mediaId,
      'url': url,
      'type': type,
      'name': name,
      'extension_name': extensionName,
    };
  }
}
