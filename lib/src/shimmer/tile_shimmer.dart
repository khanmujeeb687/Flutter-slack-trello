import 'package:flutter/material.dart';
import 'package:wively/src/values/Colors.dart';


class TileShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(),
      title: Container(color: EColors.themeGrey,height: 10,margin: EdgeInsets.only(bottom: 5),) ,
      subtitle: Container(color: EColors.themeGrey,height: 6,margin: EdgeInsets.only(bottom: 5),) ,
    );
  }
}
