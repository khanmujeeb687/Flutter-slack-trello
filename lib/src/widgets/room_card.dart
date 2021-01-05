import 'package:flutter/material.dart';
import 'package:wively/src/data/models/room.dart';


class RoomCard extends StatelessWidget {
  Room room;
  Function(Room room) onPress;
  RoomCard({this.room,this.onPress});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(room.roomName[0]),
      ),
      title: Text(room.roomName),
      subtitle: Text('createdBy ~'+room.admins[0].name),
      onTap: (){
      onPress(room);
      },
    );
  }
}
