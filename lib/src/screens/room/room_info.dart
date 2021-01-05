import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wively/src/screens/room/room_controller.dart';
import 'package:wively/src/widgets/collapsible_scaffold.dart';
import 'package:wively/src/widgets/custom_app_bar.dart';


class RoomInfoArguments{
  String roomId;
  RoomInfoArguments(this.roomId);
}

class RoomInfo extends StatefulWidget {
  static String routeName='/RouteInfo';
  RoomInfoArguments roomInfoArguments;
  RoomInfo(this.roomInfoArguments);

  @override
  _RoomInfoState createState() => _RoomInfoState();
}

class _RoomInfoState extends State<RoomInfo> {
  RoomController _roomController;

  @override
  void initState() {
    _roomController=new RoomController(context: context);
    _roomController.getRoomData(widget.roomInfoArguments.roomId);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Object>(
        stream: _roomController.streamController.stream,
        builder: (context, snapshot) {
          if(_roomController.loading){
           return Center(child: CupertinoActivityIndicator());
          }
         return  CollapsibleScaffold(
             _roomController.room.roomName,
              Container(),
              null
          );
        },
      ),
    );
  }
}
