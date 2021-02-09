import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wively/src/utils/file_util.dart';

class NavigationUtil{




  static navigate(context,Widget destination)async{
    return await Navigator.push(context, new MaterialPageRoute(
      builder: (context){
        return destination;
      }
    ));
  }


  static replace(context,Widget destination)async{
    return await Navigator.pushReplacement(context, new MaterialPageRoute(
        builder: (context){
          return destination;
        }
    ));
  }

  static goBack(context)async{
    return Navigator.pop(context);
  }


  static Future<String> openImageEditor(context) async{
    return await FileUtil.selectImageFromDevice();
  }
}