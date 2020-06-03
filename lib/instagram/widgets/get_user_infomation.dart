import 'package:flutter/material.dart';
import 'package:doantotnghiep2020/models/user_model.dart';

class GetUserInfomation extends StatefulWidget {
  final User user;
  GetUserInfomation({this.user});
  @override
  _GetUserInfomationState createState() => _GetUserInfomationState();
}

class _GetUserInfomationState extends State<GetUserInfomation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          widget.user.email.isNotEmpty
              ? Card(
                  elevation: 10,
                  margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text(widget.user.email),
                      leading: Icon(
                        Icons.email,
                        color: Colors.blue,
                        size: 30,
                      ),
                      subtitle: Text('Email'),
                    ),
                  ),
                )
              : SizedBox(
                  height: 0.0,
                ),
          widget.user.birthday.isNotEmpty
              ? Card(
                  elevation: 10,
                  margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text(widget.user.birthday),
                      leading: Icon(
                        Icons.card_giftcard,
                        color: Colors.blue,
                        size: 30,
                      ),
                      subtitle: Text('Ngày sinh'),
                    ),
                  ),
                )
              : SizedBox(
                  height: 0.0,
                ),
          widget.user.phone.isNotEmpty
              ? Card(
                  elevation: 10,
                  margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text(widget.user.phone),
                      leading: Icon(
                        Icons.phone_bluetooth_speaker,
                        color: Colors.blue,
                        size: 30,
                      ),
                      subtitle: Text('Phone'),
                    ),
                  ),
                )
              : SizedBox(
                  height: 0.0,
                ),
          widget.user.address.isNotEmpty
              ? Card(
                  elevation: 10,
                  margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text(widget.user.address),
                      leading: Icon(
                        Icons.map,
                        color: Colors.blue,
                        size: 30,
                      ),
                      subtitle: Text('Địa chỉ'),
                    ),
                  ),
                )
              : SizedBox(
                  height: 0.0,
                ),
          widget.user.school.isNotEmpty
              ? Card(
                  elevation: 10,
                  margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text(widget.user.phone),
                      leading: Icon(
                        Icons.school,
                        color: Colors.blue,
                        size: 30,
                      ),
                      subtitle: Text('Trường học'),
                    ),
                  ),
                )
              : SizedBox(
                  height: 0.0,
                ),
          widget.user.bio.isNotEmpty
              ? Card(
                  elevation: 10,
                  margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text(widget.user.bio),
                      leading: Icon(
                        Icons.book,
                        color: Colors.blue,
                        size: 30,
                      ),
                      subtitle: Text('Tiểu sử'),
                    ),
                  ),
                )
              : SizedBox(
                  height: 0.0,
                ),
        ],
      ),
    );
  }
}
