import 'package:wively/src/data/models/message_types.dart';
import 'package:path/path.dart';

class MessageUtil{
  static String getMessageType(String message){
    switch(message){
      case MessageTypes.IMAGE_MESSAGE:
        return MessageTypes.IMAGE_MESSAGE;
      case MessageTypes.DOC_MESSAGE:
        return MessageTypes.DOC_MESSAGE;
      case MessageTypes.VIDEO_MESSAGE:
        return MessageTypes.VIDEO_MESSAGE;
      default:
        return null;
    }
  }


  static bool isTextMessage(String message){
    return getMessageType(message)==null;
  }

  static String getTypeFromUrl(String url){
    String exten=extension(url);
    if(exten.contains('jpeg')) return MessageTypes.IMAGE_MESSAGE;
    if(exten.contains('mp4')) return MessageTypes.VIDEO_MESSAGE;
    return MessageTypes.DOC_MESSAGE;
  }

}