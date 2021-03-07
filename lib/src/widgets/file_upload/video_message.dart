//latest

import 'dart:io';
import 'dart:ui';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:wively/src/controller/file_upload_controller.dart';
import 'package:wively/src/data/models/file_models.dart';
import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/data/providers/uploads_provider.dart';
import 'package:wively/src/data/services/download_service.dart';
import 'package:wively/src/data/services/upload_service.dart';
import 'package:wively/src/utils/file_util.dart';
import 'package:wively/src/utils/navigation_util.dart';
import 'package:wively/src/utils/screen_util.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/file_upload/file_message_controller.dart';
import 'package:wively/src/widgets/full_image.dart';
import 'package:wively/src/widgets/lottie_loader.dart';
import 'package:wively/src/widgets/video_player.dart';
import 'package:wively/src/widgets/video_thumbnail.dart';

class VideoMessage extends StatefulWidget {
  Message message;
  bool isMe;
  bool showNip;

  VideoMessage(this.message, this.isMe, this.showNip);

  @override
  _VideoMessageState createState() => _VideoMessageState();
}

class _VideoMessageState extends State<VideoMessage> {
  static FileUploadController _fileUploadController;
  DownloadService _downloadService;

  bool get initialized {
    return (widget.message.fileUploadState == EFileState.downloaded ||
        widget.message.fileUploadState == EFileState.sent ||
        widget.message.fileUploadState == EFileState.unsent);
  }

  @override
  void initState() {
    if (widget.message.fileUploadState == EFileState.downloading) {
      updateLocalStatus(EFileState.notdownloaded);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (initialized) {
            NavigationUtil.navigateSlow(context, VideoPlayer(widget.message.fileUrls,widget.message.sendAt.toString()));
            // OpenFile.open(widget.message.fileUrls);
          }
        },
        child: Stack(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
              ),
                constraints: BoxConstraints(
                  maxHeight: ScreenUtil.height(context) / 3,
                ),
                child: Hero(
                    tag: widget.message.sendAt.toString(),
                    child: Material(
                        color: EColors.transparent,
                        child: VideoThumbnail(widget.message.fileUrls,showPlay:showPlay())))),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: () {
                if (widget.message.fileUploadState == EFileState.sending) {
                  return Stack(
                    children: [
                      Center(
                        child: CircularProgressIndicator(
                          value: double.parse(
                                  Provider.of<UploadsProvider>(context)
                                      .tasks[widget.message.sendAt.toString()]
                                      ?.progress
                                      .toString()) /
                              100,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(EColors.white),
                          backgroundColor: EColors.themeGrey,
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<UploadsProvider>(context,
                                    listen: false)
                                .cancelUpload(
                                    widget.message.sendAt.toString());
                          },
                          child: Icon(
                            Icons.close,
                            color: EColors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                } else if ((widget.message.fileUploadState ==
                            EFileState.unsent)) {
                  return GestureDetector(
                    onTap: () {
                      Provider.of<UploadsProvider>(context, listen: false)
                          .uploadFile(
                              File(widget.message.fileUrls),
                              widget.message.sendAt.toString(),
                              widget.message);
                    },
                    child: Icon(
                      Icons.upload_outlined,
                      color: EColors.white,
                    ),
                  );
                } else if (widget.message.fileUploadState ==
                    EFileState.notdownloaded) {
                  return GestureDetector(
                    onTap: downloadFile,
                    child: Icon(
                      Icons.download_rounded,
                      color: EColors.white,
                    ),
                  );
                } else if (widget.message.fileUploadState ==
                    EFileState.downloading) {
                  return lottieLoader(radius: 15);
                }
                return SizedBox(
                  height: 0,
                  width: 0,
                );
              }(),
            ),
          ],
        ));
  }


  bool showPlay(){
    return (widget.message.fileUploadState==EFileState.sent || widget.message.fileUploadState==EFileState.downloaded);
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
        new FileUploadController(MediaType.Video, widget.message);
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
