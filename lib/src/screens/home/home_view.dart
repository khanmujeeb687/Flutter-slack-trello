import 'package:wively/src/screens/add_chat/add_chat_view.dart';
import 'package:wively/src/screens/home/home_controller.dart';
import 'package:wively/src/screens/room/create_room.dart';
import 'package:wively/src/screens/settings/settings_view.dart';
import 'package:wively/src/utils/navigation_util.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/bottom_navigation_bar.dart';
import 'package:wively/src/widgets/chat_card.dart';
import 'package:wively/src/widgets/custom_app_bar.dart';
import 'package:wively/src/widgets/custom_cupertino_sliver_navigation_bar.dart';
import 'package:wively/src/widgets/file_viewer.dart';
import 'package:wively/src/widgets/user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static final String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController _homeController;

  @override
  void initState() {
    super.initState();
    _homeController = HomeController(context: context);
  }

  @override
  void dispose() {
    _homeController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _homeController.initProvider();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: _homeController.streamController.stream,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: CustomAppBar(
            title: Text(_homeController.loading ? 'Connecting...' : 'Chats'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.supervised_user_circle),
                onPressed: () {
                  NavigationUtil.navigate(context,CreateRoom());
                },
              ),
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: _homeController.openAddChatScreen,
              ),
            ],
          ),
          body: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
                child: _animatedSwitcher()
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _homeController.addRoomScreen,
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.message,
              color: Theme.of(context).accentColor,
            ),
          ),
          bottomNavigationBar: EBottomNavigation(_homeController.changeTab,_homeController.selectedTab)
        );
      },
    );
  }


  _animatedSwitcher(){
    switch(_homeController.selectedTab){
      case 0:
        return usersList(context);
      case 1:
        return usersList(context,onlyDms: true);
      case 2:
        return usersList(context,onlyDms: true);
      case 3:
        return SettingsScreen();
    }
    return Nothing();
  }

  Widget usersList(BuildContext context,{bool onlyDms=false}) {
    // if (_homeController.loading) {
    //   return SliverFillRemaining(
    //     child: Center(
    //       child: lottieLoader(),
    //     ),
    //   );
    // }
    // if (_homeController.error) {
    //   return SliverFillRemaining(
    //     child: Center(
    //       child: Text('Ocorreu um erro ao buscar suas conversas.'),
    //     ),
    //   );
    // }
    if (_homeController.chats.length == 0) {
      return Center(
        child: Text('You have no conversations.',style: TextStyle(color: Colors.white),),
      );
    }
    bool theresChatsWithMessages = _homeController.chats.where((chat) {
          return chat.messages.length > 0;
        }).length >
        0;
    if (!theresChatsWithMessages) {
      return Center(
        child: Text('You don\'t have conversations.'),
      );
    }
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: _homeController.chats.map((chat) {
            if(chat.isRoom && onlyDms) return Nothing();
            if (chat.messages.length == 0) {
              return Container(height: 0, width: 0);
            }
            return Column(
              children: <Widget>[
                ChatCard(
                  chat: chat,
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
