import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:wively/src/data/models/chat.dart';
import 'package:wively/src/data/models/file_models.dart';
import 'package:wively/src/data/models/message_types.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/screens/contact/contact_view.dart';
import 'package:wively/src/utils/dates.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:wively/src/utils/file_util.dart';
import 'package:wively/src/utils/message_utils.dart';
import 'package:wively/src/utils/navigation_util.dart';
import 'package:wively/src/utils/room_message_controller.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/cache_image.dart';
import 'package:wively/src/widgets/image_with_edit.dart';
import 'package:wively/src/widgets/image_with_placeholder.dart';

class ChatCard extends StatelessWidget {
  final Chat chat;

  final format = new DateFormat("HH:mm");

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.lightBlue,
    Colors.purple,
    Colors.black,
    Colors.cyan,
  ];

  final rng = new Random();

  ChatCard({
    @required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);
    return Container(
      child: InkWell(
        onTap: () {
          ChatsProvider _chatsProvider =
              Provider.of<ChatsProvider>(context, listen: false);
          _chatsProvider.setSelectedChat(chat);
          NavigationUtil.navigate(context,ContactScreen());
        },
        child: Padding(
          padding: EdgeInsets.only(
            left: 15,
            top: 10,
            bottom: 0,
          ),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: chat.id+'profile',
                  child: Material(
                    color: EColors.transparent,
                    child: ImageWithPlaceholder(chat.room==null?chat.user.profileUrl:chat.room.profileUrl,placeholderType: this.chat.room==null?EPlaceholderType.user:EPlaceholderType.room),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      top: 2,
                    ),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Text(
                                      !chat.isRoom?chat.user.name:chat.room.roomName,
                                      style: TextStyle(
                                        color: EColors.themeGrey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),

                                    if(MessageUtil.isTextMessage(chat.messages[0].message))
                                      Text(
                                      //fix the second argument
                                        (){
                                          if( RoomMessageController.isAddedMessage(chat.messages[0].message)){
                                            return RoomMessageController.createAddedMessage(chat.messages[0].message, true);
                                          }
                                          return  chat.messages[0].message;
                                        }(),
                                      style: TextStyle(
                                        color: EColors.themeGrey,
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: (){
                                        if(chat.messages[0].fileUrls!=null
                                            && chat.messages[0].fileUrls!='null'
                                            && chat.messages[0].fileUrls!=''){
                                          String messageType=MessageUtil.getTypeFromUrl(chat.messages[0].fileUrls);
                                          switch(messageType){
                                            case MessageTypes.IMAGE_MESSAGE:
                                              return Row(
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                    width: 60,
                                                    child:FileUtil.fileOriginType(chat.messages[0].fileUrls)==EOrigin.remote?
                                                    CacheImage(chat.messages[0].fileUrls):
                                                    Image.file(File(chat.messages[0].fileUrls))
                                                  ),
                                                  Text("Image",style: TextStyle(color: EColors.themeGrey),)
                                                ],
                                              );
                                            case MessageTypes.DOC_MESSAGE:
                                              return Row(
                                                children: [
                                                  Icon(Icons.file_copy_sharp,size: 15,color: EColors.themeGrey,),
                                                  SizedBox(width: 10,),
                                                  Text("Document",style: TextStyle(color: EColors.themeGrey),)
                                                ],
                                              );
                                            case MessageTypes.VIDEO_MESSAGE:
                                              return Row(
                                                children: [
                                                  Icon(Icons.video_call,size: 15,color: EColors.themeGrey,),
                                                  SizedBox(width: 10,),
                                                  Text("Video",style: TextStyle(color: EColors.themeGrey),)
                                                ],
                                              );
                                          }
                                        }
                                        return SizedBox(height: 0,width: 0,);
                                      }(),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 15, left: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      UtilDates.getSendAtDayOrHour(chat.messages[0].sendAt),
                                      style: TextStyle(
                                        color: _numberOfUnreadMessagesByMe() > 0
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    unreadMessages(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: EColors.themeMaroon,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String messageDate(int milliseconds) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return format.format(date);
  }

  int _numberOfUnreadMessagesByMe() {
    return chat.messages.where((message) => message.unreadByMe).length;
  }

  Widget unreadMessages() {
    final _unreadMessages = _numberOfUnreadMessagesByMe();
    if (_unreadMessages == 0) {
      return Container(width: 0, height: 0);
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: EColors.themePink,
      ),
      child: Text(
        _unreadMessages.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
