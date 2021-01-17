import 'package:flutter/material.dart';


class ScreenUtil{


  static  height(BuildContext context)=> MediaQuery.of(context).size.height;
  static  width(BuildContext context)=> MediaQuery.of(context).size.width;

  static get appBarHeight=>new AppBar().preferredSize.height;


  static taskBoardListHeight(BuildContext context){
   return ScreenUtil.height(context)-ScreenUtil.appBarHeight-200;
  }
}