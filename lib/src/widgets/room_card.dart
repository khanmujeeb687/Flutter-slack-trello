import 'package:flutter/material.dart';
import 'package:wively/src/data/models/room.dart';


class RoomCard extends StatelessWidget {
  Room room;
  Function(Room room) onPress;
  RoomCard({this.room,this.onPress});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
      // CircleAvatar(
      //   child: Text(),
      // ),
      ClipRRect(
        borderRadius: BorderRadius.circular(10.0),//or 15.0
        child: Container(
          height: 40.0,
          width: 40.0,
          color: Colors.blue,
          child: Center(
            child: Text(
              room.roomName[0].toUpperCase(),
              style: TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.blue,
                  fontSize: 20
              ),
            ),
          ),
        ),
      ),
      title: Text(room.roomName),
      subtitle: Text('createdBy ~'+room.createdBy.name),
      onTap: (){
      onPress(room);
      },
    );
  }
}
