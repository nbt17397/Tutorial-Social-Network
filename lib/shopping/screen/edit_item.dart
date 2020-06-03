import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep2020/models/item_model.dart';
import 'package:doantotnghiep2020/services/database_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class EditItem extends StatefulWidget {
  final Item item;
  EditItem({this.item});
  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
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
    _nameController = TextEditingController(text: widget.item.name);
    _moneyController = TextEditingController(text: widget.item.money);
    _descController = TextEditingController(text: widget.item.desc);
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
        title: Text('Add item'),
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
                  child: selectedImage == null
                      ? Container(
                          child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          height: 190,
                          width: MediaQuery.of(context).size.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              widget.item.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ))
                      : Container(
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
                            return "Name cannot be empty";
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Name', border: OutlineInputBorder()),
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
                          if (value.length < 4) return "Money cannot be empty";
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Money', border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        focusNode: _moneyNode,
                        controller: _descController,
                        maxLines: 3,
                        decoration: InputDecoration(
                            labelText: 'Desc', border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
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
          Item itemedit = Item(
            id: widget.item.id,
            addressAuthor: widget.item.addressAuthor,
            category: dropdownCategory,
            count: widget.item.count,
            createAt: widget.item.createAt,
            desc: _descController.text,
            name: _nameController.text,
            money: _moneyController.text,
            idAuthor: widget.item.idAuthor,
            imageAuthor: widget.item.imageAuthor,
            imageUrl: downloadUrl,
            nameAuthor: widget.item.nameAuthor,
            phoneAuthor: widget.item.phoneAuthor,
            updateAt: Timestamp.fromDate(DateTime.now()),
          );
          await DatabaseService().updateItem(itemedit);
        }
        if (selectedImage == null) {
          Item itemedit = Item(
            id: widget.item.id,
            addressAuthor: widget.item.addressAuthor,
            category: dropdownCategory,
            count: widget.item.count,
            createAt: widget.item.createAt,
            desc: _descController.text,
            name: _nameController.text,
            money: _moneyController.text,
            idAuthor: widget.item.idAuthor,
            imageAuthor: widget.item.imageAuthor,
            imageUrl: widget.item.imageUrl,
            nameAuthor: widget.item.nameAuthor,
            phoneAuthor: widget.item.phoneAuthor,
            updateAt: Timestamp.fromDate(DateTime.now()),
          );
          await DatabaseService().updateItem(itemedit);
        }
        Navigator.pop(context);
      } catch (e) {
        print(e);
      }
    }
  }
}
