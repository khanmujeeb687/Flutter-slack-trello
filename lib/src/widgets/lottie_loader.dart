import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wively/src/values/assets.dart';

Widget lottieLoader(){
  return Center(
    child: Lottie.asset(Assets.loading,width: 50,height: 50),
  );
}