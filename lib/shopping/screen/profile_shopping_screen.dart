import 'package:doantotnghiep2020/instagram/dialogs/delete_items.dart';
import 'package:doantotnghiep2020/models/item_model.dart';
import 'package:doantotnghiep2020/models/user_data.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:doantotnghiep2020/services/database_service.dart';
import 'package:doantotnghiep2020/shopping/screen/edit_item.dart';
import 'package:doantotnghiep2020/shopping/screen/items_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ShoppingProfile extends StatefulWidget {
  final User user;
  ShoppingProfile({this.user});

  @override
  _ShoppingProfileState createState() => _ShoppingProfileState();
}

class _ShoppingProfileState extends State<ShoppingProfile> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.user.name),
          bottom: TabBar(
            indicatorColor: Colors.black,
            tabs: <Widget>[
              Tab(
                text: 'Sản phẩm đang bán',
              ),
              Tab(
                text: 'Sản phẩm đã bán',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _getBuying(),
            _getBought(),
          ],
        ),
      ),
    );
  }

  _getBuying() {
    return StreamBuilder(
        stream: DatabaseService().getUserBuying(widget.user.id),
        builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
          if (snapshot.hasError) return CircularProgressIndicator();
          if (!snapshot.hasData) {
            return Center(child: Text('Không có sản phẩm đang bán'));
          }
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Item item = snapshot.data[index];
                return Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10.0,
                              color: Colors.black54,
                              offset: Offset(4, 4))
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                blurRadius: 10.0,
                                color: Colors.black54,
                                offset: Offset(1, 2))
                          ]),
                          height: 100,
                          width: 100,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ItemDetail(
                                            item: item,
                                          )));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                item.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              item.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(item.money,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red)),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(DateFormat.Hms()
                                .add_yMd()
                                .format(item.createAt.toDate()))
                          ],
                        ),
                        widget.user.id ==
                                Provider.of<UserData>(context).currentUserId
                            ? Column(
                                children: <Widget>[
                                  IconButton(
                                      color: Colors.red,
                                      icon: Icon(Icons.delete_forever),
                                      onPressed: () {
                                        DeleteItem.showLoadingDialog(context, item);
                                      }),
                                  IconButton(
                                      color: Colors.blue,
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => EditItem(
                                                      item: item,
                                                    )));
                                      }),
                                ],
                              )
                            : Text('')
                      ],
                    ));
              });
        });
  }

  _getBought() {
    return StreamBuilder(
        stream: DatabaseService().getUserBought(widget.user.id),
        builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
          if (snapshot.hasError) return CircularProgressIndicator();
          if (!snapshot.hasData)
            return Center(child: Text('Không có sản phẩm đã bán'));
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Item item = snapshot.data[index];
                return Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10.0,
                              color: Colors.black54,
                              offset: Offset(4, 4))
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                blurRadius: 10.0,
                                color: Colors.black54,
                                offset: Offset(1, 2))
                          ]),
                          height: 100,
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              item.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              item.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(item.money,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red)),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(DateFormat.Hms()
                                .add_yMd()
                                .format(item.createAt.toDate()))
                          ],
                        ),
                        RaisedButton(
                            child: Text('Đã bán'),
                            color: Colors.blue,
                            textColor: Colors.white,
                            onPressed: () {}),
                        SizedBox(
                          height: 10.0,
                        )
                      ],
                    ));
              });
        });
  }

}