import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = Firestore.instance;
final storageRef =
    FirebaseStorage.instance.ref(); // swap ảnh đại diện bằng storage
final usersRef = _firestore.collection('users');
final postsRef = _firestore.collection('posts');
final followersRef = _firestore.collection('followers');
final followingRef = _firestore.collection('following');
final feedsRef = _firestore.collection('feeds');
final likesRef = _firestore.collection('likes');
final commentsRef = _firestore.collection('comments');
final activitiesRef = _firestore.collection('activities');
final newItemRef = _firestore.collection('items');
final itemBoughtRef = _firestore.collection('itemboughts');
final chatRef = _firestore.collection('chats');

