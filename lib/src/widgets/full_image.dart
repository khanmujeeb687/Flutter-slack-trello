import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:wively/src/data/models/file_models.dart';
import 'package:wively/src/utils/file_util.dart';
import 'package:wively/src/values/Colors.dart';


class FullImage extends StatefulWidget {
  String url;
  FullImage(this.url);
  @override
  _FullImageState createState() => _FullImageState();
}

class _FullImageState extends State<FullImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:EColors.themeBlack,
      body: Hero(
        tag: widget.url,
        child: Material(
          color: EColors.transparent,
          child: Container(
              child: PhotoView(
                imageProvider:(){
                  if(FileUtil.fileOriginType(widget.url)==EOrigin.local){
                   return FileImage(new File(widget.url));
                  }
                  return NetworkImage(widget.url);
                }()
              )
          ),
        ),
      ),
    );
  }
}

