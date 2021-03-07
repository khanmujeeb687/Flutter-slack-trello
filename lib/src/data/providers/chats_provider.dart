import 'package:wively/src/data/local_database/db_provider.dart';
import 'package:wively/src/data/local_database/db_update.dart';
import 'package:wively/src/data/models/chat.dart';
import 'package:wively/src/data/models/file_models.dart';
import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/data/models/user.dart';
import 'package:wively/src/data/repositories/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:wively/src/utils/custom_shared_preferences.dart';

class ChatsProvider with ChangeNotifier {

  ChatRepository _chatRepository = ChatRepository();

  List<Chat> _chats = [];
  List<Chat> get chats => _chats;

  Chat _selectedChat;
  Chat get selectedChat => _selectedChat;

  User _currentUser;
  User get currentUser=>_currentUser;

  DBUpdate _dbUpdate=new DBUpdate();

  bool _noMoreSelectedChatMessages = false;
  bool get noMoreSelectedChatMessages => _noMoreSelectedChatMessages;

  bool _loadingMoreMessages = false;

  updateChats() async {
    _chats = await DBProvider.db.getChatsWithMessages();
    notifyListeners();
  }

  setSelectedChat(Chat selectedChat) async {
    _selectedChat = selectedChat;
    _noMoreSelectedChatMessages = false;
    _loadingMoreMessages = false;
    if (_selectedChat != null) {
      notifyListeners();
      _selectedChat.messages = await DBProvider.db.getChatMessages(selectedChat.id);
      _readSelectedChatMessages();
    }
  }

  getCurrentUser()async{
    _currentUser =await CustomSharedPreferences.getMyUser();
  }

  updateCurrentUser(User user) async{
    await CustomSharedPreferences.setString('user', user.toString());
    notifyListeners();
  }


  loadMoreSelectedChatMessages() async {
    if (!noMoreSelectedChatMessages && selectedChat.messages.length > 0 && !_loadingMoreMessages) {
      _loadingMoreMessages = true;
      int lastMessageId = _selectedChat.messages[_selectedChat.messages.length - 1].localId;
      List<Message> newMessages = await DBProvider.db.getChatMessagesWithOffset(selectedChat.id, lastMessageId);
      if (newMessages.length == 0) {
        _noMoreSelectedChatMessages = true;
        return;
      }
      // newMessages.forEach((message) {
      //   print("messageee ${message.toJson()}");
      // });
      _selectedChat.messages = _selectedChat.messages + newMessages;
      _loadingMoreMessages = false;
      notifyListeners();
    }
  }

  _readSelectedChatMessages() async {
    await DBProvider.db.readChatMessages(_selectedChat.id);
    updateChats();
  }

  addMessageToSelectedChat(Message message) {
    DBProvider.db.addMessage(message);
    updateChats();
  }

  createUserIfNotExists(User user) async {
    await DBProvider.db.createUserIfNotExists(user);
    updateChats();
  }
  createRoomIfNotExists(Chat chat) async {
    await DBProvider.db.createRoomIfNotExists(chat);
    updateChats();
  }

  createChatIfNotExists(Chat chat) async {
    await DBProvider.db.createChatIfNotExists(chat);
    updateChats();
  }

  createChatAndUserIfNotExists(Chat chat) async {
    if(chat.room!=null){
      await DBProvider.db.createRoomIfNotExists(chat);
    }else{
      await DBProvider.db.createUserIfNotExists(chat.user);
    }
    await DBProvider.db.createChatIfNotExists(chat);
    updateChats();
  }

  addMessageToChat(Message message) async {
   int id= await DBProvider.db.addMessage(message);
    updateChats();
    setSelectedChat(selectedChat);
    return id;
  }

  Future<void> setAllUnSentMessages(EFileState first,EFileState second)async{
    await DBProvider.db.setAllUnSentFiles(first,second);
    updateChats();
  }

  Future<void> updateMessageState(int id,EFileState fileState) async{
    await DBProvider.db.changeMessageStatus(id, fileState);
    updateChats();
    setSelectedChat(selectedChat);
  }

  Future<void> updateMessageFilePath(int id,String filePath) async{
    await DBProvider.db.updateMessageFilePath(id, filePath);
    updateChats();
  }

  Future<List<String>> getAllMediasForChat(Chat chat) async{
   return await DBProvider.db.getAllMediasForChatId(chat.id);
  }

  Future<void> clearDatabase() async {
    await DBProvider.db.clearDatabase();
    updateChats();
  }

  updateUserDataBase() async{
   await _dbUpdate.updateUserDatabase();
    updateChats();
  }
}