import 'package:flutter/material.dart';
import 'package:wively/src/values/Colors.dart';


class SimpleTextFormField extends StatefulWidget {
  String hint;
  Function(String a) onChange;
  Function(String a) validator;
  bool bigField;
  bool padded;
  SimpleTextFormField({this.hint,this.onChange,this.validator,this.bigField=false,this.padded=true});
  @override
  _SimpleTextFormFieldState createState() => _SimpleTextFormFieldState();
}

class _SimpleTextFormFieldState extends State<SimpleTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:widget.padded?EdgeInsets.symmetric(horizontal: 10,vertical: 20):EdgeInsets.all(0),
      child: TextFormField(
        autofocus: false,
        style: TextStyle(
          color: EColors.white
        ),
        maxLines: widget.bigField?null:1,
        decoration: InputDecoration(
          hintText: widget.hint,
          contentPadding: EdgeInsets.only(left: 10)
        ),
        onChanged: widget.onChange,
        enableInteractiveSelection: true,
        validator: widget.validator,
      ),
    );
  }
}
