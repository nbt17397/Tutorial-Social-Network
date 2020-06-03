import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String imageUrl;
  final String caption;
  final int likeCount;
  final String authorId;
  final Timestamp timestamp;
  final String authorName;
  final String authorImage;

  Post({
    this.id,
    this.imageUrl,
    this.caption,
    this.likeCount,
    this.authorId,
    this.timestamp,
    this.authorImage,
    this.authorName,
  });

  factory Post.fromDoc(DocumentSnapshot doc) {
    return Post(
      id: doc.documentID,
      imageUrl: doc['imageUrl'],
      caption: doc['caption'],
      likeCount: doc['likeCount'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
      authorImage: doc['authorImage'],
      authorName: doc['authorName'],
    );
  }

  Post.fromMap(Map<String, dynamic> data, String id)
      : id = id,
        caption = data['caption'],
        authorName = data['authorName'],
        authorImage = data['authorImage'],
        authorId = data['authorId'],
        imageUrl = data['imageUrl'],
        likeCount = data['likeCount'],
        timestamp = data['timestamp'];

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'caption': caption,
      'likeCount': likeCount,
      'authorId': authorId,
      'timestamp': timestamp,
      'authorImage': authorImage,
      'authorNamme': authorName,
    };
  }
}
