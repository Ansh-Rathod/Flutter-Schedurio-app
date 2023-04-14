// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();

class QueueTweetModel {
  String id;
  String content;
  TextEditingController controller;
  List<QueueMedia> media;
  List<dynamic> polls;
  String createdAt;

  QueueTweetModel({
    required this.id,
    required this.content,
    required this.controller,
    required this.media,
    required this.polls,
    required this.createdAt,
  });

  factory QueueTweetModel.fromMap(Map<String, dynamic> map) {
    return QueueTweetModel(
      id: map['id'],
      content: map['content'],
      media: (map['media'] as List).map((e) => QueueMedia.fromMap(e)).toList(),
      polls: map['polls'],
      createdAt: map['created_at'],
      controller: TextEditingController(),
    );
  }

  QueueTweetModel copy() {
    return QueueTweetModel(
      id: uuid.v4(),
      content: content,
      media: media.map((e) => e.copy()).toList(),
      polls: polls,
      createdAt: createdAt,
      controller: TextEditingController(),
    );
  }

  dynamic toJson() {
    return {
      "id": id,
      "content": content,
      "media": media.map((e) => e.toJson()).toList(),
      "polls": polls,
      "created_at": createdAt,
    };
  }

  factory QueueTweetModel.inital() {
    return QueueTweetModel(
      id: uuid.v4(),
      content: "",
      media: [],
      polls: [],
      controller: TextEditingController(),
      createdAt: DateTime.now().toUtc().toString(),
    );
  }
}

class QueueMedia {
  String mediaId;
  String? url;
  String? path;
  String type;
  String name;
  String extensionName;
  QueueMedia({
    required this.mediaId,
    this.url,
    this.path,
    required this.type,
    required this.name,
    required this.extensionName,
  });

  factory QueueMedia.fromMap(Map<String, dynamic> map) {
    return QueueMedia(
      mediaId: uuid.v4(),
      url: map['url'],
      path: map['local_file_path'],
      type: map['type'],
      name: map['name'],
      extensionName: map['extension_name'],
    );
  }

  QueueMedia copy() {
    return QueueMedia(
      mediaId: uuid.v4(),
      url: url,
      path: path,
      type: type,
      name: name,
      extensionName: extensionName,
    );
  }

  dynamic toJson() {
    return {
      "media_id": mediaId,
      "url": url,
      "local_file_path": path,
      "type": type,
      "name": name,
      "extension_name": extensionName,
    };
  }
}
