import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doantotnghiep2020/models/post_model.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:doantotnghiep2020/instagram/widgets/drawer.dart';
import 'package:doantotnghiep2020/instagram/widgets/post_view.dart';
import 'package:doantotnghiep2020/instagram/widgets/story.dart';
import 'package:doantotnghiep2020/services/database_service.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'feed_screen';
  final String currentUserId;

  FeedScreen({this.currentUserId});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _setupFeed();
  }

  _setupFeed() async {
    List<Post> posts = await DatabaseService.getUserPosts(widget.currentUserId);
    setState(() {
      _posts = posts;
    });
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: CupertinoActionSheet(
            actions: <Widget>[
              Container(
                color: Color.fromRGBO(0, 0, 0, .01),
                height: 300.0,
                child: Story(
                  currentUserId: widget.currentUserId,
                  userId: widget.currentUserId,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tust',
              style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'Billabong',
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'agram',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Billabong',
                fontSize: 35.0,
              ),
            ),
          ],
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.assignment), onPressed: _iosBottomSheet)
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _setupFeed(),
        child: ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (BuildContext context, int index) {
            Post post = _posts[index];
            return FutureBuilder(
              future: DatabaseService.getUserWithId(post.authorId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox.shrink();
                }
                User author = snapshot.data;
                return PostView(
                  currentUserId: widget.currentUserId,
                  post: post,
                  author: author,
                );
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: DrawerWidget(
          currentUserId: widget.currentUserId,
          userId: widget.currentUserId,
        ),
      ),
    );
  }
}
