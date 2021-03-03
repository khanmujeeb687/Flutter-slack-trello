import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wively/src/data/models/chat.dart';
import 'package:wively/src/data/models/custom_error.dart';
import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/data/models/user.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/data/repositories/chat_repository.dart';
import 'package:wively/src/data/repositories/user_repository.dart';
import 'package:wively/src/screens/add_chat/add_chat_view.dart';
import 'package:wively/src/screens/contact/contact_view.dart';
import 'package:wively/src/screens/login/login_view.dart';
import 'package:wively/src/screens/room/room_view.dart';
import 'package:wively/src/screens/settings/settings_view.dart';
import 'package:wively/src/utils/custom_shared_preferences.dart';
import 'package:wively/src/utils/navigation_util.dart';
import 'package:wively/src/utils/socket_controller.dart';
import 'package:wively/src/utils/state_control.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../utils/NotificationsHandler.dart';
import '../../utils/NotificationsHandler.dart';

class HomeController extends StateControl with WidgetsBindingObserver {
  ChatRepository _chatRepository = ChatRepository();

  UserRepository _userRepository = UserRepository();

  ChatsProvider _chatsProvider;

  IO.Socket socket = SocketController.socket;

  FirebaseMessaging _firebaseMessaging;


  final BuildContext context;

  bool _error = false;
  bool get error => _error;

  List<Chat> get chats => _chatsProvider.chats;

  bool _loading = true;
  bool get loading => _loading;

  List<User> _users = [];
  List<User> get users => _users;

  User _user;
  User get user=>_user;

  AppLifecycleState _notification;

  final duration = const Duration(milliseconds: 100);

  bool isSocketConnected = false;

  HomeController({
    @required this.context,
  }) {
    this.init();
  }



  void getMyUser()async {
    var a=await CustomSharedPreferences.getMyUser();
    if(user!=null){
      _user=a;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _notification = state;
    print("state $state");
    if (state == AppLifecycleState.inactive) {
      disconnectSocket();
    }
    if (state == AppLifecycleState.resumed) {
      // socket.connect();
      connectSocket();
    }
  }

  connectSocket() {
    disconnectSocket();
    socket.connect();
    _loading = true;
    notifyListeners();
    Timer.periodic(duration, (timer) {
      print("socket connected ${socket.connected}");
      if (socket.connected) {
        if (timer != null) timer.cancel();
        initSocket();
      }
    });
  }

  disconnectSocket() {
    socket.disconnect();
    isSocketConnected = false;
    inactiveSocketFunctions();
  }

  inactiveSocketFunctions() {
    socket.off("user-in");
    socket.off("message");
  }

  void init() {
    _firebaseMessaging = FirebaseMessaging();
    requestPushNotificationPermission();
    connectSocket();
    WidgetsBinding.instance.addObserver(this);
    getMyUser();
  }

  void initSocket() {
    if (!isSocketConnected) {
      isSocketConnected = true;
      emitUserIn();
      onMessage();
      onUserIn();
    }
  }

  void emitUserIn() async {
    User user = await CustomSharedPreferences.getMyUser();
    Map<String, dynamic> json = user.toJson();
    socket.emit("user-in", json);
  }

  void onUserIn() async {
    socket.on("user-in", (_) {
      _loading = false;
      notifyListeners();
    });
  }

  void onMessage() async {
    socket.on("message", (dynamic data) async {
      User user =await CustomSharedPreferences.getMyUser();
      if(data['message']['from']['_id']==user.id) return;
      Map<String, dynamic> json = data['message'];
      Map<String, dynamic> roomJson = json['room'];
      Map<String, dynamic> userJson = json['from'];
      Chat chat = Chat.fromJson({
        "_id": json['chatId'],
        "room": roomJson,
        "user":userJson
      });
      Message message = Message.fromJson(json);
      Provider.of<ChatsProvider>(context, listen: false)
          .createChatAndUserIfNotExists(chat);
      Provider.of<ChatsProvider>(context, listen: false)
          .addMessageToChat(message);
      if(chat.room!=null)
        await _chatRepository.deleteRoomMessage(message.id,user.id);
      else
        await _chatRepository.deleteMessage(message.id);
    });
  }

  void emitUserLeft() async {
    socket.emit("user-left");
  }

  void requestPushNotificationPermission() {
    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(
          alert: true,
          badge: true,
          provisional: false,
        ),
      );
    }
  }



  void initProvider() {
    _chatsProvider = Provider.of<ChatsProvider>(context);
    _chatsProvider.getCurrentUser();
  }

  void openAddChatScreen() async {
    NavigationUtil.navigate(context,AddChatScreen());
  }

  void addRoomScreen() async {
    NavigationUtil.navigate(context,RoomScreen());
  }

  void openSettings() async {
    NavigationUtil.navigate(context,SettingsScreen());
  }

  @override
  void dispose() {
    super.dispose();
    emitUserLeft();
    disconnectSocket();
    WidgetsBinding.instance.removeObserver(this);
    disconnectSocket();
  }
}
