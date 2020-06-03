import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep2020/models/item_model.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:doantotnghiep2020/services/database_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddItem extends StatefulWidget {
  final User user;
  AddItem({this.user});
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  File selectedImage;
  FocusNode _moneyNode;
  TextEditingController _nameController;
  TextEditingController _moneyController;
  TextEditingController _descController;
  String dropdownCategory = 'Điện tử';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: '');
    _moneyController = TextEditingController(text: '');
    _descController = TextEditingController(text: '');
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm sản phẩm'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.file_upload),
              onPressed: () {
                _upLoadItem();
              })
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
            autovalidate: true,
            key: _key,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Container(
                    child: selectedImage != null
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            height: 190,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                selectedImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            height: 190,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(15)),
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.black45,
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: <Widget>[
                      DropdownButton<String>(
                        isExpanded: true,
                        value: dropdownCategory,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.blueAccent),
                        underline: Container(
                          height: 2,
                          color: Colors.blueAccent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownCategory = newValue;
                          });
                        },
                        items: <String>[
                          'Điện tử',
                          'Nội Thất',
                          'Thời Trang',
                          'Xe',
                          'Bất Động Sản'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Center(child: Text(value)),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_moneyNode);
                        },
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.length < 5)
                            return "Sản phẩm phải lớn hơn 5 kí tự";
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Tên sản phẩm',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_moneyNode);
                        },
                        controller: _moneyController,
                        validator: (value) {
                          if (value.length < 4)
                            return "Giá không đúng dịnh dạng";
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Giá', border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        focusNode: _moneyNode,
                        controller: _descController,
                        maxLines: 3,
                        decoration: InputDecoration(
                            labelText: 'Mô tả', border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton.icon(
                          textColor: Colors.white,
                          elevation: 7.0,
                          color: Colors.blue,
                          onPressed: () {
                            _upLoadItem();
                          },
                          icon: Icon(Icons.file_upload),
                          label: Text('Đăng bán'))
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  _upLoadItem() async {
    if (_key.currentState.validate()) {
      try {
        if (selectedImage != null) {
          StorageReference firebaseStorageRef = FirebaseStorage.instance
              .ref()
              .child("itemsImage")
              .child('${randomAlphaNumeric(9)}.jpg');
          final StorageUploadTask task =
              firebaseStorageRef.putFile(selectedImage);

          var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
          await DatabaseService().addItem(Item(
            addressAuthor: widget.user.address,
            //category: _categoryController.text,
            category: dropdownCategory,
            count: 0,
            createAt: Timestamp.fromDate(DateTime.now()),
            updateAt: Timestamp.fromDate(DateTime.now()),
            desc: _descController.text,
            idAuthor: widget.user.id,
            imageAuthor: widget.user.profileImageUrl,
            imageUrl: downloadUrl,
            money: _moneyController.text,
            name: _nameController.text,
            nameAuthor: widget.user.name,
          ));
        }
        Navigator.pop(context);
      } catch (e) {
        print(e);
      }
    }
  }
}
