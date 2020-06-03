import 'package:doantotnghiep2020/models/item_model.dart';
import 'package:doantotnghiep2020/services/database_service.dart';
import 'package:doantotnghiep2020/shopping/screen/items_detail.dart';
import 'package:flutter/material.dart';

class Single_Product extends StatelessWidget {
  final Item items;
  Single_Product({this.items});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.black, blurRadius: 20, offset: Offset(3, 5))
      ]),
      margin: EdgeInsets.all(10),
      child: Hero(
          tag: items.imageUrl,
          child: Material(
            child: InkWell(
              onTap: () async{
                Item itemupdate = Item(
                        id: items.id,
                        count: items.count + 1,
                        category: items.category,
                        createAt: items.createAt,
                        imageUrl: items.imageUrl,
                        addressAuthor: items.addressAuthor,
                        desc: items.desc,
                        idAuthor: items.idAuthor,
                        imageAuthor: items.imageAuthor,
                        money: items.money,
                        phoneAuthor: items.phoneAuthor,
                        name: items.name,
                        nameAuthor: items.nameAuthor,
                        updateAt: items.updateAt,
                      );
                      await DatabaseService().updateItem(itemupdate);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ItemDetail(
                                    item: items,
                                  )));
              },
              child: GridTile(
                footer: Container(
                  color: Colors.white24,
                  child: ListTile(
                    title: Text(
                      items.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12),
                    ),
                    subtitle: Text(
                      items.money,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 10),
                    ),
                  ),
                ),
                child: Image.network(
                  items.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )),
    );
  }
}
