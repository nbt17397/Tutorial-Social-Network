import 'package:cached_network_image/cached_network_image.dart';
import 'package:doantotnghiep2020/shopping/widget/circular_clipper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doantotnghiep2020/models/comment_model.dart';
import 'package:doantotnghiep2020/models/post_model.dart';
import 'package:doantotnghiep2020/models/user_data.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:doantotnghiep2020/services/database_service.dart';
import 'package:doantotnghiep2020/utilities/constants.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final Post post;
  final int likeCount;

  CommentsScreen({this.post, this.likeCount});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;

  _buildComment(Comment comment) {
    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: FutureBuilder(
        future: DatabaseService.getUserWithId(comment.authorId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return SizedBox.shrink();
          }
          User author = snapshot.data;
          return ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.grey,
              backgroundImage: author.profileImageUrl.isEmpty
                  ? AssetImage('assets/images/user_placeholder.jpg')
                  : CachedNetworkImageProvider(author.profileImageUrl),
            ),
            title: Text(
              author.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8.0),
                Text(
                  comment.content,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 6.0),
                Text(
                  DateFormat.yMd().add_jm().format(comment.timestamp.toDate()),
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
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
                controller: _commentController,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (comment) {
                  setState(() {
                    _isCommenting = comment.length > 0;
                  });
                },
                decoration:
                    InputDecoration.collapsed(hintText: 'Viết bình luận...'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                color: Colors.blue,
                onPressed: () {
                  if (_isCommenting) {
                    DatabaseService.commentOnPost(
                      currentUserId: currentUserId,
                      post: widget.post,
                      comment: _commentController.text,
                    );
                    _commentController.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                transform:
                    Matrix4.translationValues(0.0, -50.0, 0.0), // tai thỏ
                child: Hero(
                  tag: widget.post.imageUrl,
                  child: ClipShadowPath(
                      clipper: CircularClipper(),
                      shadow: Shadow(blurRadius: 20.0),
                      child: Image.network(
                        widget.post.imageUrl,
                        height: 400.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        iconSize: 30.0,
                        color: Colors.black,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                              DateFormat.yMd().add_jm()
                                  .format(widget.post.timestamp.toDate()),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            widget.post.likeCount.toString() + ' like',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ]),
              ),
              Positioned.fill(
                bottom: 10.0,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          CachedNetworkImageProvider(widget.post.authorImage),
                    )),
              ),
            ],
          ),
          Divider(),
          StreamBuilder(
            stream: commentsRef
                .document(widget.post.id)
                .collection('postComments')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    Comment comment =
                        Comment.fromDoc(snapshot.data.documents[index]);
                    return _buildComment(comment);
                  },
                ),
              );
            },
          ),
          Divider(height: 1.0),
          _buildCommentTF(),
        ],
      ),
    );
  }
}
