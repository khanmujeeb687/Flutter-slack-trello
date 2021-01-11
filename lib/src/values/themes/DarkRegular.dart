import 'package:flutter/material.dart';
import 'package:wively/src/values/Colors.dart';

class DarkRegular{

  static getTheme(context){
    return ThemeData(
      hintColor: EColors.themeGrey,
        primaryColor: EColors.themePink,
        accentColor: EColors.themeGrey,
        scaffoldBackgroundColor: EColors.themeBlack,
        cursorColor: EColors.themeMaroon,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: EColors.themeGrey
          ),color: EColors.themeMaroon,
          textTheme: TextTheme(
            title: TextStyle(
              color: EColors.white
            )
          )
        )
    );
  }
}