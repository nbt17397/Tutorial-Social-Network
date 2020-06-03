import 'package:cached_network_image/cached_network_image.dart';
import 'package:doantotnghiep2020/instagram/pages/profile_screen.dart';
import 'package:doantotnghiep2020/models/item_model.dart';
import 'package:doantotnghiep2020/models/user_data.dart';
import 'package:doantotnghiep2020/shopping/widget/circular_clipper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ItemDetail extends StatefulWidget {
  final Item item;
  ItemDetail({this.item});
  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                transform:
                    Matrix4.translationValues(0.0, -50.0, 0.0), // tai thỏ
                child: Hero(
                  tag: widget.item.imageUrl,
                  child: ClipShadowPath(
                      clipper: CircularClipper(),
                      shadow: Shadow(blurRadius: 20.0),
                      child: Image.network(
                        widget.item.imageUrl,
                        height: 400.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              Row(
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
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {},
                    iconSize: 30.0,
                    color: Colors.black,
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 40.0, right: 40.0, top: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Giá : ' + widget.item.money.toString(),
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      widget.item.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      widget.item.category,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      DateFormat.Hms()
                          .add_yMd()
                          .format(widget.item.createAt.toDate()),
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15.0),
                    Column(
                      children: <Widget>[
                        Card(
                          child: ListTile(
                            leading: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ProfileScreen(
                                            currentUserId:
                                                Provider.of<UserData>(context)
                                                    .currentUserId,
                                            userId: widget.item.idAuthor,
                                          ))),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: CachedNetworkImageProvider(
                                    widget.item.imageAuthor),
                              ),
                            ),
                            title: Text(widget.item.nameAuthor),
                            subtitle: Text(
                              widget.item.addressAuthor,
                              maxLines: 1,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 25.0),
                    Container(
                      height: 120.0,
                      child: SingleChildScrollView(
                        child: Text(
                          widget.item.desc,
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Hình mô tả ',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => print('View '),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                  size: 30.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
