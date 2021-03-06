import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';



class MoviePlayer extends StatefulWidget {

  final String url;
  MoviePlayer(this.url);


  @override
  State<StatefulWidget> createState() {
    return _MoviePlayerState();
  }

}

class _MoviePlayerState extends State<MoviePlayer> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(
        widget.url);
    await Future.wait([
      _videoPlayerController.initialize()
    ]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: _chewieController != null &&
              _chewieController.videoPlayerController.value.isInitialized
              ? Chewie(
            controller: _chewieController,
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Loading'),
            ],
          ),
        ),
    );
  }
}