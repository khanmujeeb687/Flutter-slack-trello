import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:wively/src/data/models/chat.dart';
import 'package:wively/src/data/models/custom_error.dart';
import 'package:wively/src/data/models/room.dart';
import 'package:wively/src/data/models/user.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/data/repositories/room_repository.dart';
import 'package:wively/src/screens/add_chat/add_chat_view.dart';
import 'package:wively/src/screens/contact/contact_view.dart';
import 'package:wively/src/utils/navigation_util.dart';
import 'package:wively/src/utils/state_control.dart';

class ProfileController extends StateControl with WidgetsBindingObserver {
  RoomRepository _roomRepository=new RoomRepository();

  final BuildContext context;

  ChatsProvider _chatsProvider;

  User get currentUser => _chatsProvider.currentUser;

  final User user;

  final Chat chat;

  List<Room> _commonRooms=[];

  List<Room> get commonRooms => _commonRooms;

  List<String> _medias=[];

  List<String> get media => _medias;

  bool _error = false;

  bool get error => _error;


  bool _loading = false;

  bool get loading => _loading;


  ProfileController({@required this.context,@required this.user,@required this.chat}) {
    this.init();
  }

  @override
  void init() {
    _chatsProvider=Provider.of<ChatsProvider>(context);
    getAllMedia();
    getCommonRooms();
  }


  Future getAllMedia() async{
  _medias = await _chatsProvider.getAllMediasForChat(chat);
    notifyListeners();
  }

  Future getCommonRooms() async{
    var response = await _roomRepository.getAllCommonRooms(user.id);
    if (response is CustomError) {
      _error = true;
    }
    if (response is List<Room>) {
      _commonRooms = response;
    }
    _loading = false;
    notifyListeners();
  }


  @override
  void dispose() {
    super.dispose();
  }
}
