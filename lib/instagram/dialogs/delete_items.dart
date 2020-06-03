import 'package:doantotnghiep2020/models/item_model.dart';
import 'package:doantotnghiep2020/services/database_service.dart';
import 'package:flutter/material.dart';

class DeleteItem {
  static void showLoadingDialog(BuildContext context, Item item) {
    showDialog(
        context: context,
        barrierDismissible: true, // clilk ở ngoài tắt = false
        builder: (context) => new Dialog(
            backgroundColor: Colors.white12,
            child: Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () async {
                          await DatabaseService().deleteItem(item.id);
                          await DatabaseService().addBought(Item(
                            id: item.id,
                            addressAuthor: item.addressAuthor,
                            category: item.category,
                            count: item.count,
                            createAt: item.createAt,
                            desc: item.desc,
                            idAuthor: item.idAuthor,
                            imageAuthor: item.imageAuthor,
                            imageUrl: item.imageUrl,
                            money: item.money,
                            name: item.name,
                            nameAuthor: item.nameAuthor,
                            phoneAuthor: item.phoneAuthor,
                            updateAt: item.updateAt,
                          ));
                          DeleteItem.hideLoadingDialog(context);
                        },
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text('Đã bán',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    FlatButton(
                        onPressed: () async {
                          await DatabaseService().deleteItem(item.id);
                          DeleteItem.hideLoadingDialog(context);
                        },
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text('Dừng bán',
                            style: TextStyle(fontWeight: FontWeight.bold)))
                  ],
                ))));
  }

  static hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(DeleteItem);
  }
}
