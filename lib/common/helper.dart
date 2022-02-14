import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

String validateName(String value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Name is required";
  } else if (!regExp.hasMatch(value)) {
    return "Name must be a-z and A-Z";
  }
  return "";
}

String validateMobile(String value) {
  String pattern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Mobile phone number is required";
  } else if (!regExp.hasMatch(value)) {
    return "Mobile phone number must contain only digits";
  }
  return "";
}

String validatePassword(String value) {
  if (value.length < 6)
    return 'Password must be more than 5 characters';
  else
    return "";
}

String validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter Valid Email';
  else
    return "";
}

String validateConfirmPassword(String password, String confirmPassword) {
  print("$password $confirmPassword");
  if (password != confirmPassword) {
    return 'Password doesn\'t match';
  } else if (confirmPassword.length == 0) {
    return 'Confirm password is required';
  } else {
    return "";
  }
}

pushReplacement(BuildContext context, Widget destination) {
  Navigator.of(context).pushReplacement(
      new MaterialPageRoute(builder: (context) => destination));
}

push(BuildContext context, Widget destination) {
  Navigator.of(context)
      .push(new MaterialPageRoute(builder: (context) => destination));
}

pushAndRemoveUntil(BuildContext context, Widget destination, bool predict) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => destination),
      (Route<dynamic> route) => predict);
}

String getMoneyString(int money) {
  return NumberFormat.currency(locale: 'eu', symbol: "TL", decimalDigits: 0)
      .format(money);
}
