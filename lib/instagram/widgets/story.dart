import 'package:cached_network_image/cached_network_image.dart';
import 'package:doantotnghiep2020/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:doantotnghiep2020/instagram/widgets/add_story.dart';
import 'package:doantotnghiep2020/instagram/widgets/story_view.dart';
import 'package:doantotnghiep2020/services/database_service.dart';

class Story extends StatefulWidget {
  final String currentUserId;
  final String userId;
  Story({this.currentUserId, this.userId});
  @override
  _StoryState createState() => _StoryState();
}

class _StoryState extends State<Story> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Container(
          height: 300,
          child: _profileStory(widget.currentUserId),
        ),
        Container(
          height: 300,
          child: StreamBuilder(
              stream: DatabaseService().getUserFollowing(widget.currentUserId),
              builder:
                  (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                if (snapshot.hasError || !snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      User users = snapshot.data[index];
                      return _getUserFloowing(users.id);
                    });
              }),
        ),
      ],
    );
  }

  _getUserFloowing(String id) {
    return FutureBuilder(
        future: usersRef.document(id).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User user = User.fromDoc(snapshot.data);
          return Container(
            //height: 180.0,
            color: Colors.white.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
              child: Hero(
                tag: user.name,
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StoryViewImage(
                                  user: user,
                                ))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.0),
                      child: Container(
                          width: 160.0,
                          decoration:
                              BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              offset: Offset(5, 5),
                              blurRadius: 6.0,
                            ),
                          ]),
                          child: Stack(
                            children: <Widget>[
                              GridTile(
                                footer: Container(
                                  height: 40.0,
                                  color: Colors.white60,
                                  child: ListTile(
                                    leading: Text(
                                      user.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                            image: user.storyImageUrl.isEmpty
                                                ? AssetImage(
                                                    'assets/images/user_placeholder.jpg',
                                                  )
                                                : CachedNetworkImageProvider(
                                                    user.storyImageUrl),
                                            fit: BoxFit.cover))),
                              ),
                              Positioned(
                                  left: 10,
                                  top: 15,
                                  child: CircleAvatar(
                                      radius: 22,
                                      foregroundColor: Colors.blue,
                                      child: user.id == widget.currentUserId
                                          ? IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddStory(
                                                            user: user,
                                                          ))))
                                          : CircleAvatar(
                                              radius: 22,
                                              foregroundColor: Colors.red,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      user.profileImageUrl),
                                            )))
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  _profileStory(String currentUserId) {
    return FutureBuilder(
        future: usersRef.document(currentUserId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
          User user = User.fromDoc(snapshot.data);
          return Container(
            //height: 180.0,
            color: Colors.white.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
              child: Hero(
                tag: user.name,
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StoryViewImage(
                                  user: user,
                                ))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.0),
                      child: Container(
                          width: 160.0,
                          decoration:
                              BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              offset: Offset(5, 5),
                              blurRadius: 6.0,
                            ),
                          ]),
                          child: Stack(
                            children: <Widget>[
                              GridTile(
                                footer: Container(
                                  height: 40.0,
                                  color: Colors.white60,
                                  child: ListTile(
                                    leading: Text(
                                      user.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                            image: user.storyImageUrl.isEmpty
                                                ? AssetImage(
                                                    'assets/images/user_placeholder.jpg',
                                                  )
                                                : CachedNetworkImageProvider(
                                                    user.storyImageUrl),
                                            fit: BoxFit.cover))),
                              ),
                              Positioned(
                                  left: 10,
                                  top: 15,
                                  child: CircleAvatar(
                                      radius: 22,
                                      foregroundColor: Colors.blue,
                                      child: user.id == widget.currentUserId
                                          ? IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddStory(
                                                            user: user,
                                                          ))))
                                          : CircleAvatar(
                                              radius: 22,
                                              foregroundColor: Colors.red,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      user.profileImageUrl),
                                            )))
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
