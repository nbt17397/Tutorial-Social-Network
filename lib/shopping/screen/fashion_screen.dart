import 'package:doantotnghiep2020/models/item_model.dart';
import 'package:doantotnghiep2020/services/database_service.dart';
import 'package:doantotnghiep2020/shopping/widget/product_widget.dart';
import 'package:flutter/material.dart';

class FashionScreen extends StatefulWidget {
  @override
  _FashionScreenState createState() => _FashionScreenState();
}

class _FashionScreenState extends State<FashionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thời trang đồ dùng cá nhân'),
      ),
      body: StreamBuilder(
          stream: DatabaseService().getThoiTrang(),
          builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
            if (snapshot.hasError || !snapshot.hasData)
              return CircularProgressIndicator();

            return GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  Item item = snapshot.data[index];
                    return Single_Product(
                      items: item,
                    );
                  
                });
          }),
    );
  }
}