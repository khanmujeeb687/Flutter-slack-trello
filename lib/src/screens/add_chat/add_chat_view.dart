import 'package:wively/src/screens/add_chat/add_chat_controller.dart';
import 'package:wively/src/widgets/custom_app_bar.dart';
import 'package:wively/src/widgets/custom_cupertino_navigation_bar.dart';
import 'package:wively/src/widgets/custom_cupertino_sliver_navigation_bar.dart';
import 'package:wively/src/widgets/user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddChatScreen extends StatefulWidget {
  static final String routeName = '/add-chat';

  @override
  _AddChatScreenState createState() => _AddChatScreenState();
}

class _AddChatScreenState extends State<AddChatScreen> {
  AddChatController _addChatController;

  @override
  void initState() {
    super.initState();
    _addChatController = AddChatController(
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: _addChatController.streamController.stream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: CustomAppBar(
              title: Text('New chat'),
            ),
            body: renderUsers(),
          );
        });
  }

  Widget renderUsers() {
    if (_addChatController.loading) {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
    if (_addChatController.error) {
      return Center(
        child: Text('There was an error fetching users.'),
      );
    }
    if (_addChatController.users.length == 0) {
      return Center(
        child: Text('No users found'),
      );
    }
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: _addChatController.users.map((user) {
            return Column(
              children: <Widget>[
                UserCard(
                  user: user,
                  onTap:(a)=>{},
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
