import 'package:doantotnghiep2020/models/item_model.dart';
import 'package:doantotnghiep2020/services/database_service.dart';
import 'package:doantotnghiep2020/shopping/widget/product_widget.dart';
import 'package:flutter/material.dart';

class NoiThatScreen extends StatefulWidget {
  @override
  _NoiThatScreenState createState() => _NoiThatScreenState();
}

class _NoiThatScreenState extends State<NoiThatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đồ gia dụng nội thất'),
      ),
      body: StreamBuilder(
          stream: DatabaseService().getNoiThat(),
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