import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:story_view/story_controller.dart';
import 'package:story_view/story_view.dart';

class StoryViewImage extends StatefulWidget {
  final User user;
  StoryViewImage({this.user});
  @override
  _StoryViewImageState createState() => _StoryViewImageState();
}

class _StoryViewImageState extends State<StoryViewImage> {
  @override
  Widget build(BuildContext context) {
    final controller = StoryController();
    final List<StoryItem> storyItems = [
      StoryItem.pageImage(
        CachedNetworkImageProvider(widget.user.storyImageUrl),
        imageFit: BoxFit.fitWidth,
      ),
    ];
    return Stack(
      children: <Widget>[
        StoryView(
          storyItems,
          controller: controller,
          inline: true,
          repeat: true,
        ),
        Positioned(
            top: 60,
            left: 20,
            child: Text(
              DateFormat()
                  .add_yMd()
                  .add_jm()
                  .format(widget.user.updateStory.toDate()),
              style: TextStyle(fontSize: 14, color: Colors.white),
            ))
      ],
    );
  }
}
