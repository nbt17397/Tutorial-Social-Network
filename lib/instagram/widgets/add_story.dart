import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:doantotnghiep2020/services/database_service.dart';
import 'package:doantotnghiep2020/services/storage_service.dart';

class AddStory extends StatefulWidget {
  final User user;
  AddStory({this.user});

  @override
  _AddStoryState createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  File _storyImage;
  final _formKey = GlobalKey<FormState>();

  _handleImageFromGallery() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _storyImage = imageFile;
      });
    }
  }

  _displayProfileImage() {
    // hàm đoi ảnh
    if (_storyImage == null) {
      if (widget.user.storyImageUrl.isEmpty) {
        return AssetImage('assets/images/banner.jpg');
      } else {
        return CachedNetworkImageProvider(widget.user.storyImageUrl);
        //return null;
      }
    } else {
      // update anh mới
      return FileImage(_storyImage);
    }
  }

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // update
      String _storyImageUrl = '';

      // update ảnh

      if (_storyImage == null) {
        _storyImageUrl = widget.user.storyImageUrl;
      } else {
        _storyImageUrl = await StorageService.uploadStoryProfileImage(
            widget.user.storyImageUrl, _storyImage);
      }

      User user = User(
          id: widget.user.id,
          name: widget.user.name,
          profileImageUrl: widget.user.profileImageUrl,
          bio: widget.user.bio,
          birthday: widget.user.birthday,
          school: widget.user.school,
          address: widget.user.address,
          bannerImageUrl: widget.user.bannerImageUrl,
          phone: widget.user.phone,
          storyImageUrl: _storyImageUrl,
          email: widget.user.email,
          updateStory: Timestamp.fromDate(DateTime.now()));
      //Database update
      DatabaseService.updateUser(user);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng tin'),
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ]),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.grey,
                    backgroundImage: _displayProfileImage(),
                  ),
                ),
                FlatButton(
                  onPressed: _handleImageFromGallery,
                  child: Text(
                    'Thay đổi tin',
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(143, 148, 251, 1),
                          Color.fromRGBO(143, 148, 251, .6),
                        ])),
                    child: Center(
                      child: FlatButton(
                        onPressed: _submit,
                        child: Text(
                          "Chỉnh sửa",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
