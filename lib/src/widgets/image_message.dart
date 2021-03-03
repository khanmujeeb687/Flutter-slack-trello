import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wively/src/controller/message_controller.dart';
import 'package:wively/src/data/models/file_models.dart';
import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/data/services/upload_service.dart';
import 'package:wively/src/utils/file_util.dart';
import 'package:wively/src/utils/navigation_util.dart';
import 'package:wively/src/utils/screen_util.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/cache_image.dart';
import 'package:wively/src/widgets/full_image.dart';

class ImageMessage extends StatefulWidget {
  Message message;

  ImageMessage(this.message);

  @override
  _ImageMessageState createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage> {
  UploadService _uploadService;
  MessageController _messageController=new MessageController();

  @override
  void initState() {
    if(widget.message.fileUploadState==EFileState.sending){
      uploadImage();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        NavigationUtil.navigate(context, FullImage(widget.message.fileUrls));
      },
      child: Hero(
        tag: widget.message.fileUrls,
        child: Material(
          color: EColors.transparent,
          child: Container(
            height: ScreenUtil.height(context)/3,
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            // alignment: Alignment.center,
            child: Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: (){
                      if(FileUtil.fileOriginType(widget.message.fileUrls)==EOrigin.local){
                        return Image.file(File(widget.message.fileUrls),fit: BoxFit.cover,width: ScreenUtil.height(context)/3);
                      }else{
                        return Image.network(widget.message.fileUrls,fit: BoxFit.cover,width: ScreenUtil.height(context)/3);
                      }
                    }()),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: (){
                      if(widget.message.fileUploadState==EFileState.sending) {
                        return CircularProgressIndicator();
                      }
                      else if (widget.message.fileUploadState==EFileState.unsent){
                        return IconButton(
                          onPressed: uploadImage,
                          icon: Icon(Icons.upload_outlined,color: EColors.white,size: 40,),
                        );
                      }
                      return Container(width: 0,height: 0);
                    }(),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: (){
                      if(widget.message.fileUploadState==EFileState.sending){
                        return IconButton(
                          onPressed: stopUpload,
                          icon: Icon(Icons.close,color: EColors.white,),
                        );
                      }
                      return Container(height: 0,width: 0,);
                    }()
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateLocalStatus(EFileState fileState)async{
    Provider.of<ChatsProvider>(context, listen: false).updateMessageState(widget.message.localId,fileState);
    setState(() {
      widget.message.fileUploadState=fileState;
    });
  }

  void uploadImage() async{
     await stopUpload();
     await updateLocalStatus(EFileState.sending);
    _uploadService=new UploadService(File(widget.message.fileUrls), 'sending file to Mujeeb khan', MediaType.Image);
    _uploadService.uploadFile(onError,onSuccess,onProgress);
  }

  @override
  void dispose() {
    _uploadService?.removeSubscriptions();
    super.dispose();
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
    Fluttertoast.showToast(msg: 'Error sending file');
    stopUpload();
    updateLocalStatus(EFileState.unsent);
    print("Error is ${error}");
  }

  onSuccess(String fileUrl) {
    updateLocalStatus(EFileState.sent);
    _messageController.sendMessage(widget.message,filesUri:fileUrl);
  }

}
