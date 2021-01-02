import 'package:flutter/material.dart';
import 'package:wively/src/screens/room/room_controller.dart';


class RoomScreen extends StatefulWidget {
  static final String routeName = "/room";

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  RoomController _roomController;

  @override
  void initState() {
    super.initState();
    _roomController = RoomController(context: context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }
}
