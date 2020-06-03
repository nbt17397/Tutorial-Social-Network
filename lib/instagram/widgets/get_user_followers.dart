import 'package:cached_network_image/cached_network_image.dart';
import 'package:doantotnghiep2020/instagram/pages/profile_screen.dart';
import 'package:doantotnghiep2020/models/user_data.dart';
import 'package:doantotnghiep2020/services/database_service.dart';
import 'package:doantotnghiep2020/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:provider/provider.dart';

class GetUserFollowers extends StatefulWidget {
  final User user;
  GetUserFollowers({this.user});
  @override
  _GetUserFollowersState createState() => _GetUserFollowersState();
}

class _GetUserFollowersState extends State<GetUserFollowers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      body: StreamBuilder(
          stream: DatabaseService().getUserFollowers(widget.user.id),
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            if (snapshot.hasError || !snapshot.hasData)
              return CircularProgressIndicator();
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  User users = snapshot.data[index];
                  return _getUserFollowers(users.id);
                });
          }),
    );
  }

  _getUserFollowers(String id) {
    return FutureBuilder(
        future: usersRef.document(id).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || !snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User userfl = User.fromDoc(snapshot.data);
          return Card(
            elevation: 10.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: ListTile(
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: userfl.profileImageUrl.isEmpty
                              ? AssetImage('assets/images/user_placeholder.jpg')
                              : CachedNetworkImageProvider(
                                  userfl.profileImageUrl),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          userfl.name,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.group_add,
                      size: 30.0,
                    )
                  ]),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                            currentUserId:
                                Provider.of<UserData>(context).currentUserId,
                            userId: userfl.id,
                          ))),
            ),
          );
        });
  }
}
