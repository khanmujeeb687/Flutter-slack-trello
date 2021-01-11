import 'package:flutter/material.dart';
import 'package:wively/src/data/models/room.dart';
import 'package:wively/src/values/Colors.dart';


class RoomCard extends StatelessWidget {
  Room room;
  Function(Room room) onPress;
  RoomCard({this.room,this.onPress});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: EColors.white,
        child: Text(room.roomName[0].toUpperCase(),style: TextStyle(
          color: EColors.themeMaroon
        ),),
      ),
      title: Text(room.roomName,style: TextStyle(
        color: EColors.themeGrey,
        fontWeight: FontWeight.bold
      ),),
      subtitle: Text('createdBy ~'+room.createdBy.name,style: TextStyle(
          color: EColors.themeGrey,
      ),),
      onTap: (){
      onPress(room);
      },
    );
  }
}
