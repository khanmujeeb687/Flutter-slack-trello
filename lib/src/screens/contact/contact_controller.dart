import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wively/src/data/models/chat.dart';
import 'package:wively/src/data/models/custom_error.dart';
import 'package:wively/src/data/models/file_models.dart';
import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/data/models/message_types.dart';
import 'package:wively/src/data/models/room.dart';
import 'package:wively/src/data/models/user.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/data/providers/uploads_provider.dart';
import 'package:wively/src/data/repositories/chat_repository.dart';
import 'package:wively/src/data/repositories/user_repository.dart';
import 'package:wively/src/screens/profile/profile_view.dart';
import 'package:wively/src/screens/room/create_room.dart';
import 'package:wively/src/screens/room/room_info.dart';
import 'package:wively/src/screens/room/room_view.dart';
import 'package:wively/src/screens/task_board/add_task_view.dart';
import 'package:wively/src/screens/task_board/task_board_view.dart';
import 'package:wively/src/utils/custom_shared_preferences.dart';
import 'package:wively/src/utils/dates.dart';
import 'package:wively/src/utils/file_util.dart';
import 'package:wively/src/utils/message_utils.dart';
import 'package:wively/src/utils/navigation_util.dart';
import 'package:wively/src/utils/socket_controller.dart';
import 'package:wively/src/utils/state_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wively/src/widgets/select_file_sheet.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class ContactController extends StateControl {
  BuildContext context;

  ChatRepository _chatRepository = ChatRepository();

  UserRepository _userRepository = UserRepository();

  IO.Socket socket = SocketController.socket;


  ScrollController scrollController;

  ChatsProvider _chatsProvider;

  Chat get selectedChat => _chatsProvider?.selectedChat;

  List<Chat> get chats => _chatsProvider.chats;

  TextEditingController textController = TextEditingController();

  Chat parentChat;

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
    joinChat();
    initMyUser();
  }

  void addRoomScreen() async {
    NavigationUtil.navigate(
        context, RoomScreen(parentId: this.selectedChat.room.id));
  }

  initMyUser() async {
    myUser = await getMyUser();
    notifyListeners();
  }

  initProvider() {
    _chatsProvider = Provider.of<ChatsProvider>(context);
  }

  void openBoard() {
    NavigationUtil.navigate(context, TaskBoardScreen(selectedChat.room.id));
  }

  getMyUser() async {
    final userString = await CustomSharedPreferences.get("user");
    final userJson = jsonDecode(userString);
    return User.fromJson(userJson);
  }

  openRoom(roomId) {
    NavigationUtil.navigate(context, RoomInfo(RoomInfoArguments(roomId)));
  }

  sendMessage({String filePaths=''}) async {
    UtilDates.getTodayMidnight();
    final message = textController.text.trim();
    if (message.length == 0 && filePaths.length==0) return;
    final user = await CustomSharedPreferences.getMyUser();
    final myId = user.id;
    final selectedChat =
        Provider.of<ChatsProvider>(context, listen: false).selectedChat;
    final to =
        selectedChat.room == null ? selectedChat.user.id : selectedChat.room.id;
    final newMessage = Message(
        fileUrls:filePaths,
        fileUploadState: EFileState.sending,
        chatId: selectedChat.id,
        from: myId,
        to: selectedChat.room != null ? null : to,
        to_room: selectedChat.room == null ? null : to,
        message: message,
        sendAt: DateTime.now().millisecondsSinceEpoch,
        unreadByMe: false,
        fromUser: myUser.username);
    textController.text = "";
   int newMessageId = await Provider.of<ChatsProvider>(context, listen: false)
        .addMessageToChat(newMessage);
    if(filePaths.length>0){

      ///add the local id of message to update it
      newMessage.localId=newMessageId;

      if(MessageUtil.getTypeFromUrl(filePaths)==MessageTypes.IMAGE_MESSAGE){
        ///upload image thumbnail also
        Provider.of<UploadsProvider>(context,listen: false).uploadFile(File(FileUtil.getThumbPath(filePaths)),
            newMessage.sendAt.toString()+'thumb', null);
      }
      ///add file to upload queue
      Provider.of<UploadsProvider>(context,listen: false).uploadFile(File(filePaths), newMessage.sendAt.toString(), newMessage);
    }


    ///send message if it has text and not file
    if (!this.selectedChat.isRoom && filePaths.length==0){
      await _chatRepository.sendMessage(message, this.selectedChat.user.id);
    }else if(filePaths.length==0){
      await _chatRepository.sendMessageToRoom(
          message, user.id, selectedChat.room.id);
    }
  }

  void createChildRoom() async {
    NavigationUtil.navigate(context, CreateRoom(roomId: selectedChat.room.id));
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
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
  }

  Future<bool> willPop() async {
    leaveChat();
    await _chatsProvider.setSelectedChat(parentChat);
    return true;
  }

  showSelectFile() async {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(26), topLeft: Radius.circular(26)),
        ),
        context: context,
        // isDismissible: false,
        isScrollControlled: true,
        builder: (context) {
          return SelectFile(onSelectFilePress);
        });
  }

  onSelectFilePress(ESelectedFileType selectedFileType) async{
    NavigationUtil.goBack(context);

    String filePath;
    if(selectedFileType==ESelectedFileType.Image){
      filePath =await NavigationUtil.openImageEditor(context);
    }else if(selectedFileType==ESelectedFileType.document){
      filePath =await FileUtil.openFileSelector();
    }else if(selectedFileType==ESelectedFileType.Video){
      filePath =await FileUtil.openFileSelector(['mp4']);
    }else if(selectedFileType==ESelectedFileType.Audio){
      filePath =await FileUtil.openFileSelector(['mp3']);
    }
    if(filePath!=null){
      sendMessage(filePaths: filePath);
    }
  }



  openProfile(){
    NavigationUtil.navigate(context, ProfileView(selectedChat?.user,selectedChat));
  }

  onAppBarClick(){
    if(selectedChat.isRoom){
      openRoom(selectedChat?.room?.id);
    }else{
      openProfile();
    }
  }


  joinChat() async{
    await Future.delayed(Duration(milliseconds: 200));
    socket.on("online", (dynamic data) async {
      print(data.toString()+'DataMan');
      if(data['userId']==selectedChat.user.id){
        selectedChat.user.online=data['value'];
        if(data['lastSeen']!=null){
          selectedChat.user.lastSeen=data['lastSeen'];
          _chatsProvider.updateLastSeen(selectedChat.user);
        }
        notifyListeners();
      }
    });
    dynamic user = await _userRepository.joinLeaveChat(selectedChat.user.id, true);
    if(user is User){
      selectedChat.user=user;
      _chatsProvider.updateLastSeen(selectedChat.user);
      notifyListeners();
    }else if(user is CustomError){
      print(user.errorMessage.toString()+'error');
    }
  }


  leaveChat() async {
    _userRepository.joinLeaveChat(selectedChat.user.id, false);
    socket.off('online');
  }



}
