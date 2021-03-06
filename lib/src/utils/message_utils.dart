import 'package:wively/src/data/models/message_types.dart';
import 'package:path/path.dart';
import 'package:wively/src/data/services/upload_service.dart';

class MessageUtil{
  static String getMessageType(String message){
    switch(message){
      case MessageTypes.IMAGE_MESSAGE:
        return MessageTypes.IMAGE_MESSAGE;
      case MessageTypes.DOC_MESSAGE:
        return MessageTypes.DOC_MESSAGE;
      case MessageTypes.VIDEO_MESSAGE:
        return MessageTypes.VIDEO_MESSAGE;
      case MessageTypes.AUDIO_MESSAGE:
        return MessageTypes.AUDIO_MESSAGE;
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
    if(exten.contains('mp3')) return MessageTypes.AUDIO_MESSAGE;
    return MessageTypes.DOC_MESSAGE;
  }

  static getMessageTypeFromMediaType(MediaType mediaType) {

    switch(mediaType){
      case MediaType.Audio:
        return MessageTypes.AUDIO_MESSAGE;
      case MediaType.Video:
        return MessageTypes.VIDEO_MESSAGE;
      case MediaType.Document:
        return MessageTypes.DOC_MESSAGE;
      case MediaType.Image:
        return MessageTypes.IMAGE_MESSAGE;
    }
  }


  static getMediaTypeFromMessageType(String messageType){
    switch(messageType){
      case MessageTypes.AUDIO_MESSAGE:
        return MediaType.Audio;
      case MessageTypes.VIDEO_MESSAGE:
        return MediaType.Video;
      case MessageTypes.DOC_MESSAGE:
        return MediaType.Document;
      case MessageTypes.IMAGE_MESSAGE:
        return MediaType.Image;
    }
  }

}