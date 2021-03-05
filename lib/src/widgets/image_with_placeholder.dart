import 'package:flutter/material.dart';
import 'package:wively/src/utils/navigation_util.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/cache_image.dart';
import 'package:wively/src/widgets/full_image.dart';

enum EPlaceholderType{
  user,
  room
}

class ImageWithPlaceholder extends StatelessWidget {
  String uri;
  EPlaceholderType placeholderType;
  double size;
  ImageWithPlaceholder(this.uri,{this.placeholderType=EPlaceholderType.user,this.size=25});

  hasUri(){
    return uri!=null && uri!="null" && uri!='';
  }

  @override
  Widget build(BuildContext context) {
    if(size==25){
      return  CircleAvatar(
        radius: 20,
        backgroundImage: !hasUri()?null:NetworkImage(this.uri),
        backgroundColor: EColors.themePink,
        child: !hasUri()?Icon(placeholderType==EPlaceholderType.room?Icons.supervised_user_circle:Icons.account_circle,color: EColors.white,):
        null,
      );
    }
    return InkWell(
      onTap: (){
        if(hasUri()){
          NavigationUtil.navigateSlow(context, FullImage(uri));
        }
      },
      child: Hero(
        tag:  hasUri()?uri:UniqueKey().toString(),
        child: Material(
          clipBehavior: Clip.hardEdge,
          color: EColors.transparent,
          child: CircleAvatar(
            radius: size,
            backgroundImage: !hasUri()?null:NetworkImage(this.uri),
            backgroundColor: EColors.themePink,
            child: !hasUri()?Icon(placeholderType==EPlaceholderType.room?Icons.supervised_user_circle:Icons.account_circle,color: EColors.white,):
            null,
          ),
        ),
      ),
    );
  }
}
