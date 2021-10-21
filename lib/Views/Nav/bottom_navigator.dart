
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lit_beta/Styles/theme_resolver.dart';
import 'package:lit_beta/Views/Chat/chat.dart';
import 'package:lit_beta/Views/Home/home.dart';
import 'package:lit_beta/Views/Map/Map.dart';
import 'package:lit_beta/Views/Profile/profile.dart';
import 'package:lit_beta/Views/Search/search.dart';

class BottomNavigationController extends StatefulWidget {
  final String userID;
  BottomNavigationController({Key key, this.userID}) : super(key: key);

  @override
  _BottomNavigationControllerState createState() => _BottomNavigationControllerState();
}

class _BottomNavigationControllerState extends State<BottomNavigationController> {

  int _currentPage = 0;
  final PageStorageBucket bucket = PageStorageBucket();


  @override
  void dispose(){
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget initBottomNavControllerTabs(int idx){
    List<Widget> tabs = [
      FeedPage(key: PageStorageKey('home'), userID: widget.userID),
      SearchPage(key: PageStorageKey('search'),),
      MapPage(key: PageStorageKey('map'),),
      ChatPage(key: PageStorageKey('chat'),),
      ProfilePage(key: PageStorageKey('profile'), userID: widget.userID)
    ];
    return tabs[idx];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: _bottomNavigationProvider(_currentPage),
      body: PageStorage(
        child: initBottomNavControllerTabs(_currentPage),
        bucket: bucket,
      ),
    );

  }

  Widget _bottomNavigationProvider(int idx) => BottomNavigationBar(
    iconSize: 35,
    selectedFontSize: 15,
    selectedItemColor: Theme.of(context).dividerColor,
    currentIndex: _currentPage,
    onTap: (int index) => setState(() => _currentPage = index),
    items:  [
      bottomItemWidget(Ionicons.md_home,Ionicons.md_home, 'home'),
      bottomItemWidget(Ionicons.ios_eye,Ionicons.ios_eye, 'search'),
      bottomItemWidget(Ionicons.ios_pin,Ionicons.ios_pin, 'map'),
      bottomItemWidget(Ionicons.ios_chatbubbles,Ionicons.ios_chatbubbles, 'chat'),
      bottomItemWidget(Ionicons.md_person,Ionicons.md_person, 'you'),
    ],
  );

  //Returns custom bottomNavItem
  BottomNavigationBarItem bottomItemWidget(IconData i , IconData a ,String title){
    return BottomNavigationBarItem(
      icon: Icon(i , color: Theme.of(context).textSelectionColor,),
      activeIcon: Icon(a , color: Theme.of(context).primaryColor,size: 35,),
      title: new Text(title ,
        style: TextStyle(color: Theme.of(context).textSelectionColor ,fontSize: 14)) ,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,);
  }

}
