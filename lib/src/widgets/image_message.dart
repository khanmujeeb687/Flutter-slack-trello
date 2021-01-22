import 'package:flutter/material.dart';
import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/cache_image.dart';


class ImageMessage extends StatefulWidget {
  Message message;
  ImageMessage(this.message);
  @override
  _ImageMessageState createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage> {



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: EColors.themeMaroon,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CacheImage("https://www.gstatic.com/tv/thumb/persons/983712/983712_v9_ba.jpg") ,
          )
        ],
      ),
    );
  }
}
