import 'package:flutter/material.dart';
import 'package:wively/src/values/Colors.dart';

class DarkRegular{

  static getTheme(context){
    return ThemeData(
        primaryColor: EColors.themeMaroon,
        accentColor: EColors.themeGrey,
        scaffoldBackgroundColor: EColors.themeBlack,
        cursorColor: EColors.themeMaroon,
        appBarTheme: AppBarTheme().copyWith(
            color: EColors.themeMaroon,
            iconTheme: IconThemeData(color: EColors.themeGrey),
            textTheme: TextTheme().copyWith(
                title: Theme.of(context).primaryTextTheme.title.copyWith(color: EColors.themeGrey)
            )
        )
    );
  }
}