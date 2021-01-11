import 'package:wively/src/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:wively/src/values/Colors.dart';

class UserCard extends StatelessWidget {
  final User user;
  final Function onTap;

  UserCard({
    @required this.user,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          if (this.onTap != null) {
            this.onTap(user);
          }
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
                CircleAvatar(
                  child: Text(
                    user.name[0].toUpperCase(),
                    style: TextStyle(
                      color: EColors.themeMaroon,
                    ),
                  ),
                  radius: 20,
                  backgroundColor: EColors.themeGrey,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      top: 5,
                    ),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            this.user.name,
                            style: TextStyle(
                              color: EColors.themeGrey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@${this.user.username}',
                            style: TextStyle(
                              color: EColors.themeGrey,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: EColors.blackTransparent,
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
}
