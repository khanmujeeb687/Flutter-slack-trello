import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/values/assets.dart';

Widget lottieLoader({double radius=20}){
  return Center(
    // child: Lottie.asset(Assets.loading,width: 50,height: 50),
    // child: CupertinoActivityIndicator(animating: true),
    child: NutsActivityIndicator(
      relativeWidth: 0.5,
      radius: radius,
      activeColor: EColors.themePink,
      inactiveColor: EColors.themeGrey,
      tickCount: 15,
      startRatio: 0.55,
      animationDuration: Duration(milliseconds: 700),
    ),
  );
}