import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String profileImageUrl;
  final String email;
  final String bio;
  final String birthday;
  final String school;
  final String address;
  final String bannerImageUrl;
  final String phone;
  final String storyImageUrl;
  final Timestamp updateStory;

  User(
      {this.id,
      this.name,
      this.profileImageUrl,
      this.email,
      this.bio,
      this.birthday,
      this.school,
      this.address,
      this.bannerImageUrl,
      this.phone,
      this.updateStory,
      this.storyImageUrl});

  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      name: doc['name'],
      profileImageUrl: doc['profileImageUrl'],
      bannerImageUrl: doc['bannerImageUrl'] ?? '',
      email: doc['email'],
      bio: doc['bio'] ?? '',
      birthday: doc['birthday'] ?? '',
      school: doc['school'] ?? '',
      address: doc['address'] ?? '',
      phone: doc['phone'] ?? '',
      storyImageUrl: doc['storyImageUrl'] ?? '',
      updateStory: doc['updateStory'] ,
    );
  }

  User.fromMap(Map<String, dynamic> data, String id)
      : id = id,
        name = data['name'],
        profileImageUrl = data['profileImageUrl'],
        email = data['email'],
        bio = data['bio'],
        birthday = data['birthday'],
        school = data['school'],
        address = data['address'],
        bannerImageUrl = data['bannerImageUrl'],
        phone = data['phone'],
        storyImageUrl = data['storyImageUrl'],
        updateStory = data['updateStory'];
}
