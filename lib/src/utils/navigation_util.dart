import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wively/src/utils/file_util.dart';
import 'package:wively/src/values/Colors.dart';

class NavigationUtil {
  static navigate(context, Widget destination) async {
    return await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft, child: destination));

    // return await Navigator.push(context, new MaterialPageRoute(
    //   builder: (context){
    //     return destination;
    //   },
    // ));
  }

  static navigateSlow(context, Widget destination) async {
    return await Navigator.push(
      context,
      PageRouteBuilder(
        fullscreenDialog: true,
        opaque: false,
        transitionDuration: Duration(milliseconds: 600),
        reverseTransitionDuration: Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => destination,
      ),
    );
  }

  static replace(context, Widget destination) async {
    return await Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (context) {
      return destination;
    }));
  }

  static goBack(context) async {
    return Navigator.pop(context);
  }

  static Future<String> openImageEditor(context) async {
    return await FileUtil.selectImageFromDevice();
  }
}
