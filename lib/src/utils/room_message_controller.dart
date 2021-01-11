import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/data/providers/chats_provider.dart';

class RoomMessageController{
  informMe(BuildContext context,Map<String, dynamic> message) async{
    final newMessage = Message(
      roomId: message['roomId'],
      from: message['from']['_id'],
      to_room:  message['roomId'],
      message: message['message'],
      sendAt: DateTime.now().millisecondsSinceEpoch,
      unreadByMe: false,
    );
    await Provider.of<ChatsProvider>(context, listen: false).addMessageToChat(newMessage);
  }

  static createAddedMessage(String message,bool isMe){
    return isMe?message.split("_IS_ADDED_BY_")[0]+" was added by you":message.replaceAll("_IS_ADDED_BY_", " was added by ");
  }
  static bool isAddedMessage(String message){
    return message.contains('_IS_ADDED_BY_');
  }

}