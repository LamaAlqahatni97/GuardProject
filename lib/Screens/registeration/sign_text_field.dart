import 'package:flutter/material.dart';
import 'package:guardproject/theme/text_styles.dart';

class SignTextField extends StatelessWidget {
  final String hintText;
  final Function onValidated;
  final Function onSaved;
  final bool obsectureText;
  final String initialValue;
  final Function onChanged;
  final TextEditingController controller;
  final bool enabled;
  SignTextField(
      {this.hintText,
      this.onChanged,
      this.obsectureText = false,
      this.onSaved,
      this.controller,
      this.initialValue,
      this.onValidated,
      this.enabled = true});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: this.onChanged,
      initialValue: this.initialValue,
      validator: this.onValidated,
      onSaved: this.onSaved,
      controller: controller,
      obscureText: this.obsectureText,
      enabled: enabled,
      style: TextStyles.textInputStyle,
      decoration: InputDecoration(
          hintText: this.hintText,
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          hintStyle: TextStyles.textHintStyle,
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(color: Theme.of(context).errorColor)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(color: Theme.of(context).errorColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(color: Theme.of(context).primaryColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(color: Theme.of(context).primaryColor))),
    );
  }
}
