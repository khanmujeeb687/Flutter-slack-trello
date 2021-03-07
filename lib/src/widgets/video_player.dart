import 'dart:io';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:wively/src/data/models/file_models.dart';
import 'package:wively/src/utils/file_util.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/lottie_loader.dart';



class VideoPlayer extends StatefulWidget {

  String url;
  String tag;
  VideoPlayer(this.url,this.tag);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {

  CachedVideoPlayerController _controller;


  @override
  void initState() {
    if(FileUtil.fileOriginType(widget.url)==EOrigin.local){
      _controller = new CachedVideoPlayerController.file(File(widget.url));
    }else{
      _controller = new CachedVideoPlayerController.network(widget.url);
    }

    _controller..initialize().then((value){
      _controller.setLooping(true);
      _controller.play();
      setState(() {});
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.tag,
      child: Material(
        color: EColors.transparent,
        child: Scaffold(
          appBar: AppBar(),
          body: (){
            if(_controller.value.initialized){
              return GestureDetector(
                onTap: (){
                  _controller.value.isPlaying?_controller.pause():_controller.play();
                },
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: CachedVideoPlayer(
                    _controller
                  ),
                ),
              );
            }

            return lottieLoader();
          }(),
        ),
      ),
    );
  }


  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
