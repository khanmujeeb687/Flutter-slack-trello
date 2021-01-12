import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wively/src/data/models/chat.dart';
import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/data/models/message_types.dart';
import 'package:wively/src/data/providers/chats_provider.dart';

class RoomMessageController{
  Future<void> informMe(BuildContext context,Map<String, dynamic> message,String username) async{
    final newMessage = Message(
      chatId: message['roomId'],
      from: message['from']['_id'],
      to_room:  message['roomId'],
      message: message['message'],
      sendAt: DateTime.now().millisecondsSinceEpoch,
      unreadByMe: false,
      fromUser: username
    );

    Chat chat = Chat.fromJson({
      "_id": message['roomId'],
      "room": message['room'],
    });
    Provider.of<ChatsProvider>(context, listen: false).createChatAndUserIfNotExists(chat);
    await Provider.of<ChatsProvider>(context, listen: false).addMessageToChat(newMessage);
  }






/// check added messages
  static bool isAddedMessage(String message){
    return(
    isNewUserAddedMessage(message) || isGroupCreatedMessages(message)
    );
  }



 static  isNewUserAddedMessage(String message){
    return message.contains(MessageTypes.SOMEONE_IS_ADDED_TO_GROUP);
  }

  static  isGroupCreatedMessages(String message){
    return message.contains(MessageTypes.CREATED_A_NEW_GROUP);
  }
  ///added messages  check ends here

  ///generate added message

  static createAddedMessage(String message,bool isMe){
    if(isNewUserAddedMessage(message)) return createUserAddedMessage(message, isMe);
    if(isGroupCreatedMessages(message)) return createGroupCreatedMessage(message, isMe);
  }


  static createUserAddedMessage(String message,isMe){
    List<String> chatMessage=message.split(MessageTypes.SOMEONE_IS_ADDED_TO_GROUP);
    return chatMessage[0]+" was added by "+chatMessage[chatMessage.length-1];
  }

  static createGroupCreatedMessage(String message,isMe){
    return "You have created a group";
  }



}