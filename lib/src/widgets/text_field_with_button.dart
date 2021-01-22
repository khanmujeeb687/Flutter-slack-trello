import 'dart:io';

import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/values/constants.dart';

class TextFieldWithButton extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function onSubmit;
  final Function onFileSelectPress;
  final Function onEmojiTap;
  final bool showEmojiKeyboard;
  final BuildContext context;

  TextFieldWithButton({
    @required this.context,
    @required this.textEditingController,
    @required this.onSubmit,
    @required this.onFileSelectPress,
    this.onEmojiTap,
    this.showEmojiKeyboard = false,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: Platform.isIOS
                          ? EdgeInsets.only(left: 5, right: 5)
                          : EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: EColors.themeMaroon.withOpacity(0.5),
                        border: Border.all(
                          width: 1,
                          color: Color(0xFFDDDDDD),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Platform.isIOS
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    onEmojiTap(showEmojiKeyboard);
                                  },
                                  child: Icon(
                                    Icons.insert_emoticon,
                                    color: EColors.themeGrey,
                                  ),
                                ),
                          Expanded(
                            child: Scrollbar(
                              child: TextField(
                                autocorrect: true,
                                maxLines: 5,
                                minLines: 1,
                                showCursor: true,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                cursorColor: Theme.of(context).primaryColor,
                                controller: textEditingController,
                                style: TextStyle(
                                  color: EColors.white
                                ),
                                onSubmitted: (_) {
                                  onSubmit();
                                },
                                onTap: () {
                                  if (showEmojiKeyboard) {
                                    onEmojiTap(showEmojiKeyboard);
                                  }
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  // suffixIcon: Icon(Icons.add),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: Constants.MESSAGE_HINT_TEXT,
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: EColors.white,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: onFileSelectPress,
                            child: Icon(
                              Icons.attach_file,
                              color: EColors.themeGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Material(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      onTap: () {
                        onSubmit();
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 35,
                        height: 35,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        renderEmojiKeyboard(),
      ],
    );
  }

  Widget renderEmojiKeyboard() {
    if (showEmojiKeyboard) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    if (showEmojiKeyboard && !_keyboardIsVisible()) {
      return EmojiPicker(
        rows: 3,
        columns: 7,
        onEmojiSelected: (emoji, category) {
          final emojiImage = emoji.emoji;
          textEditingController.text =
              "${textEditingController.text}$emojiImage";
        },
      );
    }
    return Container(width: 0, height: 0);
  }

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }
}
