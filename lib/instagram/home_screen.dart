
import 'package:doantotnghiep2020/instagram/pages/activity_screen.dart';
import 'package:doantotnghiep2020/instagram/pages/create_post_screen.dart';
import 'package:doantotnghiep2020/instagram/pages/feed_screen.dart';
import 'package:doantotnghiep2020/instagram/pages/profile_screen.dart';
import 'package:doantotnghiep2020/instagram/pages/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doantotnghiep2020/models/user_data.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = Provider.of<UserData>(context).currentUserId;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          FeedScreen(currentUserId: currentUserId),
          SearchScreen(),
          CreatePostScreen(currentUserId: currentUserId,),
          ActivityScreen(currentUserId: currentUserId),
          ProfileScreen(
            userId: currentUserId,
            currentUserId: currentUserId,
          ),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentTab = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        
        currentIndex: _currentTab,
        onTap: (int index) {
          setState(() {
            _currentTab = index;
          });
          //click tabbar swap screen
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        },
        // màu biểu tượng
        activeColor: Colors.blue[200],
        items: [
          BottomNavigationBarItem(
              icon: Icon(
            Icons.home,
            size: 32,
          )),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.search,
            size: 32,
          )),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.camera_alt,
            size: 32,
          )),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.notifications,
            size: 32,
          )),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.account_circle,
            size: 32,
          )),
        ],
      ),
    );
  }
}
