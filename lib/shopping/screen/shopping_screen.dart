import 'package:doantotnghiep2020/models/item_model.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:doantotnghiep2020/services/database_service.dart';
import 'package:doantotnghiep2020/shopping/screen/add_item.dart';
import 'package:doantotnghiep2020/shopping/screen/bds_screen.dart';
import 'package:doantotnghiep2020/shopping/screen/car_screen.dart';
import 'package:doantotnghiep2020/shopping/screen/fashion_screen.dart';
import 'package:doantotnghiep2020/shopping/screen/items_detail.dart';
import 'package:doantotnghiep2020/shopping/screen/noithat_screen.dart';
import 'package:doantotnghiep2020/shopping/screen/phone_screen.dart';
import 'package:flutter/material.dart';

class ShoppingScreen extends StatefulWidget {
  final User user;
  ShoppingScreen({this.user});
  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 2, viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Mua bán Online',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {})
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 280.0,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return _movieSelector(index);
              },
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(250, 0, 0, 1),
                      Color.fromRGBO(250, 148, 251, .4),
                    ])),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Text(
                    'Sản phẩm mới',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: () {})
            ],
          ),
          _getNewItems(),
          SizedBox(
            height: 10.0,
          ),
          Divider(),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(0, 60, 251, 1),
                      Color.fromRGBO(0, 120, 251, .4),
                    ])),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Text(
                    'Sản phẩm nổi bật',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: () {})
            ],
          ),
          _getNoiBat(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AddItem(
                          user: widget.user,
                        )));
          }),
    );
  }

  _movieSelector(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 270.0,
            width: Curves.easeInOut.transform(value) * 400.0,
            child: widget,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => item[index].name == 'Xe cộ'
                      ? CarScreen()
                      : item[index].name == 'Bất động sản'
                          ? BDSScreen()
                          : item[index].name == 'Thời trang đồ dùng cá nhân'
                              ? FashionScreen()
                              : item[index].name == 'Đồ điện tử'
                                  ? PhoneScreen()
                                  : NoiThatScreen()));
        },
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0.0, 4.0),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Center(
                  child: Hero(
                    tag: item[index].imageUrl,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image(
                        image: AssetImage(item[index].imageUrl),
                        height: 220.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 30.0,
              bottom: 40.0,
              child: Container(
                width: 250.0,
                child: Text(
                  item[index].name.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getNewItems() {
    return Container(
      height: 220,
      child: StreamBuilder(
          stream: DatabaseService().getNewItems(),
          builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
            if (snapshot.hasError || !snapshot.hasData)
              return CircularProgressIndicator();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Item item = snapshot.data[index];
                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 20.0,
                  ),
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(4.0, 4.0),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () async {
                      Item items = Item(
                        id: item.id,
                        count: item.count + 1,
                        category: item.category,
                        createAt: item.createAt,
                        imageUrl: item.imageUrl,
                        addressAuthor: item.addressAuthor,
                        desc: item.desc,
                        phoneAuthor: item.phoneAuthor,
                        idAuthor: item.idAuthor,
                        imageAuthor: item.imageAuthor,
                        money: item.money,
                        name: item.name,
                        nameAuthor: item.nameAuthor,
                        updateAt: item.updateAt,
                      );
                      await DatabaseService().updateItem(items);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ItemDetail(
                                    item: item,
                                  )));
                    },
                    child: GridTile(
                      footer: ListTile(
                        title: Text(
                          item.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15),
                        ),
                        subtitle: Text(
                          item.money,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 12),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  _getNoiBat() {
    return Container(
      height: 220,
      child: StreamBuilder(
          stream: DatabaseService().getNoiBat(),
          builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
            if (snapshot.hasError || !snapshot.hasData)
              return CircularProgressIndicator();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Item item = snapshot.data[index];
                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 20.0,
                  ),
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(4.0, 4.0),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ItemDetail(
                                    item: item,
                                  )));
                    },
                    child: GridTile(
                      footer: ListTile(
                        title: Text(
                          item.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15),
                        ),
                        subtitle: Text(
                          item.count.toString() + ' lượt xem',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 12),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
