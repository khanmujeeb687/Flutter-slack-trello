import 'package:flutter/material.dart';
import 'package:wively/src/data/models/user.dart';
import 'package:wively/src/values/Colors.dart';


class SelectMember extends StatefulWidget {
  List<User> users;
  Function(User user) selectUser;
  SelectMember(this.users,this.selectUser);
  @override
  _SelectMemberState createState() => _SelectMemberState();
}

class _SelectMemberState extends State<SelectMember> {
  User selected=new User(id: null, name: null, username: null);
  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: 100,
      maxWidth: MediaQuery.of(context).size.width,
      child: ListView.separated(
        separatorBuilder: (_,a)=>SizedBox(width: 10,),
        scrollDirection: Axis.horizontal,
        itemCount: widget.users.length,
        itemBuilder: (context,index){
          return GestureDetector(
            onTap: (){
              setState(() {
                selected=widget.users[index];
              });
              widget.selectUser(widget.users[index]);
            },
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: EColors.themeGrey,
                  radius: 30,
                  child: Stack(
                    children: [
                      Center(child: Text(widget.users[index].name[0].toUpperCase(),style: TextStyle(color: EColors.themeMaroon),)),
                      if(selected== widget.users[index])
                        Center(child: Icon(Icons.check,color: EColors.themeBlack))
                    ],
                  ),
                ),
                Text(widget.users[index].name,style: TextStyle(color: EColors.white),)
              ],
            ),
          );
        },
      ),
    );
  }
}
