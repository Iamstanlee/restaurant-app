import 'package:fgrestaurant/constants/fonts.dart';
import 'package:fgrestaurant/helpers/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseTextField extends StatelessWidget {
  final Widget suffix;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final String initialValue;
  final TextInputType keyboardType;
  final InputBorder inputBorder;

  BaseTextField(
      {this.suffix,
      this.labelText,
      this.hintText,
      this.inputFormatters,
      this.onSaved,
      this.inputBorder = InputBorder.none,
      this.obscureText = false,
      this.validator,
      this.controller,
      this.initialValue,
      this.keyboardType = TextInputType.text})
      : super();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: inputFormatters,
      onSaved: onSaved,
      obscureText: obscureText,
      validator: validator,
      maxLines: 1,
      initialValue: initialValue,
      keyboardType: keyboardType,
      style: TextStyle(
          color: Colors.black, fontSize: 16.0, fontFamily: primaryFont),
      decoration: new InputDecoration(
        border: inputBorder,
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
        hintStyle: TextStyle(
            color: Colors.grey, fontSize: 16.0, fontFamily: primaryFont),
        suffixIcon: suffix == null
            ? null
            : new Padding(
                padding: EdgeInsetsDirectional.only(end: 12.0),
                child: suffix,
              ),
        errorStyle: TextStyle(fontSize: 12.0, fontFamily: primaryFont),
        errorMaxLines: 3,
        isDense: true,
        enabledBorder: inputBorder,
        hintText: hintText,
      ),
    );
  }
}

class RegField extends BaseTextField {
  RegField({
    @required FormFieldSetter<String> onSaved,
    @required Widget suffix,
    String labelText,
    String hintText,
  }) : super(
          labelText: labelText,
          hintText: hintText,
          onSaved: onSaved,
          validator: (value) => validateField(value, labelText),
          suffix: suffix,
        );

  static String validateField(String value, String label) {
    if (value.isEmpty) return "$label is required.";
    return null;
  }
}

class PasswordField extends BaseTextField {
  PasswordField({
    @required FormFieldSetter<String> onSaved,
    @required Widget suffix,
    String labelText,
    String hintText,
  }) : super(
          labelText: labelText,
          hintText: hintText,
          onSaved: onSaved,
          validator: validateField,
          obscureText: true,
          suffix: suffix,
        );

  static String validateField(String value) {
    if (value.isEmpty) return "Password is required";
    if (value.length < 6) return "Password must be greater than 5 digits";
    return null;
  }
}

class PhoneField extends BaseTextField {
  PhoneField({
    @required FormFieldSetter<String> onSaved,
    @required Widget suffix,
    String labelText,
    String hintText,
  }) : super(
          labelText: labelText,
          hintText: hintText,
          keyboardType: TextInputType.number,
          onSaved: onSaved,
          validator: validateField,
          // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          suffix: suffix,
        );

  static String validateField(String value) {
    if (value.isEmpty) return "Phone number is required";
    if (value.length < 9) return "Invalid Phone number";
    return null;
  }
}

class RegUnderlineField extends BaseTextField {
  RegUnderlineField({
    @required FormFieldSetter<String> onSaved,
    @required Widget suffix,
    String labelText,
    String hintText,
  }) : super(
          labelText: labelText,
          hintText: hintText,
          onSaved: onSaved,
          inputBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.grey[600])),
          validator: (value) => validateField(value, labelText),
          suffix: suffix,
        );

  static String validateField(String value, String label) {
    if (value.isEmpty) return "$label is required.";
    return null;
  }
}
