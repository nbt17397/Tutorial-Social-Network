import 'package:doantotnghiep2020/models/item_model.dart';
import 'package:doantotnghiep2020/services/database_service.dart';
import 'package:doantotnghiep2020/shopping/widget/product_widget.dart';
import 'package:flutter/material.dart';

class BDSScreen extends StatefulWidget {
  @override
  _BDSScreenState createState() => _BDSScreenState();
}

class _BDSScreenState extends State<BDSScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bất động sản'),
      ),
      body: StreamBuilder(
          stream: DatabaseService().getBDS(),
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