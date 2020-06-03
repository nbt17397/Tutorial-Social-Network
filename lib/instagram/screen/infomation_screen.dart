import 'package:doantotnghiep2020/instagram/widgets/get_user_followers.dart';
import 'package:doantotnghiep2020/instagram/widgets/get_user_following.dart';
import 'package:doantotnghiep2020/instagram/widgets/get_user_infomation.dart';
import 'package:flutter/material.dart';
import 'package:doantotnghiep2020/models/user_model.dart';

class InfomationScreen extends StatefulWidget {
  final User user;
  InfomationScreen({this.user});
  @override
  _InfomationScreenState createState() => _InfomationScreenState();
}

class _InfomationScreenState extends State<InfomationScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.user.name),
          bottom: TabBar(
            indicatorColor: Colors.black,
            tabs: <Widget>[
              Tab(
                text: 'Thông tin',
              ),
              Tab(
                text: 'Following',
              ),
              Tab(
                text: 'Followers',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GetUserInfomation(
              user: widget.user,
            ),
            GetUserFollowing(
              user: widget.user,
            ),
            GetUserFollowers(
              user: widget.user,
            ),
          ],
        ),
      ),
    );
  }
}
