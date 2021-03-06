import 'dart:ui';

import 'package:bubble/bubble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wively/src/data/models/chat.dart';
import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/data/models/message_types.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/screens/contact/contact_controller.dart';
import 'package:wively/src/utils/dates.dart';
import 'package:wively/src/utils/file_util.dart';
import 'package:wively/src/utils/message_utils.dart';
import 'package:wively/src/utils/room_message_controller.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/custom_app_bar.dart';
import 'package:wively/src/widgets/file_message.dart';
import 'package:wively/src/widgets/image_message.dart';
import 'package:wively/src/widgets/text_field_with_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:wively/src/widgets/video_message.dart';

enum MessagePosition { BEFORE, AFTER }

class ContactScreen extends StatefulWidget {
  static final String routeName = "/contact";

  Chat parentChat;
  ContactScreen({this.parentChat});

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  ContactController _contactController;
  final format = new DateFormat("HH:mm");

  @override
  void initState() {
    super.initState();
    _contactController = ContactController(
      context: context,
    );
    _contactController.parentChat=widget.parentChat;
  }

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _contactController.initProvider();
    super.didChangeDependencies();
  }

  shouldShowNip(int index) {
    if (index == _contactController.selectedChat.messages.length - 1)
      return true;
    return (_contactController.selectedChat.messages[index].from !=
            _contactController.selectedChat.messages[index + 1].from ||
        RoomMessageController.isAddedMessage(
            _contactController.selectedChat.messages[index + 1].message))|| shouldShowTime(index) ;
  }

  shouldShowBackgroundColor(Message message){
    if(message.fileUrls!=null
        && message.fileUrls!='null'
        && message.fileUrls!=''){
      switch(MessageUtil.getTypeFromUrl(message.fileUrls)){
        case MessageTypes.IMAGE_MESSAGE:
          return false;
      }
    }
    return true;
  }


  shouldShowTime(int index) {
    if (index == _contactController.selectedChat.messages.length - 1)
      return true;
    return (
        DateTime.
        fromMillisecondsSinceEpoch(_contactController.selectedChat.messages[index].sendAt)
            .difference(DateTime.fromMillisecondsSinceEpoch(_contactController.selectedChat.messages[index+1].sendAt)).inSeconds>60);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _contactController.willPop,
      child: StreamBuilder<Object>(
          stream: _contactController.streamController.stream,
          builder: (context, snapshot) {
            return Scaffold(
              appBar: CustomAppBar(
                title: GestureDetector(
                  onTap: () => _contactController
                      .openRoom(_contactController?.selectedChat?.room?.id),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: _contactController.selectedChat.id + 'profile',
                        child: Material(
                          color: EColors.transparent,
                          child: CircleAvatar(
                            child: Text(
                              _contactController.selectedChat.room == null
                                  ? _contactController.selectedChat.user.name[0]
                                  : _contactController
                                      .selectedChat.room.roomName[0]
                                      .toUpperCase(),
                              style: TextStyle(
                                color: EColors.themeMaroon,
                                fontSize: 14,
                              ),
                            ),
                            radius: 16,
                            backgroundColor: EColors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _contactController.selectedChat.room == null
                                ? _contactController.selectedChat.user.name
                                : _contactController.selectedChat.room.roomName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "@${_contactController.selectedChat.room == null ? _contactController.selectedChat.user.username : _contactController.selectedChat.room.roomName}",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions:_contactController.selectedChat.isRoom? [
                    Hero(
                      tag: _contactController.selectedChat.id,
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: Icon(Icons.dashboard),
                          onPressed: _contactController.openBoard,
                        ),
                      ),
                    ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _contactController.createChildRoom,
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: _contactController.addRoomScreen,
                  ),
                ]:[],
              ),
              body: SafeArea(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Scrollbar(
                          child: ListView.builder(
                            addAutomaticKeepAlives: true,
                            cacheExtent:10 ,
                            physics: ClampingScrollPhysics(),
                            controller: _contactController.scrollController,
                            padding: EdgeInsets.only(bottom: 5),
                            reverse: true,
                            itemCount:
                                _contactController.selectedChat.messages.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                key:Key(_contactController.selectedChat.messages[index].id.toString()),
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 0, top: 0),
                                child: renderMessage(
                                    context,
                                    _contactController
                                        .selectedChat.messages[index],
                                    index,
                                    shouldShowNip(index),
                                    shouldShowTime(index)),
                              );
                            },
                          ),
                        ),
                      ),
                      TextFieldWithButton(
                        onFileSelectPress: _contactController.showSelectFile,
                        onSubmit: _contactController.sendMessage,
                        textEditingController: _contactController.textController,
                        onEmojiTap: (bool showEmojiKeyboard) {
                          _contactController.showEmojiKeyboard =
                              !showEmojiKeyboard;
                        },
                        showEmojiKeyboard: _contactController.showEmojiKeyboard,
                        context: context,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget renderMessage(
      BuildContext context, Message message, int index, bool showNip, bool showTime) {
    if (_contactController.myUser == null) return Container();
    bool isMe = message.from == _contactController.myUser.id;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        renderMessageSendAtDay(message, index),
        getInfoLabel(message),
        RoomMessageController.isAddedMessage(message.message)
            ? Container(
                height: 0,
                width: 0,
              )
            : Material(
                color: Colors.transparent,
                child: Bubble(
                  shadowColor: EColors.transparent,
                  radius: Radius.circular(15),
                  margin: !showNip
                      ? BubbleEdges.only(
                          top: 2, left: isMe ? 100 : 0, right: !isMe ? 100 : 0)
                      : BubbleEdges.only(
                          top: 10,
                          left: isMe ? 100 : 0,
                          right: !isMe ? 100 : 0),
                  alignment: isMe ? Alignment.topRight : Alignment.topLeft,
                  nip: showNip
                      ? (isMe ? BubbleNip.rightTop : BubbleNip.leftTop)
                      : null,
                  color: message.fileUrls==null || message.fileUrls?.length==0
                 || shouldShowBackgroundColor(message)? EColors.themePink.withOpacity(0.5): EColors.transparent,
                  child:Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if(showNip)
                        renderUserName(message, isMe),
                      message.fileUrls==null || message.fileUrls?.length==0 ? Container(width:0,height:0):renderFileMessage(message,isMe,showNip),
                      if(MessageUtil.isTextMessage(message.message))
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                          message.message,
                          style: TextStyle(
                              color: EColors.white,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.left,
                      ),
                        ),
                      if(showTime)
                        renderMessageSendAt(message, MessagePosition.AFTER)
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  Widget renderMessageSendAt(Message message, MessagePosition position) {
    if (message.from == _contactController.myUser.id) {
      return Text(
        messageDate(message.sendAt),
        style: TextStyle(color: EColors.themeGrey, fontSize: 8),
        textAlign: TextAlign.right,
      );
    }
    if (message.from != _contactController.myUser.id) {
      return Text(
        messageDate(message.sendAt),
        style: TextStyle(color: EColors.themeGrey, fontSize: 8),
        textAlign: TextAlign.left,
      );
    }
    return Container(height: 0, width: 0);
  }

  String messageDate(int milliseconds) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return format.format(date);
  }

  Widget renderMessageSendAtDay(Message message, int index) {
    if (index == _contactController.selectedChat.messages.length - 1) {
      return getLabelDay(message.sendAt);
    }
    final lastMessageSendAt = new DateTime.fromMillisecondsSinceEpoch(
        _contactController.selectedChat.messages[index + 1].sendAt);
    final messageSendAt =
        new DateTime.fromMillisecondsSinceEpoch(message.sendAt);
    final formatter = UtilDates.formatDay;
    String formattedLastMessageSendAt = formatter.format(lastMessageSendAt);
    String formattedMessageSendAt = formatter.format(messageSendAt);
    if (formattedLastMessageSendAt != formattedMessageSendAt) {
      return getLabelDay(message.sendAt);
    }
    return Container();
  }

  Widget getLabelDay(int milliseconds) {
    String day = UtilDates.getSendAtDay(milliseconds);
    return Column(
      children: <Widget>[
        SizedBox(
          height: 4,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: EColors.themeMaroon.withOpacity(0.5),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
            child: Text(
              day,
              style: TextStyle(color: EColors.white, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          height: 7,
        ),
      ],
    );
  }

  Widget getInfoLabel(Message message) {
    if (RoomMessageController.isAddedMessage(message.message)) {
      return Column(
        children: <Widget>[
          SizedBox(
            height: 4,
          ),
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: EColors.blackTransparent,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Text(
                    RoomMessageController.createAddedMessage(message.message,
                        _contactController.myUser.id == message.from),
                    style: TextStyle(color: EColors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 7,
          ),
        ],
      );
    }
    return Container();
  }

  renderUserName(Message message, bool isMe) {
    return Text(
      isMe ? 'You' : message?.fromUser,
      style: TextStyle(
          shadows: [Shadow(color: EColors.themeGrey)],
          fontWeight: FontWeight.w400,
          color: EColors.getRandomColorForUser(message.fromUser)),
    );
  }


  renderFileMessage(Message message,bool isMe,bool showNip){
    if(message.fileUrls!=null
        && message.fileUrls!='null'
        && message.fileUrls!=''){
      switch(MessageUtil.getTypeFromUrl(message.fileUrls)){
        case MessageTypes.IMAGE_MESSAGE:
          return ImageMessage(message);
        case MessageTypes.DOC_MESSAGE:
          return FileMessage(message,isMe,showNip);
        case MessageTypes.VIDEO_MESSAGE:
          return VideoMessage(message,isMe,showNip);
      }
    }
    return SizedBox(height: 0,width: 0);
  }

}
