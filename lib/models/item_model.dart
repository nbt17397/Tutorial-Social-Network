import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String imageUrl;
  final String name;
  final String category;
  final String money;
  final Timestamp createAt;
  final Timestamp updateAt;
  final String desc;
  final int count;
  final String idAuthor;
  final String phoneAuthor;
  final String nameAuthor;
  final String imageAuthor;
  final String addressAuthor;

  Item(
      {this.id,
      this.createAt,
      this.desc,
      this.phoneAuthor,
      this.imageUrl,
      this.money,
      this.category,
      this.count,
      this.name,
      this.updateAt,
      this.addressAuthor,
      this.imageAuthor,
      this.idAuthor,
      this.nameAuthor});

  Item.fromMap(Map<String, dynamic> data, String id)
      : id = id,
        category = data['category'],
        desc = data['desc'],
        imageUrl = data['imageUrl'],
        money = data['money'],
        createAt = data['createAt'],
        name = data['name'],
        count=data['count'],
        phoneAuthor=data['phoneAuthor'],
        updateAt = data['updateAt'],
        idAuthor = data['idAuthor'],
        addressAuthor = data['addressAuthor'],
        imageAuthor = data['imageAuthor'],
        nameAuthor = data['nameAuthor'];

        Map<String,dynamic> toMap(){
          return {
            'category': category,
            'desc': desc,
            'imageUrl': imageUrl,
            'money': money,
            'createAt': createAt,
            'phoneAuthor': phoneAuthor,
            'name': name,
            'count': count,
            'updateAt': updateAt,
            'idAuthor': idAuthor,
            'addressAuthor': addressAuthor,
            'imageAuthor': imageAuthor,
            'nameAuthor': nameAuthor,
          };
        }
}

final List<Item> item = [
  Item(
    imageUrl: 'assets/images/BatDongSan.jpg',
    name: 'Bất động sản',
  ),
  Item(
    imageUrl: 'assets/images/thoitrang.jpg',
    name: 'Thời trang đồ dùng cá nhân',
  ),
  Item(
    imageUrl: 'assets/images/XeCo.jpg',
    name: 'Xe cộ',
  ),
  Item(
    imageUrl: 'assets/images/DienTu.jpg',
    name: 'Đồ điện tử',
  ),
  Item(
    imageUrl: 'assets/images/NoiThat.jpg',
    name: 'Đồ gia dụng nội thất',
  ),
];
