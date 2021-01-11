import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/values/assets.dart';

import 'lottie_loader.dart';

class LoaderDialogManager{
  static bool dialogVisible=false;
  static BuildContext context;

  static showLoader(BuildContext context,{bool cancellable=false}) async{
    if(dialogVisible) return;
    dialogVisible=true;
    LoaderDialogManager.context=context;
   await showDialog(
      barrierDismissible: cancellable,
      context: context,
      builder: (context){
        return WillPopScope(
          onWillPop: (){
            return Future.value(cancellable);
          },
          child: AlertDialog(
            elevation: 0,
            backgroundColor: EColors.transparent,
            title: lottieLoader()
          ),
        );
      }
    );
   dialogVisible=false;
  }

 static hideLoader(){
    if(dialogVisible && context!=null){
      Navigator.pop(context);
      dialogVisible=false;
    }
  }

}
