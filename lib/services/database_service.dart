import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep2020/models/activity_model.dart';
import 'package:doantotnghiep2020/models/chat_model.dart';
import 'package:doantotnghiep2020/models/item_model.dart';
import 'package:doantotnghiep2020/models/post_model.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:doantotnghiep2020/utilities/constants.dart';

class DatabaseService {
  static void updateUser(User user) {
    usersRef.document(user.id).updateData({
      'name': user.name,
      'profileImageUrl': user.profileImageUrl,
      'bannerImageUrl': user.bannerImageUrl,
      'bio': user.bio,
      'birthday': user.birthday,
      'school': user.school,
      'address': user.address,
      'phone': user.phone,
      'storyImageUrl': user.storyImageUrl,
      'updateStory': user.updateStory,
    });
  }

  static Future<QuerySnapshot> searchUsers(String name) {
    Future<QuerySnapshot> users =
        usersRef.where('name', isGreaterThanOrEqualTo: name).getDocuments();
    return users;
  }

  static void createPost(Post post) {
    postsRef.document(post.authorId).collection('userPosts').add({
      'imageUrl': post.imageUrl,
      'caption': post.caption,
      'likeCount': post.likeCount,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
      'authorName': post.authorName,
      'authorImage': post.authorImage,
    });
  }

  static void followUser({String currentUserId, String userId}) {
    // Add user to current user's following collection
    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .setData({});
    // Add current user to user's followers collection
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .setData({});
  }

  static void unfollowUser({String currentUserId, String userId}) {
    // Remove user from current user's following collection
    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // Remove current user from user's followers collection
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isFollowingUser(
      {String currentUserId, String userId}) async {
    DocumentSnapshot followingDoc = await followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get();
    return followingDoc.exists;
  }

  static Future<int> numFollowing(String userId) async {
    QuerySnapshot followingSnapshot = await followingRef
        .document(userId)
        .collection('userFollowing')
        .getDocuments();
    return followingSnapshot.documents.length;
  }

  static Future<int> numFollowers(String userId) async {
    QuerySnapshot followersSnapshot = await followersRef
        .document(userId)
        .collection('userFollowers')
        .getDocuments();
    return followersSnapshot.documents.length;
  }

  static Future<User> getUserWithId(String userId) async {
    DocumentSnapshot userDocSnapshot = await usersRef.document(userId).get();
    if (userDocSnapshot.exists) {
      return User.fromDoc(userDocSnapshot);
    }
    return User();
  }

  static void likePost({String currentUserId, Post post}) {
    DocumentReference postRef = postsRef
        .document(post.authorId)
        .collection('userPosts')
        .document(post.id);
    postRef.get().then((doc) {
      int likeCount = doc.data['likeCount'];
      postRef.updateData({'likeCount': likeCount + 1});
      likesRef
          .document(post.id)
          .collection('postLikes')
          .document(currentUserId)
          .setData({});
      addActivityItem(currentUserId: currentUserId, post: post, comment: null);
    });
  }

  static void unlikePost({String currentUserId, Post post}) {
    DocumentReference postRef = postsRef
        .document(post.authorId)
        .collection('userPosts')
        .document(post.id);
    postRef.get().then((doc) {
      int likeCount = doc.data['likeCount'];
      postRef.updateData({'likeCount': likeCount - 1});
      likesRef
          .document(post.id)
          .collection('postLikes')
          .document(currentUserId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    });
  }

  static Future<bool> didLikePost({String currentUserId, Post post}) async {
    DocumentSnapshot userDoc = await likesRef
        .document(post.id)
        .collection('postLikes')
        .document(currentUserId)
        .get();
    return userDoc.exists;
  }

  static void commentOnPost({String currentUserId, Post post, String comment}) {
    commentsRef.document(post.id).collection('postComments').add({
      'content': comment,
      'authorId': currentUserId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
    addActivityItem(currentUserId: currentUserId, post: post, comment: comment);
  }

  static void addActivityItem(
      {String currentUserId, Post post, String comment}) {
    if (currentUserId != post.authorId) {
      activitiesRef.document(post.authorId).collection('userActivities').add({
        'fromUserId': currentUserId,
        'postId': post.id,
        'postImageUrl': post.imageUrl,
        'comment': comment,
        'timestamp': Timestamp.fromDate(DateTime.now()),
      });
    }
  }

  static Future<List<Activity>> getActivities(String userId) async {
    QuerySnapshot userActivitiesSnapshot = await activitiesRef
        .document(userId)
        .collection('userActivities')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Activity> activity = userActivitiesSnapshot.documents
        .map((doc) => Activity.fromDoc(doc))
        .toList();
    return activity;
  }

  static Future<Post> getUserPost(String userId, String postId) async {
    DocumentSnapshot postDocSnapshot = await postsRef
        .document(userId)
        .collection('userPosts')
        .document(postId)
        .get();
    return Post.fromDoc(postDocSnapshot);
  }

  static Future<List<Post>> getUserPosts(String userId) async {
    QuerySnapshot userPostsSnapshot = await postsRef
        .document(userId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Post> posts =
        userPostsSnapshot.documents.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  static Future<List<Post>> getFeedPosts(String userId) async {
    QuerySnapshot feedSnapshot = await feedsRef
        .document(userId)
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Post> posts =
        feedSnapshot.documents.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  // Query User
  Stream<List<User>> getUser(String userId) {
    return usersRef
        .where('documentId', isEqualTo: userId)
        .orderBy('updateStory', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) => User.fromMap(doc.data, doc.documentID))
            .toList());
  }

  //Get shopping //
  Stream<List<Item>> getXeCo() {
    return newItemRef.where('category', isEqualTo: 'Xe').snapshots().map(
        (snapshot) => snapshot.documents
            .map((doc) => Item.fromMap(doc.data, doc.documentID))
            .toList());
  }

  Stream<List<Item>> getBDS() {
    return newItemRef
        .where('category', isEqualTo: 'Bất Động Sản')
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) => Item.fromMap(doc.data, doc.documentID))
            .toList());
  }

  Stream<List<Item>> getNoiThat() {
    return newItemRef.where('category', isEqualTo: 'Nội Thất').snapshots().map(
        (snapshot) => snapshot.documents
            .map((doc) => Item.fromMap(doc.data, doc.documentID))
            .toList());
  }

  Stream<List<Item>> getThoiTrang() {
    return newItemRef
        .where('category', isEqualTo: 'Thời Trang')
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) => Item.fromMap(doc.data, doc.documentID))
            .toList());
  }

  Stream<List<Item>> getDienTu() {
    return newItemRef.where('category', isEqualTo: 'Điện Tử').snapshots().map(
        (snapshot) => snapshot.documents
            .map((doc) => Item.fromMap(doc.data, doc.documentID))
            .toList());
  }

  Stream<List<Item>> getNewItems() {
    return newItemRef.orderBy('createAt', descending: true).snapshots().map(
        (snapshot) => snapshot.documents
            .map((doc) => Item.fromMap(doc.data, doc.documentID))
            .toList());
  }

  Stream<List<Item>> getNoiBat() {
    return newItemRef.orderBy('count', descending: true).snapshots().map(
        (snapshot) => snapshot.documents
            .map((doc) => Item.fromMap(doc.data, doc.documentID))
            .toList());
  }

  //Get user buying
  Stream<List<Item>> getUserBuying(String idAuthor) {
    return newItemRef
        .where('idAuthor', isEqualTo: idAuthor)
        .orderBy('updateAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) => Item.fromMap(doc.data, doc.documentID))
            .toList());
  }

  //Get user bought
  Stream<List<Item>> getUserBought(String idAuthor) {
    return itemBoughtRef
        .where('idAuthor', isEqualTo: idAuthor)
        .orderBy('updateAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) => Item.fromMap(doc.data, doc.documentID))
            .toList());
  }

  // Add boughts
  Future<void> addBought(Item item) {
    return itemBoughtRef.add(item.toMap());
  }

  // Add items
  Future<void> addItem(Item item) {
    return newItemRef.add(item.toMap());
  }

  //Delete Items
  Future<void> deleteItem(String id) {
    return newItemRef.document(id).delete();
  }

  // updateItem
  Future<void> updateItem(Item item) {
    return newItemRef.document(item.id).updateData(item.toMap());
  }

  //get user following
  Stream<List<User>> getUserFollowing(
    String userId,
  ) {
    return followingRef
        .document(userId)
        .collection('userFollowing')
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) => User.fromMap(doc.data, doc.documentID))
            .toList());
  }

  // get user followers
  Stream<List<User>> getUserFollowers(String userId) {
    return followersRef
        .document(userId)
        .collection('userFollowers')
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) => User.fromMap(doc.data, doc.documentID))
            .toList());
  }

  // chat
  Stream<List<Chat>> getChatMenu(String userId, String authorId) {
    return chatRef
        .document(userId)
        .collection('chatinfo')
        .document(authorId)
        .collection('send')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) => Chat.fromMap(doc.data, doc.documentID))
            .toList());
  }

  // Add chat
  Future<void> addMessengerToCurrentUserId(
      Chat chat, String userId, String authorId) {
    return chatRef
        .document(userId)
        .collection('chatinfo')
        .document(authorId)
        .collection('send')
        .add(chat.toMap());
  }

  // Add chat
  Future<void> addMessengerToUserId(Chat chat, String userId, String authorId) {
    return chatRef
        .document(authorId)
        .collection('chatinfo')
        .document(userId)
        .collection('send')
        .add(chat.toMap());
  }

  //get user following
  Stream<List<User>> menuChat(
    String userId,
  ) {
    return chatRef.document(userId).collection('chatinfo').snapshots().map(
        (snapshot) => snapshot.documents
            .map((doc) => User.fromMap(doc.data, doc.documentID))
            .toList());
  }
}
