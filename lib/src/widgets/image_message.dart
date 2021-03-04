import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wively/src/controller/file_upload_controller.dart';
import 'package:wively/src/controller/message_controller.dart';
import 'package:wively/src/data/models/file_models.dart';
import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/data/services/upload_service.dart';
import 'package:wively/src/utils/file_util.dart';
import 'package:wively/src/utils/navigation_util.dart';
import 'package:wively/src/utils/screen_util.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/full_image.dart';

class ImageMessage extends StatefulWidget {
  Message message;

  ImageMessage(this.message);

  @override
  _ImageMessageState createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage> {
  FileUploadController _fileUploadController;

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
            constraints: BoxConstraints(
              maxHeight: ScreenUtil.height(context)/3,
          ),
            padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
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
                          onPressed: _fileUploadController?.stopUpload,
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
    _fileUploadController=new FileUploadController(MediaType.Image, widget.message);
    _fileUploadController.startUpload(updateLocalStatus);
  }

  @override
  void dispose() {
    _fileUploadController?.dispose();
    super.dispose();
  }


}
