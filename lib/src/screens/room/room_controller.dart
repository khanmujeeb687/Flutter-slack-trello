import 'dart:async';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:wively/src/data/models/chat.dart';
import 'package:wively/src/data/models/custom_error.dart';
import 'package:wively/src/data/models/room.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/data/repositories/room_repository.dart';
import 'package:wively/src/screens/add_chat/add_chat_view.dart';
import 'package:wively/src/screens/contact/contact_view.dart';
import 'package:wively/src/utils/state_control.dart';

class RoomController extends StateControl with WidgetsBindingObserver {
  RoomRepository _roomRepository = new RoomRepository();

  final BuildContext context;

  bool _loading = true;

  bool get loading => _loading;

  bool _error = false;

  bool get error => _error;

  List<Room> _rooms = [];

  List<Room> get rooms => _rooms;

  Room _room;

  Room get room => _room;

  ProgressDialog _progressDialog;

  RoomController({@required this.context}) {
    this.init();
  }

  @override
  void init() {}

  void getRooms(parentId) async {
    dynamic response = await _roomRepository.getRooms(parentId);

    if (response is CustomError) {
      _error = true;
    }
    if (response is List<Room>) {
      _rooms = response;
    }
    _loading = false;
    notifyListeners();
  }

  void newRoomChat(Room room) async {
    final Chat chat = new Chat(id: room.id, room: room, isRoom: true);
    final _provider = Provider.of<ChatsProvider>(context, listen: false);
    _provider.createRoomIfNotExists(chat);
    _provider.createChatIfNotExists(chat);
    _provider.setSelectedChat(chat);
    Navigator.of(context).popAndPushNamed(ContactScreen.routeName);
    _loading = false;
    notifyListeners();
  }

  void getRoomData(String roomId) async {
    var response = await _roomRepository.getRoomById(roomId);
    if (response is CustomError) {
      _error = true;
    }
    if (response is Room) {
      _room = response;
    }
    _loading = false;
    notifyListeners();
  }

  void addNewMember(roomId) {
    Navigator.of(context).pushNamed(AddChatScreen.routeName, arguments: roomId);
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
