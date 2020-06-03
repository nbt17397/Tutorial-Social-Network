import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doantotnghiep2020/instagram/pages/profile_screen.dart';
import 'package:doantotnghiep2020/instagram/screen/comments_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doantotnghiep2020/models/post_model.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:doantotnghiep2020/instagram/widgets/view_image.dart';
import 'package:doantotnghiep2020/services/database_service.dart';

class PostView extends StatefulWidget {
  final String currentUserId;
  final Post post;
  final User author;

  PostView({this.currentUserId, this.post, this.author});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  int _likeCount = 0;
  bool _isLiked = false;
  bool _heartAnim = false;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.likeCount;
    _initPostLiked();
  }

  @override
  void didUpdateWidget(PostView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.likeCount != widget.post.likeCount) {
      _likeCount = widget.post.likeCount;
    }
  }

  _initPostLiked() async {
    bool isLiked = await DatabaseService.didLikePost(
      currentUserId: widget.currentUserId,
      post: widget.post,
    );
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  _likePost() {
    if (_isLiked) {
      // unlike
      DatabaseService.unlikePost(
          currentUserId: widget.currentUserId, post: widget.post);
      setState(() {
        _isLiked = false;
        _likeCount = _likeCount - 1;
      });
    } else {
      // like post
      DatabaseService.likePost(
          currentUserId: widget.currentUserId, post: widget.post);
      setState(() {
        _isLiked = true;
        _heartAnim = true;
        _likeCount = _likeCount + 1;
      });
      Timer(Duration(milliseconds: 350), () {
        setState(() {
          _heartAnim = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                              currentUserId: widget.currentUserId,
                              userId: widget.post.authorId,
                            ))),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              offset: Offset(0, 2),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Colors.grey,
                          backgroundImage: widget.author.profileImageUrl.isEmpty
                              ? AssetImage('assets/images/user_placeholder.jpg')
                              : CachedNetworkImageProvider(
                                  widget.author.profileImageUrl),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.author.name,
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat.yMd()
                                .add_jm()
                                .format(widget.post.timestamp.toDate()),
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
              SizedBox(height: 4.0),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 12.0),
                    child: Icon(Icons.supervisor_account),
                  ),
                  Expanded(
                    child: Text(
                      widget.post.caption,
                      style: TextStyle(fontSize: 16.0),
                      overflow: TextOverflow.visible,
                    ),
                  )
                ],
              ),
              SizedBox(height: 8.0),
              GestureDetector(
                onDoubleTap: _likePost,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewImage(
                              imageUrl: widget.post.imageUrl,
                            ))),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Hero(
                      tag: widget.post.imageUrl,
                      child: Container(
                        height: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                offset: Offset(0, 5),
                                blurRadius: 8.0,
                              ),
                            ],
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    widget.post.imageUrl),
                                fit: BoxFit.fitWidth)),
                      ),
                    ),
                    _heartAnim
                        ? Animator(
                            duration: Duration(milliseconds: 300),
                            tween: Tween(begin: 0.5, end: 1.4),
                            curve: Curves.elasticInOut,
                            builder: (anim) => Transform.scale(
                              scale: anim.value,
                              child: Icon(Icons.favorite,
                                  size: 30.0, color: Colors.red[400]),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
              Divider(color: Colors.black26),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IconButton(
                                icon: _isLiked
                                    ? Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : Icon(Icons.favorite_border),
                                iconSize: 20,
                                onPressed: _likePost),
                            Text(
                              '${_likeCount.toString()} Likes',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CommentsScreen(
                                        post: widget.post,
                                        likeCount: _likeCount,
                                      ))),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.comment,
                                size: 20,
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                'Comment',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.bookmark_border,
                                  color: Colors.black,
                                ),
                                iconSize: 20.0,
                                onPressed: null),
                            Text(
                              'Share',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 3.0,
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
