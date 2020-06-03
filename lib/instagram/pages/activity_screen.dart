import 'package:cached_network_image/cached_network_image.dart';
import 'package:doantotnghiep2020/instagram/animation/fade_animation.dart';
import 'package:doantotnghiep2020/instagram/screen/comments_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doantotnghiep2020/models/activity_model.dart';
import 'package:doantotnghiep2020/models/post_model.dart';
import 'package:doantotnghiep2020/models/user_data.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:doantotnghiep2020/services/database_service.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  final String currentUserId;

  ActivityScreen({this.currentUserId});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<Activity> _activies = [];
  String _isReading = '1';

  @override
  void initState() {
    super.initState();
    _setupActivies();
  }

  _setupActivies() async {
    List<Activity> activities =
        await DatabaseService.getActivities(widget.currentUserId);
    if (mounted) {
      setState(() {
        _activies = activities;
      });
    }
  }

  _buildActivity(Activity activity) {
    return FadeAnimation(
        1.0,
        Container(
          height: 85.0,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(offset: Offset(3, 3), color: Colors.blue, blurRadius: 5.0)
          ]),
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 5.0),
          child: Card(
            color: _isReading == '1' ? Colors.blue[200] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: FutureBuilder(
              future: DatabaseService.getUserWithId(activity.fromUserId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox.shrink();
                }
                User user = snapshot.data;
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: user.profileImageUrl.isEmpty
                        ? AssetImage('assets/images/user_placeholder.jpg')
                        : CachedNetworkImageProvider(user.profileImageUrl),
                  ),
                  title: activity.comment != null
                      ? Row(
                          children: <Widget>[
                            Text(
                              '${user.name} ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                                child: Text(
                              'đã bình luận: "${activity.comment}"',
                              overflow: TextOverflow.ellipsis,
                            ))
                          ],
                        )
                      : Row(
                          children: <Widget>[
                            Text(
                              '${user.name} ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                                child: Text(
                              'đã thích bài viết',
                              overflow: TextOverflow.ellipsis,
                            )),
                          ],
                        ),
                  subtitle: Text(
                    DateFormat.yMd()
                        .add_jm()
                        .format(activity.timestamp.toDate()),
                  ),
                  trailing: CachedNetworkImage(
                    imageUrl: activity.postImageUrl,
                    height: 70.0,
                    width: 70.0,
                    fit: BoxFit.cover,
                  ),
                  onTap: () async {
                    String currentUserId =
                        Provider.of<UserData>(context).currentUserId;
                    Post post = await DatabaseService.getUserPost(
                      currentUserId,
                      activity.postId,
                    );
                    setState(() {
                      _isReading = '2';
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CommentsScreen(
                          post: post,
                          likeCount: post.likeCount,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _setupActivies(),
      child: ListView.builder(
          itemCount: _activies.length,
          itemBuilder: (BuildContext context, int index) {
            Activity activity = _activies[index];
            return _buildActivity(activity);
          }),
    );
  }
}
