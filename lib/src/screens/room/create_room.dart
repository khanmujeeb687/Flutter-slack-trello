import 'package:flutter/material.dart';
import 'package:wively/src/data/repositories/room_repository.dart';
import 'package:wively/src/widgets/custom_app_bar.dart';
import 'package:wively/src/widgets/text_field_with_button.dart';


class CreateRoom extends StatefulWidget {
  static final String routeName = "/create_room";
  String roomId;
  CreateRoom({this.roomId});
  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {

  TextEditingController _controller=new TextEditingController();

  RoomRepository _roomRepository=new RoomRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("New Room"),
            Text("Add subject",style: TextStyle(fontSize: 13),),
          ],
        ),
      ),
      body: Column(
        children: [
          TextFieldWithButton(context: context, textEditingController: _controller, onSubmit: (){
            if(_controller.text.isNotEmpty){
              _roomRepository.createRoom(_controller.text,widget.roomId);
              Navigator.pop(context);
            }
          },showEmojiKeyboard: false,)
        ],
      ),
    );
  }
}
