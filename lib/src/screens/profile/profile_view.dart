import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wively/src/data/models/chat.dart';
import 'package:wively/src/data/models/room.dart';
import 'package:wively/src/data/models/user.dart';
import 'package:wively/src/screens/profile/profile_controller.dart';
import 'package:wively/src/utils/screen_util.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/cache_image.dart';
import 'package:wively/src/widgets/file_viewer.dart';
import 'package:wively/src/widgets/image_with_placeholder.dart';

class ProfileView extends StatefulWidget {
  User user;
  Chat chat;
  ProfileView(this.user,this.chat);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ProfileController _profileController;

  @override
  void didChangeDependencies() {
    if(_profileController==null){
      _profileController =
      new ProfileController(context: context, user: widget.user,chat: widget.chat);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [_profilePreView(), _listItems(),
        ],
      ),
    );
  }

  _listItems() {
    return StreamBuilder(
      stream: _profileController.streamController.stream,
      builder: (context,snapshot){
        return SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              SizedBox(height: 15,),
              _mediaHolder(),
              _listHoldersEnc(),
              _listHoldersNum(),
              _listHoldersAddToRoom(),
              _commonGroups(),
              _listHoldersBlock(),
              _listHoldersReport()
            ]));
      },
    );

  }


  _mediaHolder(){
          int l= _profileController.media.length;
          if(l==0){
            return SizedBox(width: 0,height: 0,);
          }
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: EColors.themeMaroon,
            margin: EdgeInsets.only(top: 5,bottom: 5),
            child: Column(
              children: [
                Container(
                    width: ScreenUtil.width(context),
                    color: EColors.themeMaroon,
                    padding: EdgeInsets.only(left: 10,top: 5,bottom: 10),
                    child: Text('Common medias',style: TextStyle(
                        color: EColors.themeGrey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                    ),)),
                LimitedBox(
                  maxWidth: ScreenUtil.width(context),
                  maxHeight: 100,
                  child: ListView.builder(
                    itemCount: l>10?10:l,
                    itemBuilder: (context,index){
                      return FileViewer(_profileController.media[index]);
                    },
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ],
            ),
        );
  }

  _commonGroups(){
      int l= _profileController.commonRooms.length;
      if(_profileController.loading || l==0 || _profileController.error){
        return SizedBox(width: 0,height: 0,);
      }
      return Container(
        margin: EdgeInsets.only(top: 5,bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Container(
              width: ScreenUtil.width(context),
              color: EColors.themeMaroon,
                padding: EdgeInsets.only(left: 10,top: 10),
                child: Text('Common rooms',style: TextStyle(
              color: EColors.themeGrey,
              fontSize: 18,
              fontWeight: FontWeight.w500
            ),)),
          ...List.generate(l, (index){
          Room room=_profileController.commonRooms[index];
          return  _listItem(
              imageUrl: room.profileUrl==null?'':room.profileUrl,
              title: room.roomName,
              subTitle:'Mujeeb khan, Hammad fasih, raghib najmi....');
        })
          ],
        ),
      );
  }

   _listHoldersEnc() {
    return Container(
      margin: EdgeInsets.only(top: 5,bottom: 5),
      child: Column(
        children: [
          _listItem(
              trailing: Icon(Icons.lock,color: EColors.themePink,),
              title: 'Encryption',
              subTitle:
              'All the messages are encrypted and only sender and receiver can see them')
        ],
      ),
    );
  }

  _listHoldersNum() {
    return Container(
      margin: EdgeInsets.only(top: 5,bottom: 5),
      child: Card(
        color: EColors.transparent,
        elevation: 6,
        child: Column(
          children: [
            _listItem(
                trailing: LimitedBox(
                  maxWidth: ScreenUtil.width(context)/2,
                  child: Wrap(
                    runSpacing: 5,
                    spacing: 10,
                    children: [
                      Icon(Icons.call,color: EColors.themePink,),
                      Icon(Icons.message,color: EColors.themePink,),
                      Icon(Icons.video_call,color: EColors.themePink,)
                    ],
                  ),
                ),
                title: '+91 9012375632',
                subTitle:
                'Mobile')
          ],
        ),
      ),
    );
  }


  _listHoldersAddToRoom() {
    return Container(
      margin: EdgeInsets.only(top: 5,bottom: 5),
      child: Column(
        children: [
          _listItem(
              trailing: Icon(Icons.add,color: EColors.themePink,),
              title: 'Add to a Room',
              )
        ],
      ),
    );
  }


  _listHoldersBlock() {
    return Container(
      margin: EdgeInsets.only(top: 5,bottom: 5),
      child: Column(
        children: [
          _listItem(
             redTitle: true,
              trailing: Icon(Icons.block,color: EColors.red,),
              title: 'Block user',
              )
        ],
      ),
    );
  }



  _listHoldersReport() {
    return Container(
      margin: EdgeInsets.only(top: 5,bottom: 5),
      child: Column(
        children: [
          _listItem(
             redTitle: true,
              trailing: Icon(Icons.report,color: EColors.red,),
              title: 'Report user',
              )
        ],
      ),
    );
  }



  _listItem({String imageUrl,Widget trailing, String title = '', String subTitle, bool redTitle=false}) {
    return Material(
      color: EColors.transparent,
      child: ListTile(
        leading: imageUrl==null?imageUrl:ImageWithPlaceholder(imageUrl,placeholderType:EPlaceholderType.room),
        contentPadding: EdgeInsets.symmetric(horizontal:12,vertical: 7),
        tileColor: EColors.themeMaroon,
        title: Text(title,style: TextStyle(color: redTitle?EColors.red:EColors.white,fontWeight: FontWeight.w400),),
        subtitle: subTitle==null?subTitle:Text(subTitle,style: TextStyle(color: EColors.themeGrey,fontWeight: FontWeight.w400,fontSize: 13),),
        trailing: trailing,
      ),
    );
  }

  _profilePreView() {
    return SliverAppBar(
      title: Text(_profileController.user.name),
      expandedHeight: ScreenUtil.height(context) / 3,
      stretch: true,
      onStretchTrigger: () async {},
      flexibleSpace: FlexibleSpaceBar(
        background: CacheImage(_profileController.user.profileUrl),
        stretchModes: <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
          StretchMode.fadeTitle
        ],
      ),
    );
  }
}
