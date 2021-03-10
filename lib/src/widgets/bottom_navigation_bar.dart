import 'package:flutter/material.dart';
import 'package:wively/src/values/Colors.dart';



class EBottomNavigation extends StatefulWidget {
  int selectedTab;
  Function(int a) onClick;

  EBottomNavigation(this.onClick,this.selectedTab);
  @override
  _EBottomNavigationState createState() => _EBottomNavigationState();
}

class _EBottomNavigationState extends State<EBottomNavigation> {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: EColors.themeMaroon,
      selectedIconTheme: IconThemeData(
          color: EColors.themePink,
          size: 25
      ),
      unselectedIconTheme: IconThemeData(
          color: EColors.themeGrey,
          size: 20
      ),
      unselectedItemColor: EColors.white,
      selectedItemColor: EColors.themePink,
      type: BottomNavigationBarType.fixed,
      onTap: widget.onClick,
      currentIndex: widget.selectedTab,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Chats")
        ),BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text("Dms")
        ),BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            title: Text("Task boards")
        ),BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text("Settings")
        ),
      ],
    );
  }
}
