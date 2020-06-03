import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:doantotnghiep2020/instagram/animation/fade_animation.dart';
import 'package:doantotnghiep2020/services/database_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doantotnghiep2020/services/storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File _profileImage;
  File _bannerImage;

  bool _isLoading = false;

  _handleImageFromGallery() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _profileImage = imageFile;
      });
    }
  }

  //banner
  _handleImageFromGalleryBanner() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _bannerImage = imageFile;
      });
    }
  }

  _displayProfileImage() {
    // hàm đoi ảnh
    if (_profileImage == null) {
      if (widget.user.profileImageUrl.isEmpty) {
        return AssetImage('assets/images/user_placeholder.jpg');
      } else {
        return CachedNetworkImageProvider(widget.user.profileImageUrl);
        //return null;
      }
    } else {
      // update anh mới
      return FileImage(_profileImage);
    }
  }

  //banner
  _displayProfileImageBanner() {
    // hàm đoi ảnh
    if (_bannerImage == null) {
      if (widget.user.bannerImageUrl.isEmpty) {
        return AssetImage('assets/images/banner.jpg');
      } else {
        return CachedNetworkImageProvider(widget.user.bannerImageUrl);
        //return null;
      }
    } else {
      // update anh mới
      return FileImage(_bannerImage);
    }
  }

  _submit() async {
    if (_formKey.currentState.validate() && !_isLoading) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });

      // update
      String _profileImageUrl = '';
      String _bannerImageUrl = '';

      // update ảnh

      if (_profileImage == null) {
        _profileImageUrl = widget.user.profileImageUrl;
      } else {
        _profileImageUrl = await StorageService.uploadUserProfileImage(
            widget.user.profileImageUrl, _profileImage);
      }

      // update banner

      if (_bannerImage == null) {
        _bannerImageUrl = widget.user.bannerImageUrl;
      } else {
        _bannerImageUrl = await StorageService.uploadBannerProfileImage(
            widget.user.bannerImageUrl, _bannerImage);
      }

      User user = User(
          id: widget.user.id,
          name: widget.user.name,
          profileImageUrl: _profileImageUrl,
          bio: widget.user.bio,
          birthday: widget.user.birthday,
          school: widget.user.school,
          address: widget.user.address,
          bannerImageUrl: _bannerImageUrl,
          phone: widget.user.phone,
          email: widget.user.email,
          updateStory: widget.user.updateStory,
          storyImageUrl: widget.user.storyImageUrl);
      //Database update
      DatabaseService.updateUser(user);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Text(
          'Chỉnh sửa thông tin',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            _isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  )
                : SizedBox.shrink(),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Container(
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, boxShadow: [
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
                      'Thay đổi ảnh đại diện',
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 16),
                    ),
                  ),
                  Container(
                    height: 240.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: _displayProfileImageBanner())),
                  ),
                  FlatButton(
                    onPressed: _handleImageFromGalleryBanner,
                    child: Text(
                      'Thay đổi ảnh bìa',
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 16),
                    ),
                  ),
                  Divider(),
                  FadeAnimation(
                      2,
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
