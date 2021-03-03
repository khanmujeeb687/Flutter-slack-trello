import 'package:flutter/material.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/cache_image.dart';

enum EPlaceholderType{
  user,
  room
}

class ImageWithPlaceholder extends StatelessWidget {
  String uri;
  EPlaceholderType placeholderType;
  ImageWithPlaceholder(this.uri,{this.placeholderType=EPlaceholderType.user});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: EColors.themeBlack,
      child: uri==null || uri==''?Icon(placeholderType==EPlaceholderType.room?Icons.supervised_user_circle:Icons.account_circle,color: EColors.white,):CacheImage(this.uri),
    );
  }
}
