import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wively/src/utils/file_util.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/file_viewer.dart';
import 'package:wively/src/widgets/lottie_loader.dart';

class VideoThumbnail extends StatelessWidget {
  String url;
  bool showPlay;

  VideoThumbnail(this.url, {this.showPlay=false});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FileUtil().getVideoThumbBytes(url),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return lottieLoader();
          return ClipRRect(
              child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.memory(snapshot.data, fit: BoxFit.cover),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRect(
                  // <-- clips to the 200x200 [Container] below
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5.0,
                      sigmaY: 5.0,
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                      child: showPlay
                          ? Icon(
                              Icons.play_arrow,
                              color: EColors.white,
                            )
                          : Nothing(),
                    ),
                  ),
                ),
              ),
            ],
          ));
        });
  }
}
