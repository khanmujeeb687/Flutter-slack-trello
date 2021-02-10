import 'package:fluttertoast/fluttertoast.dart';
import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/data/repositories/chat_repository.dart';

class MessageController {
  ChatRepository _chatRepository = new ChatRepository();

  sendMessage(Message message, {String filesUri}) async {
    if (message.to_room == null) {
      // await _chatRepository.sendMessage(message.message, message.to,
      await _chatRepository.sendMessage('..', message.to,
          filesUri: filesUri);
    } else {
      await _chatRepository.sendMessageToRoom(
          // message.message, message.from, message.to_room,
          '..', message.from, message.to_room,
          filesUri: filesUri);
    }
  }
}
