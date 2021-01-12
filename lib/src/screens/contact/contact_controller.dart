import 'dart:convert';

import 'package:wively/src/data/models/chat.dart';
import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/data/models/room.dart';
import 'package:wively/src/data/models/user.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/data/repositories/chat_repository.dart';
import 'package:wively/src/screens/room/create_room.dart';
import 'package:wively/src/screens/room/room_info.dart';
import 'package:wively/src/screens/room/room_view.dart';
import 'package:wively/src/screens/task_board/add_task_view.dart';
import 'package:wively/src/screens/task_board/task_board_view.dart';
import 'package:wively/src/utils/custom_shared_preferences.dart';
import 'package:wively/src/utils/dates.dart';
import 'package:wively/src/utils/state_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ContactController extends StateControl {
  BuildContext context;

  ChatRepository _chatRepository = ChatRepository();

  ScrollController scrollController;

  ChatsProvider _chatsProvider;

  Chat get selectedChat => _chatsProvider.selectedChat;
  List<Chat> get chats => _chatsProvider.chats;

  TextEditingController textController = TextEditingController();

  User myUser;

  bool _error = false;
  bool get error => _error;

  bool _loading = true;
  bool get loading => _loading;
  
  bool _showEmojiKeyboard = false;
  bool get showEmojiKeyboard => _showEmojiKeyboard;

  set showEmojiKeyboard(bool showEmojiKeyboard) {
    _showEmojiKeyboard = showEmojiKeyboard;
    notifyListeners();
  }

  ContactController({
    @required this.context,
  }) {
    this.init();
  }

  void init() {
    scrollController = new ScrollController()..addListener(_scrollListener);
    initMyUser();
  }

  void addRoomScreen() async {
    Navigator.of(context).pushNamed(RoomScreen.routeName,arguments: this.selectedChat.room.id);
  }

  initMyUser() async {
    myUser = await getMyUser();
    notifyListeners();
  }

  initProvider() {
    _chatsProvider = Provider.of<ChatsProvider>(context);
  }

  void openBoard(){
    Navigator.pushNamed(context, TaskBoardScreen.routeName,arguments: selectedChat.room.id);
  }

  getMyUser() async {
    final userString = await CustomSharedPreferences.get("user");
    final userJson = jsonDecode(userString);
    return User.fromJson(userJson);
  }
  
  openRoom(roomId){
    Navigator.of(context).pushNamed(RoomInfo.routeName,arguments: RoomInfoArguments(roomId));
  }

  sendMessage() async {
    UtilDates.getTodayMidnight();
    final message = textController.text.trim();
    if (message.length == 0) return;
    final user = await CustomSharedPreferences.getMyUser();
    final myId = user.id;
    final selectedChat = Provider.of<ChatsProvider>(context, listen: false).selectedChat;
    final to = selectedChat.room.id;
    final newMessage = Message(
      chatId: selectedChat.id,
      from: myId,
      to_room: to,
      message: message,
      sendAt: DateTime.now().millisecondsSinceEpoch,
      unreadByMe: false,
      fromUser: myUser.username
    );
    textController.text = "";
    await Provider.of<ChatsProvider>(context, listen: false).addMessageToChat(newMessage);
    await _chatRepository.sendMessageToRoom(message,user.id,selectedChat.room.id);
    
  }

  void createChildRoom() async{
    Navigator.pushNamed(context, CreateRoom.routeName,arguments: selectedChat.room.id);
  }

  String getNumberOfUnreadChatsToString() {
    final unreadChats = chats.where((chat) {
      return chat.messages.where((message) => message.unreadByMe).length > 0;
    }).length;
    if (unreadChats > 0) {
      return unreadChats.toString();
    }
    return '';
  }

  void _scrollListener() {
    if (scrollController.position.extentAfter < 650) {
      _chatsProvider.loadMoreSelectedChatMessages();
    }
  }

  void dispose() {
    super.dispose();
    textController.dispose();
    _chatsProvider.setSelectedChat(null);
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
  }
}
