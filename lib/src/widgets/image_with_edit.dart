import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wively/src/data/models/room.dart';
import 'package:wively/src/data/models/user.dart';
import 'package:wively/src/values/Colors.dart';

import 'image_with_placeholder.dart';


class ImageWithEdit extends StatefulWidget {
  Room room;
  User user;
  ImageWithEdit({this.room,this.user});
  @override
  _ImageWithEditState createState() => _ImageWithEditState();
}

class _ImageWithEditState extends State<ImageWithEdit> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Center(child: ImageWithPlaceholder(widget.room!=null?widget.room?.profileUrl:widget.user?.profileUrl)),
          Positioned(child: IconButton(icon: Icon(Icons.edit,color: EColors.themePink,size: 30,),onPressed: (){
          },),bottom: -15,right: -20,)
        ],
      ),
    );
  }
}
