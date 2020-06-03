import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final String content;
  final String authorId;
  final Timestamp timestamp;
  Chat({this.authorId, this.id, this.timestamp, this.content});

  Chat.fromMap(Map<String, dynamic> data, String id)
      : id = id,
        content = data['content'],
        authorId = data['authorId'],
        timestamp = data['timestamp'];

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'authorId': authorId,
      'timestamp': timestamp,
    };
  }
}
