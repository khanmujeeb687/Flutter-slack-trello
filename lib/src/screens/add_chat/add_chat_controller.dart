import 'dart:async';
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:wively/src/data/local_database/db_provider.dart';
import 'package:wively/src/data/models/chat.dart';
import 'package:wively/src/data/models/custom_error.dart';
import 'package:wively/src/data/models/user.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/data/repositories/chat_repository.dart';
import 'package:wively/src/data/repositories/room_repository.dart';
import 'package:wively/src/data/repositories/user_repository.dart';
import 'package:wively/src/screens/contact/contact_view.dart';
import 'package:wively/src/utils/custom_shared_preferences.dart';
import 'package:wively/src/utils/room_message_controller.dart';
import 'package:wively/src/utils/state_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/loader_dialog.dart';
import 'package:wively/src/widgets/lottie_loader.dart';
import 'package:wively/src/widgets/my_button.dart';

class AddChatController extends StateControl {
  UserRepository _userRepository = UserRepository();
  ChatRepository _chatRepository = ChatRepository();
  RoomRepository _roomRepository = RoomRepository();

  final BuildContext context;

  bool _loading = true;

  bool get loading => _loading;

  bool _error = false;

  bool get error => _error;

  List<User> _users = [];

  List<User> get users => _users;

  Chat _chat;

  ProgressDialog _progressDialog;

  AddChatController({
    @required this.context,
  }) {
    this.init();
  }

  @override
  void init() {
    getUsers();
  }

  void getUsers() async {
    dynamic response = await _userRepository.getUsers();

    if (response is CustomError) {
      _error = true;
    }
    if (response is List<User>) {
      _users = response;
    }
    _loading = false;
    notifyListeners();
  }

  void newChat(User user) async {

    _showProgressDialog();

    final Chat chat = Chat(
      id: user.chatId,
      user: user,
      isRoom: false
    );
    final _provider = Provider.of<ChatsProvider>(context, listen: false);
    _provider.createUserIfNotExists(chat.user);
    _provider.createChatIfNotExists(chat);
    _provider.setSelectedChat(chat);
    Navigator.of(context).popAndPushNamed(ContactScreen.routeName);
    _dismissProgressDialog();
    Provider.of<ChatsProvider>(context, listen: false).setSelectedChat(chat);
    _loading = false;
    notifyListeners();
  }

  void _showProgressDialog() {
    _progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    _progressDialog.style(
        message: 'Loading...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: lottieLoader(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    _progressDialog.show();
  }

  void addToThisGroup(roomId, name, userId) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 100,
            color: EColors.themeMaroon,
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Add $name to this group?',style: TextStyle(
                  color: EColors.themeGrey
                ),),
                RaisedButton(
                  child: Text('+Add'),
                  onPressed: () async {
                    LoaderDialogManager.showLoader(context);
                    var data =
                        await _roomRepository.addNewMember(roomId, userId);
                    if (data is Map<String, dynamic>) {
                      User user =await CustomSharedPreferences.getMyUser();
                      new RoomMessageController().informMe(context, data,user.username);
                      Fluttertoast.showToast(msg: 'User added successfully');
                    }
                    if(data==null){
                      Fluttertoast.showToast(msg: 'User already added');
                    }
                    LoaderDialogManager.hideLoader();
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }

  Future<bool> _dismissProgressDialog() {
    return _progressDialog.hide();
  }

  void closeScreen() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
