import 'dart:io';
import 'dart:ui';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:wively/src/controller/file_upload_controller.dart';
import 'package:wively/src/data/models/file_models.dart';
import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/data/services/download_service.dart';
import 'package:wively/src/data/services/upload_service.dart';
import 'package:wively/src/utils/file_util.dart';
import 'package:wively/src/utils/navigation_util.dart';
import 'package:wively/src/utils/screen_util.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/full_image.dart';
import 'package:wively/src/widgets/lottie_loader.dart';

class FileMessage extends StatefulWidget {
  Message message;
  bool isMe;
  bool showNip;

  FileMessage(this.message, this.isMe, this.showNip);

  @override
  _FileMessageState createState() => _FileMessageState();
}

class _FileMessageState extends State<FileMessage> {
  static FileUploadController _fileUploadController;
  DownloadService _downloadService;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.message.fileUploadState==EFileState.downloaded){
          OpenFile.open(widget.message.fileUrls);
        }
      },
      child: Bubble(
        shadowColor: EColors.transparent,
        radius: Radius.circular(15),
        alignment: widget.isMe ? Alignment.topRight : Alignment.topLeft,
        color: EColors.themePink.withOpacity(0.5),
        child: Container(
          padding: EdgeInsets.all(6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.file_copy_rounded, color: EColors.themeBlack),
              SizedBox(width: 6,),
              Expanded(
                  child: Text(
                    FileUtil.getFileName(widget.message.fileUrls),
                    style: TextStyle(color: EColors.white, fontSize: 12),
                  )),
                  () {
                if (widget.message.fileUploadState == EFileState.sending) {
                  return Stack(
                    children: [
                      lottieLoader(radius: 15),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            _fileUploadController?.stopUpload();
                          },
                          child: Icon(
                            Icons.close,
                            color: EColors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                else if (widget.message.fileUploadState == EFileState.unsent) {
                  return GestureDetector(
                    onTap: uploadImage,
                    child: Icon(
                      Icons.upload_outlined,
                      color: EColors.white,
                    ),
                  );
                }
                else
                if (widget.message.fileUploadState == EFileState.notdownloaded) {
                  return GestureDetector(
                    onTap: downloadFile,
                    child: Icon(
                      Icons.download_rounded,
                      color: EColors.white,
                    ),
                  );
                }
                else
                if (widget.message.fileUploadState == EFileState.downloading) {
                  return lottieLoader(radius: 15);
                }
                return SizedBox(height: 0,width: 0
                ,
                );
              }()

            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateLocalStatus(EFileState fileState) async {
    Provider.of<ChatsProvider>(context, listen: false)
        .updateMessageState(widget.message.localId, fileState);
    setState(() {
      widget.message.fileUploadState = fileState;
    });
  }

  void uploadImage() async {
    _fileUploadController =
    new FileUploadController(MediaType.Document, widget.message);
    _fileUploadController.startUpload(updateLocalStatus);
  }

  @override
  void dispose() {
    _fileUploadController?.dispose();
    super.dispose();
  }

  void downloadFile() async {
    String filePath = await FileUtil.createPathFromUrl(widget.message.fileUrls);
    updateLocalStatus(EFileState.downloading);
    _downloadService = new DownloadService();
    var res = await _downloadService.downloadFile(
        widget.message.fileUrls.replaceAll('-alfa', ''), filePath);
    if (res == null) {
      updateLocalStatus(EFileState.notdownloaded);
    } else {
      updateLocalStatus(EFileState.downloaded);
      updateFilePath(filePath);
    }
  }

  Future<void> updateFilePath(String filePath) async {
    await Provider.of<ChatsProvider>(context, listen: false)
        .updateMessageFilePath(widget.message.localId, filePath);
    setState(() {
      widget.message.fileUrls = filePath;
    });
  }
}
