import 'package:flutter/material.dart';
import 'package:wively/src/values/Colors.dart';

Widget ESquareButton(String text,{VoidCallback onPressed}){
  return RaisedButton(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6)
    ),
    color: EColors.themePink,
    onPressed: onPressed,
    child: Text(text,style: TextStyle(color: EColors.white),maxLines: 1,overflow: TextOverflow.ellipsis,),
  );
}