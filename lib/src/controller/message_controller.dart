import 'package:fluttertoast/fluttertoast.dart';
import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/data/models/message_types.dart';
import 'package:wively/src/data/repositories/chat_repository.dart';

class MessageController {
  ChatRepository _chatRepository = new ChatRepository();

  sendMessage(Message message, {String filesUri}) async {
    if (message.to_room == null) {
      // await _chatRepository.sendMessage(message.message, message.to,
      await _chatRepository.sendMessage(MessageTypes.IMAGE_MESSAGE, message.to,
          filesUri: filesUri);
    } else {
      await _chatRepository.sendMessageToRoom(
          // message.message, message.from, message.to_room,
          MessageTypes.IMAGE_MESSAGE, message.from, message.to_room,
          filesUri: filesUri);
    }
  }
}
