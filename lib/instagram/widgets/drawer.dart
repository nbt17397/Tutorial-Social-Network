import 'package:cached_network_image/cached_network_image.dart';
import 'package:doantotnghiep2020/instagram/screen/infomation_screen.dart';
import 'package:doantotnghiep2020/shopping/screen/shopping_screen.dart';
import 'package:flutter/material.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:doantotnghiep2020/instagram/home_screen.dart';
import 'package:doantotnghiep2020/services/auth_service.dart';
import 'package:doantotnghiep2020/utilities/constants.dart';

class DrawerWidget extends StatefulWidget {
  final String currentUserId;
  final String userId;
  DrawerWidget({this.currentUserId, this.userId});

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: usersRef.document(widget.userId).get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        User user = User.fromDoc(snapshot.data);
        return Scaffold(
          backgroundColor: Color.fromRGBO(0, 0, 0, .1),
          body: ListView(
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: Colors.black54,
                            offset: Offset(4, 4))
                      ]),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: user.profileImageUrl.isEmpty
                        ? AssetImage('assets/images/user_placeholder.jpg')
                        : CachedNetworkImageProvider(user.profileImageUrl),
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      user.name,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text(user.email,
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 18.0,
                    ),
                    Divider(),
                    SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, HomeScreen.id),
                  child: ListTile(
                    title: Text('Trang chủ'),
                    leading: Icon(
                      Icons.home,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShoppingScreen(
                                user: user,
                              ))),
                  child: ListTile(
                    title: Text('Mua bán trực tuyến'),
                    leading: Icon(Icons.shopping_cart, color: Colors.blue),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InfomationScreen(
                                user: user,
                              ))),
                  child: ListTile(
                    title: Text('Thông tin tài khoản'),
                    leading: Icon(Icons.account_circle, color: Colors.blue),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: InkWell(
                  onTap: () {},
                  child: ListTile(
                    title: Text('Cài đặt'),
                    leading: Icon(Icons.settings, color: Colors.blue),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: InkWell(
                  onTap: () => AuthService.logout(),
                  child: ListTile(
                    title: Text('Đăng xuất'),
                    leading: Icon(Icons.exit_to_app, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
