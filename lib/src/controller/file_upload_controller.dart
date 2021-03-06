import 'dart:io';

import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wively/src/data/models/file_models.dart';
import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/data/models/message_types.dart';
import 'package:wively/src/data/services/upload_service.dart';
import 'package:wively/src/utils/file_util.dart';
import 'package:wively/src/utils/message_utils.dart';

import 'message_controller.dart';

enum FileUploadResult{
  success,
  failed,
}

class FileUploadController{

  MessageController _messageController=new MessageController();
  UploadService _uploadService;

  Function(EFileState state) updateLocalStatus;

  Message message;
  MediaType mediaType;
  File file;

  FileUploadController(MediaType mediaType,Message message){
    this.message=message;
    this.mediaType=mediaType;
    this.file=File(mediaType==MediaType.Image?
    FileUtil.getThumbPath(message.fileUrls):message.fileUrls);
    _uploadService= new UploadService(this.file, '', mediaType);
  }


  startUpload(Function(EFileState state) updateLocalStatus) async{
    this.updateLocalStatus=updateLocalStatus;
   await stopUpload();
   await updateLocalStatus(EFileState.sending);
   _uploadService.uploadFile(onError,onSuccess,onProgress);
  }



  Future<void> stopUpload() async{
    _uploadService?.removeSubscriptions();
    await _uploadService?.cancelUpload(_uploadService?.taskId);
    await updateLocalStatus(EFileState.unsent);
  }

  onProgress(UploadTaskProgress progress) {
    print("Progress is : ${progress.progress}");
  }

  onError(String error) {
    stopUpload();
    updateLocalStatus(EFileState.unsent);
    print("Error is ${error}");
  }

  onSuccess(String fileUrl) {
     updateLocalStatus(EFileState.sent);

     var typeText='';

     switch(mediaType){
       case MediaType.Image:
         typeText=MessageTypes.IMAGE_MESSAGE;
         break;
       case MediaType.Video:
         typeText=MessageTypes.VIDEO_MESSAGE;
         break;
       case MediaType.Document:
         typeText=MessageTypes.DOC_MESSAGE;
         break;
       case MediaType.Audio:
         typeText=MessageTypes.AUDIO_MESSAGE;
         break;
     }


    _messageController.sendMessage(message,typeText,filesUri:fileUrl);

    if(mediaType==MediaType.Image){
      this.file=File(message.fileUrls);
      _uploadService= new UploadService(this.file, '', mediaType);
      _uploadService.uploadFile((error) => null, (fileUrl) => null, (progress) => null);
    }
  }


  dispose(){
    _uploadService?.removeSubscriptions();
  }


}