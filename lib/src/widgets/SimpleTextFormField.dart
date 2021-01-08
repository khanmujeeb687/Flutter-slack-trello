import 'package:flutter/material.dart';


class SimpleTextFormField extends StatefulWidget {
  String hint;
  Function(String a) onChange;
  Function(String a) validator;
  bool bigField;
  SimpleTextFormField({this.hint,this.onChange,this.validator,this.bigField=false});
  @override
  _SimpleTextFormFieldState createState() => _SimpleTextFormFieldState();
}

class _SimpleTextFormFieldState extends State<SimpleTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      child: TextFormField(
        maxLines: widget.bigField?null:1,
        decoration: InputDecoration(
          hintText: widget.hint
        ),
        onChanged: widget.onChange,
        enableInteractiveSelection: true,
        validator: widget.validator,
      ),
    );
  }
}
