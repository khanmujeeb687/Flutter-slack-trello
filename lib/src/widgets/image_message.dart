import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

class ImageMessage extends StatefulWidget {
  Message message;

  ImageMessage(this.message);

  @override
  _ImageMessageState createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage> {
  FileUploadController _fileUploadController;
  DownloadService _downloadService;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(widget.message.fileUploadState==EFileState.downloaded){
          NavigationUtil.navigateSlow(context, FullImage(widget.message.fileUrls));
        }
      },
      child: Hero(
        tag: widget.message.fileUrls,
        child: Material(
          color: EColors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: ScreenUtil.height(context) / 3,
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
                    child: () {
                      if (FileUtil.fileOriginType(widget.message.fileUrls) ==
                          EOrigin.local) {
                        return Image.file(File(widget.message.fileUrls),
                            fit: BoxFit.cover,
                            width: ScreenUtil.height(context) / 3);
                      } else {
                        return Stack(
                          children: [
                            Image.network(widget.message.fileUrls,
                                fit: BoxFit.cover,
                                width: ScreenUtil.height(context) / 3),
                            BackdropFilter(
                                filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                                child: Container(
                                  color: EColors.themeBlack.withOpacity(0.3),
                                )),
                          ],
                        );
                      }
                    }()),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: () {
                      if (widget.message.fileUploadState ==
                              EFileState.sending ||
                          widget.message.fileUploadState ==
                              EFileState.downloading) {
                        return CircularProgressIndicator();
                      } else if (widget.message.fileUploadState ==
                          EFileState.unsent) {
                        return IconButton(
                          onPressed: uploadImage,
                          icon: Icon(
                            Icons.upload_outlined,
                            color: EColors.white,
                            size: 40,
                          ),
                        );
                      } else if (widget.message.fileUploadState ==
                          EFileState.notdownloaded) {
                        return IconButton(
                          onPressed: downloadFile,
                          icon: Icon(
                            Icons.download_rounded,
                            color: EColors.white,
                            size: 40,
                          ),
                        );
                      }
                      return Container(width: 0, height: 0);
                    }(),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Center(child: () {
                    if (widget.message.fileUploadState == EFileState.sending) {
                      return IconButton(
                        onPressed: () {
                          _fileUploadController?.stopUpload();
                        },
                        icon: Icon(
                          Icons.close,
                          color: EColors.white,
                        ),
                      );
                    }
                    return Container(
                      height: 0,
                      width: 0,
                    );
                  }()),
                )
              ],
            ),
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
        new FileUploadController(MediaType.Image, widget.message);
    _fileUploadController.startUpload(updateLocalStatus);
  }

  @override
  void dispose() {
    _fileUploadController?.dispose();
    super.dispose();
  }

  void downloadFile() async {
    String filePath = await FileUtil.createImageName();
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
