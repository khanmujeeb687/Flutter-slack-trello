import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wively/src/shimmer/tile_shimmer.dart';
import 'package:wively/src/utils/screen_util.dart';
import 'package:wively/src/values/Colors.dart';


class TaskBoardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: ScreenUtil.width(context)*.9,
      maxHeight: ScreenUtil.height(context),
      child: Shimmer.fromColors(
        period: Duration(milliseconds: 600),
        baseColor: EColors.themeMaroon,
        highlightColor: EColors.themeGrey,
        child: ListView.builder(
          itemCount: 5,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            return TileShimmer();
          }
        ),
      ),
    );
  }
}
