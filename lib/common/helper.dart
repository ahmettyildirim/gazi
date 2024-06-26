import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/custom_animation.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SystemVariables {
  static int currentYear =
      DateTime.now().month > 8 ? DateTime.now().year + 1 : DateTime.now().year;

  static List<int> get festYears {
    List<int> results = List.empty(growable: true);
    for (int i = 2021; i <= DateTime.now().year + 1; i++) {
      results.add(i);
    }
    return results;
  }

  static List<DropdownMenuItem<String>> get yearDropdownItems {
    List<DropdownMenuItem<String>> menuItems = List.empty(growable: true);
    for (int i = 0; i < SystemVariables.festYears.length; i++) {
      menuItems.add(DropdownMenuItem(
          child: Text(SystemVariables.festYears[i].toString()),
          value: SystemVariables.festYears[i].toString()));
    }
    return menuItems;
  }
}

String getKesimSaati(int tip, int kurbanNo) {
  DateTime date = new DateTime(2023, 1, 1, 7, 20, 0);
  if (tip == 1) {
    if (kurbanNo <= 15) {
      return getFormattedDate(date, format: "HH:mm");
    } else {
      date = date.add(Duration(minutes: 40));
      int num = kurbanNo - 15;
      double addedMinutes = num * 6.7;
      double addedRemainder = addedMinutes.remainder(10);
      if (addedRemainder > 5) {
        addedMinutes = addedMinutes + 10 - addedRemainder;
      } else {
        addedMinutes = addedMinutes - addedRemainder;
      }
      date = date.add(Duration(minutes: addedMinutes.toInt()));
      return getFormattedDate(date, format: "HH:mm");
    }
  } else {
    if (kurbanNo <= 20) {
      return getFormattedDate(date, format: "HH:mm");
    } else {
      date = date.add(Duration(minutes: 30));
      int num = (kurbanNo - 20) ~/ 3;
      date = date.add(Duration(minutes: num * 10));
      return getFormattedDate(date, format: "HH:mm");
    }
  }
}

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
  if (password != confirmPassword) {
    return 'Password doesn\'t match';
  } else if (confirmPassword.length == 0) {
    return 'Confirm password is required';
  } else {
    return "";
  }
}

String? requiredValidator(String? text,
    {String information = "Bu alan boş olamaz"}) {
  if (text == null || text.isEmpty) {
    return information;
  }
  return null;
}

String getUsername() {
  var mail = FirebaseAuth.instance.currentUser!.email;
  if (mail!.isEmpty) {
    return "";
  }
  var index = mail.indexOf('@kurban.com');
  if (index == -1) {
    return mail;
  }
  return mail.substring(0, index);
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

Future<bool> askPrompt(BuildContext context,
    {required String message, required String title}) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(title,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold)),
            ),
            content: Padding(
              padding: EdgeInsets.all(8),
              child: Text(message),
            ),
            actions: [
              ButtonBar(alignment: MainAxisAlignment.spaceAround, children: [
                ElevatedButton.icon(
                    icon: Icon(Icons.check),
                    label: Text(
                      "Evet",
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).pop(true);
                      });
                      // your code
                    }),
                ElevatedButton.icon(
                    icon: Icon(Icons.cancel_outlined),
                    label: Text(
                      "Hayır",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).pop(false);
                      });
                      // your code
                    })
              ])
            ],
          );
        });
      });
}

Future<void> launchWhatsApp({required String num, required String text}) async {
  var phone = num;
  if (phone.contains('(')) {
    phone = phone.replaceAll(' ', '');
    phone = phone.replaceAll('(', '');
    phone = phone.replaceAll(')', '');
    phone = phone.replaceAll('-', '');
    phone = "90" + phone;
  }
  if (Platform.isIOS) {
    var whatappURLIos = "https://wa.me/$phone?text=${Uri.parse(text)}";
    // for iOS phone only
    if (await canLaunch(whatappURLIos)) {
      await launch(whatappURLIos, forceSafariVC: false);
    } else {
      CustomLoader.showError("Whatsapp açılamadı.");
    }
  } else {
    var whatsappURlAndroid =
        "whatsapp://send?phone=" + phone + "&text=${Uri.parse(text)}";
    // android , web
    if (await canLaunch(whatsappURlAndroid)) {
      await launch(whatsappURlAndroid);
    } else {
      CustomLoader.showError("Whatsapp açılamadı.");
    }
  }
}

String getFormattedDate(DateTime? date, {String format = "dd-MM-yyyy HH:mm"}) {
  // initializeDateFormatting();
  return date == null ? "" : DateFormat(format).format(date);
}
