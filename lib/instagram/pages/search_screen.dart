import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep2020/instagram/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:doantotnghiep2020/models/user_data.dart';
import 'package:doantotnghiep2020/models/user_model.dart';
import 'package:doantotnghiep2020/instagram/animation/fade_animation.dart';
import 'package:doantotnghiep2020/services/database_service.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  Future<QuerySnapshot> _users;

  _buildUserTille(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Container(
          height: 75.0,
          child: ListTile(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: user.profileImageUrl.isEmpty
                            ? AssetImage('assets/images/user_placeholder.jpg')
                            : CachedNetworkImageProvider(user.profileImageUrl),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        user.name,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.group_add,
                    size: 30.0,
                  )
                ]),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfileScreen(
                          currentUserId:
                              Provider.of<UserData>(context).currentUserId,
                          userId: user.id,
                        ))),
          ),
        ),
      ),
    );
  }

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Card(
            color: Colors.grey[200],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Column(
              children: <Widget>[
                Container(
                  child: FadeAnimation(
                    2.0,
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, size: 30),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: _clearSearch,
                        ),
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        hintText: 'Tìm kiếm',
                      ),
                      onSubmitted: (input) {
                        if (input.isNotEmpty) {
                          setState(() {
                            _users = DatabaseService.searchUsers(input);
                          });
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: _users == null
            ? Padding(
                padding: EdgeInsets.only(top: 250.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(2.0, CircularProgressIndicator()),
                      SizedBox(height: 50),
                      Text('Hãy nhập vài từ để tìm kiếm trong Tustagram'),
                    ],
                  ),
                ),
              )
            : Card(
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: FutureBuilder(
                  future: _users,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data.documents.length == 0) {
                      return Center(
                        child: Text('No user found ! Please try again .'),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      //itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        User user =
                            User.fromDoc(snapshot.data.documents[index]);
                        return _buildUserTille(user);
                      },
                    );
                  },
                ),
              ));
  }
}

