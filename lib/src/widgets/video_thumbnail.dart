import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wively/src/utils/file_util.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/lottie_loader.dart';

class VideoThumbnail extends StatefulWidget {
  String url;

  VideoThumbnail(this.url);

  @override
  _VideoThumbnailState createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  Uint8List bytes;

  @override
  void initState() {
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (bytes == null) {
      return lottieLoader();
    }
    return ClipRRect(
        child:Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.memory(bytes, fit: BoxFit.cover),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRect(  // <-- clips to the 200x200 [Container] below
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5.0,
                    sigmaY: 5.0,
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                    child: Icon(Icons.play_arrow,color: EColors.white,),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  fetch() async {
    bytes = await FileUtil().getVideoThumbBytes(widget.url);
    setState(() {});
  }
}
