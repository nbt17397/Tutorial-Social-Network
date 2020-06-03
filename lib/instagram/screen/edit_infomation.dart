import 'package:flutter/material.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:doantotnghiep2020/instagram/animation/fade_animation.dart';
import 'package:doantotnghiep2020/services/database_service.dart';

class EditInfoScreen extends StatefulWidget {
  final User user;

  EditInfoScreen({this.user});

  @override
  _EditInfoScreenState createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends State<EditInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _bio = '';
  String _birthday = '';
  String _school = '';
  String _address = '';
  String _phone = '';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
    _birthday = widget.user.birthday;
    _school = widget.user.school;
    _address = widget.user.address;
    _phone = widget.user.phone;
  }

  _submit() async {
    if (_formKey.currentState.validate() && !_isLoading) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });

      User user = User(
          id: widget.user.id,
          name: _name,
          profileImageUrl: widget.user.profileImageUrl,
          bio: _bio,
          birthday: _birthday,
          school: _school,
          address: _address,
          bannerImageUrl: widget.user.bannerImageUrl,
          phone: _phone,
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
                  SizedBox(height: 50),
                  Column(
                    children: <Widget>[
                      FadeAnimation(
                          3.8,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
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
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[100]))),
                                    child: TextFormField(
                                      initialValue: _name,
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.person,
                                          size: 30,
                                        ),
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        labelText: 'Họ và tên',
                                      ),
                                      validator: (input) =>
                                          input.trim().length < 1
                                              ? 'Chưa nhập họ & tên'
                                              : null,
                                      onSaved: (input) => _name = input,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      initialValue: _bio,
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.book,
                                          size: 30,
                                        ),
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        labelText: 'Tiểu sử',
                                      ),
                                      validator: (input) =>
                                          input.trim().length > 150
                                              ? 'Không nhập quá 30 ký tự'
                                              : null,
                                      onSaved: (input) => _bio = input,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      initialValue: _birthday,
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.card_giftcard,
                                          size: 30,
                                        ),
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        labelText: 'Sinh nhật',
                                      ),
                                      validator: (input) =>
                                          input.trim().length > 150
                                              ? 'Không nhập quá 150 ký tự'
                                              : null,
                                      onSaved: (input) => _birthday = input,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      initialValue: _school,
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.school,
                                          size: 30,
                                        ),
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        labelText: 'Trường học',
                                      ),
                                      validator: (input) =>
                                          input.trim().length > 150
                                              ? 'Không nhập quá 150 ký tự'
                                              : null,
                                      onSaved: (input) => _school = input,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      initialValue: _phone,
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.phone_bluetooth_speaker,
                                          size: 30,
                                        ),
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        labelText: 'Điện thoại',
                                      ),
                                      validator: (input) =>
                                          input.trim().length > 150
                                              ? 'Không nhập quá 30 ký tự'
                                              : null,
                                      onSaved: (input) => _phone = input,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      initialValue: _address,
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.card_giftcard,
                                          size: 30,
                                        ),
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        labelText: 'Địa chỉ',
                                      ),
                                      validator: (input) =>
                                          input.trim().length > 150
                                              ? 'Không nhập quá 150 ký tự'
                                              : null,
                                      onSaved: (input) => _address = input,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      Divider(),
                      FadeAnimation(
                          2,
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                      SizedBox(
                        height: 70,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
