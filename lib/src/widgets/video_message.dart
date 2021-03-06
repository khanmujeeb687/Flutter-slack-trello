import 'dart:io';
import 'dart:ui';

import 'package:bubble/bubble.dart';
import 'package:cached_video_player/cached_video_player.dart';
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
import 'package:wively/src/utils/message_utils.dart';
import 'package:wively/src/utils/navigation_util.dart';
import 'package:wively/src/utils/screen_util.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/full_image.dart';
import 'package:wively/src/widgets/lottie_loader.dart';

class VideoMessage extends StatefulWidget {
  Message message;
  bool isMe;
  bool showNip;

  VideoMessage(this.message,[this.isMe, this.showNip]);

  @override
  _VideoMessageState createState() => _VideoMessageState();
}

class _VideoMessageState extends State<VideoMessage> {
  FileUploadController _fileUploadController;
  DownloadService _downloadService;
  CachedVideoPlayerController _cachedVideoPlayer;

  @override
  void initState() {
    if(FileUtil.fileOriginType(widget.message.fileUrls)==EOrigin.remote){
      _cachedVideoPlayer =
      CachedVideoPlayerController.network(widget.message.fileUrls)
        ..initialize().then((_) {
          _cachedVideoPlayer.setLooping(true);
          setState(() {});
        });
    }else{
      _cachedVideoPlayer =
      CachedVideoPlayerController.file(new File(widget.message.fileUrls))
        ..initialize().then((_) {
          _cachedVideoPlayer.setLooping(true);
          setState(() {});
        });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.message.fileUploadState == EFileState.downloaded ||
            widget.message.fileUploadState == EFileState.sent) {
          togglePlayPause(!_cachedVideoPlayer.value.isPlaying);
        }
      },
      child: Container(
        padding: EdgeInsets.all(6),
        child: Stack(
          children: [
            _cachedVideoPlayer.value.initialized
                ? AspectRatio(
              aspectRatio: _cachedVideoPlayer.value.aspectRatio,
              child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: CachedVideoPlayer(_cachedVideoPlayer)),
            )
                : Container(),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: () {
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
                            size: 35,
                            color: EColors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (widget.message.fileUploadState ==
                    EFileState.unsent) {
                  return GestureDetector(
                    onTap: uploadImage,
                    child: Icon(
                      Icons.upload_outlined,
                      color: EColors.white,
                      size: 35,
                    ),
                  );
                } else if (widget.message.fileUploadState ==
                    EFileState.notdownloaded) {
                  return GestureDetector(
                    onTap: downloadFile,
                    child: Icon(
                      Icons.download_rounded,
                      color: EColors.white,
                      size: 35,
                    ),
                  );
                } else if (widget.message.fileUploadState ==
                    EFileState.downloading) {
                  return lottieLoader(radius: 15);
                }
                else if(_cachedVideoPlayer.value.initialized && !_cachedVideoPlayer.value.isPlaying){
                  return GestureDetector(
                    onTap: (){
                      togglePlayPause(true);
                    },
                    child: Icon(
                      Icons.play_arrow,
                      color: EColors.white,
                      size: 35,
                    ),
                  );
                }
                return SizedBox(
                  height: 0,
                  width: 0,
                );
              }(),
            ),
          ],
        ),
      ),
    );
  }

  togglePlayPause(bool value){
    setState(() {
      value?_cachedVideoPlayer.play():_cachedVideoPlayer.pause();
    });
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
    _cachedVideoPlayer?.dispose();
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
