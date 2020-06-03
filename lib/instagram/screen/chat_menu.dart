import 'package:cached_network_image/cached_network_image.dart';
import 'package:doantotnghiep2020/instagram/screen/chat_room.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:doantotnghiep2020/services/database_service.dart';
import 'package:doantotnghiep2020/utilities/constants.dart';
import 'package:flutter/material.dart';

class MenuChat extends StatefulWidget {
  final String currentUserId;

  const MenuChat({Key key, this.currentUserId}) : super(key: key);
  @override
  _MenuChatState createState() => _MenuChatState();
}

class _MenuChatState extends State<MenuChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: Colors.white,
        title: Text(
          'Menu chat',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 60.0,
              child: StreamBuilder(
                  stream:
                      DatabaseService().getUserFollowing(widget.currentUserId),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<User>> snapshot) {
                    if (snapshot.hasError || !snapshot.hasData)
                      return CircularProgressIndicator();
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          User users = snapshot.data[index];
                          return _getUserFollowing(users.id);
                        });
                  }),
            ),
          ),
          Divider(),
          StreamBuilder(
              stream: DatabaseService().getUserFollowing(widget.currentUserId),
              builder:
                  (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                if (snapshot.hasError || !snapshot.hasData)
                  return CircularProgressIndicator();
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      User user = snapshot.data[index];
                      return _buildChatWithUserId(user.id);
                    });
              }),
        ],
      ),
    );
  }

  _buildChatWithUserId(String userId) {
    return FutureBuilder(
        future: usersRef.document(userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || !snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User userfl = User.fromDoc(snapshot.data);
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: userfl.profileImageUrl.isEmpty
                    ? AssetImage('assets/images/user_placeholder.jpg')
                    : CachedNetworkImageProvider(userfl.profileImageUrl),
              ),
              title: Text(
                userfl.name,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(''),
              trailing: Icon(
                Icons.volume_mute,
                size: 30.0,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ChatRoom(
                              user: userfl,
                            )));
              },
            ),
          );
        });
  }

  _getUserFollowing(String userId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: FutureBuilder(
          future: usersRef.document(userId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData || !snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            User userfl = User.fromDoc(snapshot.data);
            return CircleAvatar(
              backgroundImage: userfl.profileImageUrl.isEmpty
                  ? AssetImage('assets/images/user_placeholder.jpg')
                  : CachedNetworkImageProvider(userfl.profileImageUrl),
              radius: 30.0,
            );
          }),
    );
  }
}
