import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wively/src/data/models/chat.dart';
import 'package:wively/src/data/models/room.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/screens/contact/contact_view.dart';
import 'package:wively/src/screens/room/room_controller.dart';
import 'package:wively/src/widgets/custom_app_bar.dart';
import 'package:wively/src/widgets/lottie_loader.dart';
import 'package:wively/src/widgets/room_card.dart';
import 'package:wively/src/widgets/user_card.dart';


class RoomScreen extends StatefulWidget {
  static final String routeName = "/room";

  String parentId;
  RoomScreen({this.parentId});

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  RoomController _roomController;

  @override
  void initState() {
    super.initState();
    _roomController = RoomController(context: context);
    _roomController.getRooms(widget.parentId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: _roomController.streamController.stream,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: CustomAppBar(
            title: Text(_roomController.loading ? 'loading...' : 'Rooms'),
          ),
          body: SafeArea(
            child: roomList(context),
          ),
        );
      },
    );
  }


  Widget roomList(BuildContext context) {

    if (_roomController.loading) {
      return Center(
        child: lottieLoader(),
      );
    }
    if (_roomController.rooms.length == 0) {
      return Center(
        child: Text('There are no rooms available!'),
      );
    }
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: _roomController.rooms.map((room) {
            return RoomCard(
              onPress:_roomController.newRoomChat,
              room: room);
          }).toList(),
        );
      },
    );
  }
}
