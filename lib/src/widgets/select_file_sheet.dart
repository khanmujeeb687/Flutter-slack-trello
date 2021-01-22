import 'package:flutter/material.dart';
import 'package:wively/src/utils/screen_util.dart';
import 'package:wively/src/values/Colors.dart';



class SelectFile extends StatefulWidget {
  Function(int index) onPress;
  SelectFile(this.onPress);
  @override
  _SelectFileState createState() => _SelectFileState();
}

class _SelectFileState extends State<SelectFile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25)),
        color: EColors.themeBlack,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      height: ScreenUtil.height(context)/4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              IconButton(
                color: EColors.themePink,
                icon: Icon(Icons.image,size: 50),
                onPressed: ()=>onPress(0),
              ),
              SizedBox(width: 50,),
              IconButton(
                color: EColors.themePink,
                icon: Icon(Icons.video_collection,size: 50,),
                onPressed: ()=>onPress(1),
              ),
            ],
          ),
          SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              IconButton(
                color: EColors.themePink,
                icon: Icon(Icons.file_copy_sharp,size: 50,),
                onPressed: ()=>onPress(2),
              ),
              SizedBox(width: 50,),
              IconButton(
                color: EColors.themePink,
                icon: Icon(Icons.contacts,size: 50,),
                onPressed: ()=>onPress(3),
              ),
            ],
          ),


        ],
      ),
    );
  }

  void onPress(int index) {
    widget.onPress(index);
  }
}
