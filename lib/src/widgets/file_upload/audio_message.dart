import 'dart:io';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
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

class AudioMessage extends StatefulWidget {
  Message message;
  bool isMe;
  bool showNip;

  AudioMessage(this.message, this.isMe, this.showNip);

  @override
  _AudioMessageState createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  static FileUploadController _fileUploadController;
  DownloadService _downloadService;
  AudioPlayer audioPlayer;
  bool playing = false;

  @override
  void initState() {
    if(widget.message.fileUploadState==EFileState.sending){
      updateLocalStatus(EFileState.unsent);
    }else if(widget.message.fileUploadState==EFileState.downloading){
      updateLocalStatus(EFileState.notdownloaded);
    }
    super.initState();
  }

  bool get initialized{
    return ( widget.message.fileUploadState==EFileState.downloaded
        || widget.message.fileUploadState==EFileState.sent
        || widget.message.fileUploadState==EFileState.unsent
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (initialized) {
          if(playing){
            pauseAudio();
          }else{
            playAudio();
          }
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
              Icon(Icons.audiotrack, color: EColors.themeBlack),
              SizedBox(
                width: 6,
              ),
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
                } else if (widget.message.fileUploadState ==
                    EFileState.unsent) {
                  return GestureDetector(
                    onTap: uploadImage,
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
                else if (widget.message.fileUploadState ==
                    EFileState.downloaded || widget.message.fileUploadState ==
                    EFileState.sent) {
                  if(audioPlayer!=null && playing){
                    return GestureDetector(
                      onTap: pauseAudio,
                      child: Icon(
                        Icons.pause,
                        color: EColors.white,
                      ),
                    );
                  }else{
                    return GestureDetector(
                      onTap: playAudio,
                      child: Icon(
                        Icons.play_arrow,
                        color: EColors.white,
                      ),
                    );
                  }

                }
                return SizedBox(height: 0, width: 0);
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
        new FileUploadController(MediaType.Audio, widget.message);
    _fileUploadController.startUpload(updateLocalStatus);
  }

  @override
  void dispose() {
    audioPlayer?.dispose();
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

  playAudio() async {
    pauseAudio();
    audioPlayer?.dispose();
    audioPlayer = AudioPlayer();
    audioPlayer.play(widget.message.fileUrls,
        isLocal:
            FileUtil.fileOriginType(widget.message.fileUrls) == EOrigin.local);
    setState(() {
      playing=true;
    });
  }

  pauseAudio() async {
    audioPlayer?.stop();
    setState(() {
      playing=false;
    });
  }



  Future<void> updateFilePath(String filePath) async {
    await Provider.of<ChatsProvider>(context, listen: false)
        .updateMessageFilePath(widget.message.localId, filePath);
    setState(() {
      widget.message.fileUrls = filePath;
    });
  }


}
