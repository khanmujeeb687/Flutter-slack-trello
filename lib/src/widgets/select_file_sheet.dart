import 'package:flutter/material.dart';
import 'package:wively/src/data/models/file_models.dart';
import 'package:wively/src/utils/screen_util.dart';
import 'package:wively/src/values/Colors.dart';

class SelectFile extends StatefulWidget {
  Function(ESelectedFileType selectedFileType) onPress;

  SelectFile(this.
  onPress);

  @override
  _SelectFileState createState() => _SelectFileState();
}

class _SelectFileState extends State<SelectFile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), topLeft: Radius.circular(25)),
          color: EColors.themeBlack,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        height: ScreenUtil.height(context) / 3,
        child: GridView.count(
          crossAxisCount: 3,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Icon(Icons.image, size: 50, color: EColors.themePink),
                  onTap: () => onPress(ESelectedFileType.Image),
                ),
                Text("Image", style: TextStyle(color: EColors.themeGrey))
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Icon(Icons.video_call, size: 50, color: EColors.themePink),
                  onTap: () => onPress(ESelectedFileType.Video),
                ),
                Text("Video", style: TextStyle(color: EColors.themeGrey))
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Icon(Icons.audiotrack, size: 50, color: EColors.themePink),
                  onTap: () => onPress(ESelectedFileType.Audio),
                ),
                Text("Music", style: TextStyle(color: EColors.themeGrey))
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Icon(Icons.file_present, size: 50, color: EColors.themePink),
                  onTap: () => onPress(ESelectedFileType.document),
                ),
                Text("Document", style: TextStyle(color: EColors.themeGrey))
              ],
            ),
          ],
        ));
  }

  void onPress(ESelectedFileType selectedFileType) {
    widget.onPress(selectedFileType);
  }
}
