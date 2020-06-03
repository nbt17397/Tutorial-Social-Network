import 'package:cached_network_image/cached_network_image.dart';
import 'package:doantotnghiep2020/instagram/screen/chat_room.dart';
import 'package:doantotnghiep2020/instagram/screen/chat_menu.dart';
import 'package:doantotnghiep2020/instagram/screen/comments_screen.dart';
import 'package:doantotnghiep2020/instagram/screen/edit_imageProfile_screen.dart';
import 'package:doantotnghiep2020/instagram/screen/edit_infomation.dart';
import 'package:doantotnghiep2020/instagram/screen/infomation_screen.dart';
import 'package:doantotnghiep2020/instagram/widgets/add_story.dart';
import 'package:doantotnghiep2020/shopping/screen/profile_shopping_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doantotnghiep2020/models/post_model.dart';
import 'package:doantotnghiep2020/models/user_data.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:doantotnghiep2020/instagram/widgets/post_view.dart';
import 'package:doantotnghiep2020/instagram/widgets/story_view.dart';
import 'package:doantotnghiep2020/instagram/widgets/view_image.dart';
import 'package:doantotnghiep2020/services/database_service.dart';
import 'package:doantotnghiep2020/utilities/constants.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final String currentUserId;

  ProfileScreen({this.userId, this.currentUserId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isFollowing = false;
  int _followerCount = 0;
  int _followingCount = 0;
  List<Post> _posts = [];
  int _displayPosts = 0; // 0 -> Grid || 1 -> Column
  User _profileUser;

  // swap follow & unfollow
  @override
  void initState() {
    super.initState();
    _setupIsFollowing();
    _setupFollowers();
    _setipFollowing();
    _setupPosts();
    _setupProfileUser();
  }

  _setupIsFollowing() async {
    bool isFollowingUSer = await DatabaseService.isFollowingUser(
        currentUserId: widget.currentUserId, userId: widget.userId);
    setState(() {
      _isFollowing = isFollowingUSer;
    });
  }

  _setupFollowers() async {
    int userFollowerCount = await DatabaseService.numFollowers(widget.userId);
    setState(() {
      _followerCount = userFollowerCount;
    });
  }

  _setipFollowing() async {
    int userFollowingCount = await DatabaseService.numFollowing(widget.userId);
    setState(() {
      _followingCount = userFollowingCount;
    });
  }

  _setupProfileUser() async {
    User profileUser = await DatabaseService.getUserWithId(widget.userId);
    setState(() {
      _profileUser = profileUser;
    });
  }

  _followOrUnfollow() {
    if (_isFollowing) {
      _unFollowUser();
    } else {
      _followUser();
    }
  }

  _unFollowUser() {
    DatabaseService.unfollowUser(
        currentUserId: widget.currentUserId, userId: widget.userId);
    setState(() {
      _isFollowing = false;
      _followerCount--;
    });
  }

  _followUser() {
    DatabaseService.followUser(
        currentUserId: widget.currentUserId, userId: widget.userId);
    setState(() {
      _isFollowing = true;
      _followerCount++;
    });
  }

  _displayButton(User user) {
    return user.id == Provider.of<UserData>(context).currentUserId
        ? Container(
            width: 333.0,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromRGBO(0, 0, 251, 1),
              Color.fromRGBO(0, 148, 251, .4),
            ])),
            child: FlatButton(
              onPressed: _iosEditSheet,
              textColor: Colors.white,
              child: Text(
                'Chỉnh sửa thông tin',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ),
          )
        : Container(
            width: 333.0,
            decoration: _isFollowing
                ? BoxDecoration(
                    gradient: LinearGradient(colors: [
                    Color.fromRGBO(250, 0, 0, 1),
                    Color.fromRGBO(250, 148, 251, .4),
                  ]))
                : BoxDecoration(
                    gradient: LinearGradient(colors: [
                    Color.fromRGBO(0, 0, 251, 1),
                    Color.fromRGBO(0, 148, 251, .4),
                  ])),
            child: FlatButton(
              onPressed: _followOrUnfollow,
              child: Text(
                _isFollowing ? 'Unfollow' : 'Follow',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
  }

  _setupPosts() async {
    List<Post> posts = await DatabaseService.getUserPosts(widget.userId);
    setState(() {
      _posts = posts;
    });
  }

  _buildTilePost(Post post) {
    return GridTile(
        child: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CommentsScreen(
                          post: post,
                          likeCount: post.likeCount,
                        ))),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(color: Colors.blue, offset: Offset(2, 3))
              ]),
              margin: EdgeInsets.all(2),
              child: Hero(
                  tag: post.id,
                  child: Material(
                    child: InkWell(
                      child: GridTile(
                        footer: Container(
                          color: Colors.white60,
                          height: 40,
                          child: ListTile(
                            leading: Text(
                              DateFormat.Md()
                                  .add_jm()
                                  .format(post.timestamp.toDate()),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        child: Image(
                          image: CachedNetworkImageProvider(post.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )),
            )));
  }

  _buildDisplayPosts() {
    if (_displayPosts == 0) {
      // Gird
      List<GridTile> tiles = [];
      _posts.forEach(
        (post) => tiles.add(_buildTilePost(post)),
      );
      return GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          mainAxisSpacing: 2.0,
          crossAxisSpacing: 2.0,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: tiles);
    } else {
      //column
      List<PostView> postViews = [];
      _posts.forEach((post) {
        postViews.add(PostView(
          currentUserId: widget.currentUserId,
          post: post,
          author: _profileUser,
        ));
      });
      return Column(
        children: postViews,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: usersRef.document(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          User user = User.fromDoc(snapshot.data);

          return Stack(
            children: <Widget>[
              Container(
                height: 240.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: user.bannerImageUrl.isEmpty
                            ? AssetImage('assets/images/banner.jpg')
                            : CachedNetworkImageProvider(user.bannerImageUrl),
                        fit: BoxFit.cover)),
              ),
              ListView(
                children: <Widget>[
                  _buildProfileInfo(user),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildToggleButtons(),
                  Divider(),
                  _buildDisplayPosts(),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.grid_on),
              iconSize: 30.0,
              color: _displayPosts == 0
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300],
              onPressed: () => setState(() {
                _displayPosts = 0;
              }),
            ),
            Text(
              'Ảnh',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.library_books),
              iconSize: 30.0,
              color: _displayPosts == 1
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300],
              onPressed: () => setState(() {
                _displayPosts = 1;
              }),
            ),
            Text(
              'Bài đăng',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }

  _buildProfileInfo(User user) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      height: 259.0,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 40.0, left: 40.0, right: 40.0, bottom: 10.0),
            child: Material(
              shadowColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 5.0,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  user.id == Provider.of<UserData>(context).currentUserId
                      ? SizedBox(
                          height: 17,
                        )
                      : GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InfomationScreen(
                                        user: user,
                                      ))),
                          child: Text(
                            'Xem thông tin cá nhân',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )),
                  SizedBox(
                    height: 0.0,
                  ),
                  user.id == Provider.of<UserData>(context).currentUserId
                      ? Container(
                          height: 40.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    _posts.length.toString(),
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text("Posts".toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    _followerCount.toString(),
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text("Followers".toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    _followingCount.toString(),
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text("Following".toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: 40.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    _posts.length.toString(),
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text("Posts".toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    _followerCount.toString(),
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text("Followers".toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    _followingCount.toString(),
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text("Following".toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(
                    height: 17.0,
                  ),
                  _displayButton(user),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                  elevation: 5.0,
                  shape: CircleBorder(),
                  child: GestureDetector(
                    onTap: _iosBottomSheet,
                    child: CircleAvatar(
                      radius: 44.0,
                      backgroundImage: user.profileImageUrl.isEmpty
                          ? AssetImage('assets/images/user_placeholder.jpg')
                          : CachedNetworkImageProvider(user.profileImageUrl),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
            future: usersRef.document(widget.userId).get(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              User user = User.fromDoc(snapshot.data);
              return CupertinoActionSheet(
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: Text(
                      'Xem ảnh đại diện',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewImage(
                                  imageUrl: user.profileImageUrl,
                                ))),
                  ),
                  CupertinoActionSheetAction(
                    child: Text('Xem tin',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StoryViewImage(
                                  user: user,
                                ))),
                  ),
                  CupertinoActionSheetAction(
                    child: Text('Sản phẩm đang bán',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShoppingProfile(
                                  user: user,
                                ))),
                  ),
                  user.id == Provider.of<UserData>(context).currentUserId
                      ? CupertinoActionSheetAction(
                          child: Text('Messenger',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MenuChat(
                                        currentUserId: user.id,
                                      ))),
                        )
                      : CupertinoActionSheetAction(
                          child: Text('Tin nhắn',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatRoom(
                                        user: user,
                                      ))),
                        ),
                ],
              );
            });
      },
    );
  }

  _iosEditSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
            future: usersRef.document(widget.userId).get(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              User user = User.fromDoc(snapshot.data);
              return CupertinoActionSheet(
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: Text(
                      'Upload Story',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddStory(
                          user: user,
                        ),
                      ),
                    ),
                  ),
                  CupertinoActionSheetAction(
                    child: Text(
                      'Thay đổi ảnh',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileScreen(
                          user: user,
                        ),
                      ),
                    ),
                  ),
                  CupertinoActionSheetAction(
                    child: Text(
                      'Chỉnh sửa thông tin',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditInfoScreen(
                          user: user,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            });
      },
    );
  }
}
