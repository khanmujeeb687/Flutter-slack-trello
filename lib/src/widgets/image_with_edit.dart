import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wively/src/data/models/room.dart';
import 'package:wively/src/data/models/user.dart';
import 'package:wively/src/utils/file_util.dart';
import 'package:wively/src/values/Colors.dart';

import 'image_with_placeholder.dart';
import 'lottie_loader.dart';


class ImageWithEdit extends StatefulWidget {
  Room room;
  User user;
  bool loading;
  bool large;
  Function(String path) callback;
  ImageWithEdit(this.callback,{this.room,this.user,this.loading=false,this.large=false});
  @override
  _ImageWithEditState createState() => _ImageWithEditState();
}

class _ImageWithEditState extends State<ImageWithEdit> {

  double size;

  @override
  void initState() {
    if(widget.large){
      size=30;
    }else{
      size=25;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Center(child: ImageWithPlaceholder(widget.room!=null?widget.room?.profileUrl:widget.user?.profileUrl,size:size)),
          if(widget.loading)
            Positioned(left: 0,right: 0,top: 0,bottom: 0,child: lottieLoader(radius:13)),
          Positioned(child: IconButton(icon: Icon(Icons.edit,color: EColors.white,size: 30,),onPressed: () async{
            String path=await FileUtil.selectImageFromDevice();
            if(path!=null){
              widget.callback(path);
            }
          },),bottom: -10,right: -15,)
        ],
      ),
    );
  }
}
