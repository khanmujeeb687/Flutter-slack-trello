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
  @override
  Widget build(BuildContext context) {
    if(size==25){
      return CircleAvatar(
        radius: size,
        backgroundColor: EColors.themeMaroon,
        child: uri==null || uri==''?Icon(placeholderType==EPlaceholderType.room?Icons.supervised_user_circle:Icons.account_circle,color: EColors.white,):ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(size),
            child: CacheImage(this.uri)),
      );
    }
    return Card(
      color: EColors.transparent,
      shadowColor: EColors.themeGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size),
      ),
      elevation: 10,
      child: InkWell(
        onTap: (){
          if(uri!=null && uri!=''){
            NavigationUtil.navigate(context, FullImage(uri));
          }
        },
        child: Hero(
          tag: uri,
          child: Material(
            clipBehavior: Clip.hardEdge,
            color: EColors.transparent,
            child: CircleAvatar(
              radius: size,
              backgroundImage: NetworkImage(this.uri),
              backgroundColor: EColors.themePink,
              child: uri==null || uri==''?Icon(placeholderType==EPlaceholderType.room?Icons.supervised_user_circle:Icons.account_circle,color: EColors.white,):
              null,
            ),
          ),
        ),
      ),
    );
  }
}
