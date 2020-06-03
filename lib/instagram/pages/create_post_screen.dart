import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:doantotnghiep2020/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:doantotnghiep2020/models/post_model.dart';
import 'package:doantotnghiep2020/models/user_data.dart';
import 'package:doantotnghiep2020/instagram/animation/fade_animation.dart';
import 'package:doantotnghiep2020/instagram/home_screen.dart';
import 'package:doantotnghiep2020/services/database_service.dart';
import 'package:doantotnghiep2020/services/storage_service.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  final String currentUserId;
  CreatePostScreen({this.currentUserId});
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File _image;
  TextEditingController _captionController = TextEditingController();
  String _caption = '';
  bool _isLoading = false;

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog();
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('Thêm ảnh'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('Máy ảnh'),
              onPressed: () => _handleImage(ImageSource.camera),
            ),
            CupertinoActionSheetAction(
              child: Text('Chọn từ thư viện'),
              onPressed: () => _handleImage(ImageSource.gallery),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Huỷ'),
            onPressed: () => Navigator.pop(context),
          ),
        );
      },
    );
  }

  _androidDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Thêm ảnh'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Máy ảnh'),
              onPressed: () => _handleImage(ImageSource.camera),
            ),
            SimpleDialogOption(
              child: Text('Chọn từ thư viện'),
              onPressed: () => _handleImage(ImageSource.gallery),
            ),
            SimpleDialogOption(
              child: Text(
                'Huỷ',
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  _handleImage(ImageSource source) async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile != null) {
      imageFile = await _cropImage(imageFile);
      setState(() {
        _image = imageFile;
      });
    }
  }

  _cropImage(File imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    return croppedImage;
  }

  _submit(User user) async {
    if (!_isLoading && _image != null && _caption.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      // Create post
      String imageUrl = await StorageService.uploadPost(_image);
      Post post = Post(
        imageUrl: imageUrl,
        caption: _caption,
        likeCount: 0,
        authorId: Provider.of<UserData>(context).currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now()),
        authorImage: user.profileImageUrl,
        authorName: user.name,
      );
      DatabaseService.createPost(post);

      // Reset data
      _captionController.clear();
      //Navigator.pop(context);

      setState(() {
        _caption = '';
        _image = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: usersRef.document(widget.currentUserId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User user = User.fromDoc(snapshot.data);
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: Text(
                'Tạo bài viết',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Container(
                    height: height,
                    child: Column(
                      children: <Widget>[
                        _isLoading
                            ? Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.blue[200],
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.blue),
                                ),
                              )
                            : SizedBox.shrink(),
                        GestureDetector(
                          onTap: _showSelectImageDialog,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white12,
                                      offset: Offset(5, 5),
                                      blurRadius: 30.0,
                                    ),
                                  ],
                                ),
                                height: width,
                                width: width,
                                child: _image == null
                                    ? Icon(
                                        Icons.add_a_photo,
                                        color: Colors.blue,
                                        size: 150.0,
                                      )
                                    : Image(
                                        image: FileImage(_image),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Column(
                            children: <Widget>[
                              FadeAnimation(
                                  2.0,
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.blue[100],
                                              blurRadius: 20.0,
                                              offset: Offset(0, 10))
                                        ]),
                                    child: Form(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.all(8.0),
                                            child: TextField(
                                              controller: _captionController,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[400]),
                                                labelText:
                                                    'Hãy nói gì về bức ảnh này',
                                              ),
                                              onChanged: (input) =>
                                                  _caption = input,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              FadeAnimation(
                                  4,
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(colors: [
                                          Color.fromRGBO(0, 0, 251, 1),
                                          Color.fromRGBO(0, 148, 251, .4),
                                        ])),
                                    child: Center(
                                      child: FlatButton(
                                        onPressed: () {
                                          _submit(user);
                                        },
                                        child: Text(
                                          "Đăng ảnh",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
