import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ViewImage extends StatefulWidget {
  final String imageUrl;
  ViewImage({this.imageUrl});
  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Navigator.of(context).pop,
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
                image: CachedNetworkImageProvider(widget.imageUrl),
                fit: BoxFit.fitWidth)),
      ),
    );
  }
}
