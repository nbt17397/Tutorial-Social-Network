import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String fromUserId;
  final String postId;
  final String postImageUrl;
  final String comment;
  final Timestamp timestamp;
  final String isReading;

  Activity({
    this.id,
    this.fromUserId,
    this.postId,
    this.postImageUrl,
    this.comment,
    this.timestamp,
    this.isReading
  });

  factory Activity.fromDoc(DocumentSnapshot doc) {
    return Activity(
      id: doc.documentID,
      fromUserId: doc['fromUserId'],
      postId: doc['postId'],
      postImageUrl: doc['postImageUrl'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
      isReading: doc['isReading']
    );
  }
}