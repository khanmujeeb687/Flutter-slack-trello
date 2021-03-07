import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wively/src/data/models/file_models.dart';
import 'package:wively/src/data/services/upload_service.dart';
import 'package:wively/src/utils/file_util.dart';
import 'package:wively/src/utils/message_utils.dart';
import 'package:wively/src/utils/screen_util.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/cache_image.dart';
import 'package:wively/src/widgets/video_thumbnail.dart';


class FileViewer extends StatelessWidget {
  String url;
  FileViewer(this.url);
  @override
  Widget build(BuildContext context) {
    if(url==null || url == '' || url =='null') return Nothing();
    MediaType mediaType=MessageUtil.getMediaTypeFromMessageType(MessageUtil.getTypeFromUrl(url));
    switch(mediaType){
      case MediaType.Document:
        return _doc();
      case MediaType.Video:
        return _video();
      case MediaType.Audio:
        return _audio();
      case MediaType.Image:
        return _image();

    }
    return Nothing();
  }


  _doc(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      color: EColors.themePink,
      width: 100,
      child: Icon(Icons.file_copy_outlined,size: 30),
    );
  }

  _audio(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      color: EColors.themePink,
      width: 100,
      child: Icon(Icons.audiotrack,size: 30),
    );
  }

  _video(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      color: EColors.themePink,
      width: 100,
      child: VideoThumbnail(url),
    );
  }

  _image(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      color: EColors.themePink,
      width: 100,
      child: FileUtil.fileOriginType(url)==EOrigin.local?Image.file(File(url),fit: BoxFit.cover,):CacheImage(url),
    );
  }



}


class Nothing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 0,height: 0,);
  }
}
