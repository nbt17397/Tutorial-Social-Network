import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep2020/models/chat_model.dart';
import 'package:doantotnghiep2020/models/user_data.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:doantotnghiep2020/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  final User user;
  ChatRoom({this.user});
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messengerController = TextEditingController();
  bool _isCommenting = false;

  @override
  Widget build(BuildContext context) {
    final currentUserId = Provider.of<UserData>(context).currentUserId;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3.0,
        title: Text(
          'Messengers',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: StreamBuilder(
                stream: DatabaseService()
                    .getChatMenu(currentUserId, widget.user.id),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Chat>> snapshot) {
                  if (snapshot.hasError || !snapshot.hasData)
                    return CircularProgressIndicator();
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Chat chat = snapshot.data[index];
                        return _buildMessenger(chat);
                      });
                }),
          ),
          _buildCommentTF(),
        ],
      ),
    );
  }

  _buildMessenger(Chat chat) {
    return widget.user.id == chat.authorId
        ? Container(
            margin: EdgeInsets.all(10.0),
            child: FutureBuilder(
              future: DatabaseService.getUserWithId(chat.authorId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox.shrink();
                }
                User author = snapshot.data;
                return Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: author.profileImageUrl.isEmpty
                          ? AssetImage('assets/images/user_placeholder.jpg')
                          : CachedNetworkImageProvider(author.profileImageUrl),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    RaisedButton(
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        color: Colors.white70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 6.0),
                            Text(
                              chat.content,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 6.0),
                            Text(
                              DateFormat.yMd()
                                  .add_jm()
                                  .format(chat.timestamp.toDate()),
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ))
                  ],
                );
              },
            ),
          )
        : Container(
            margin: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width / 3, 10, 10, 10),
            child: FutureBuilder(
              future: DatabaseService.getUserWithId(chat.authorId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox.shrink();
                }
                User author = snapshot.data;
                return Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: author.profileImageUrl.isEmpty
                          ? AssetImage('assets/images/user_placeholder.jpg')
                          : CachedNetworkImageProvider(author.profileImageUrl),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    RaisedButton(
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        color: Colors.lightBlue,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 6.0),
                            Text(
                              chat.content,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            SizedBox(height: 6.0),
                            Text(
                              DateFormat.yMd()
                                  .add_jm()
                                  .format(chat.timestamp.toDate()),
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ],
                        ))
                  ],
                );
              },
            ),
          );
  }

  _buildCommentTF() {
    final currentUserId = Provider.of<UserData>(context).currentUserId;
    return IconTheme(
      data: IconThemeData(
        color: _isCommenting
            ? Theme.of(context).accentColor
            : Theme.of(context).disabledColor,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 10.0),
            Expanded(
              child: TextField(
                controller: _messengerController,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (comment) {
                  setState(() {
                    _isCommenting = comment.length > 0 || comment.length < 40;
                  });
                },
                decoration:
                    InputDecoration.collapsed(hintText: 'Soạn tin nhắn...'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                color: Colors.blue,
                onPressed: () {
                  if (_isCommenting) {
                    DatabaseService().addMessengerToCurrentUserId(
                        Chat(
                            authorId: currentUserId,
                            timestamp: Timestamp.fromDate(DateTime.now()),
                            content: _messengerController.text),
                        currentUserId,
                        widget.user.id);
                    DatabaseService().addMessengerToUserId(
                      Chat(
                          authorId: currentUserId,
                          timestamp: Timestamp.fromDate(DateTime.now()),
                          content: _messengerController.text),
                      currentUserId,
                      widget.user.id,
                    );

                    _messengerController.clear();
                    setState(() {
                      _isCommenting = false;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
