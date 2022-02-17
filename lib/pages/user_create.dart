import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gazi_app/common/custom_animation.dart';

class UserCreatePage extends StatefulWidget {
  UserCreatePage({Key? key}) : super(key: key);

  @override
  State<UserCreatePage> createState() => _UserCreatePageState();
}

class _UserCreatePageState extends State<UserCreatePage> {
  var _formKey = GlobalKey<FormState>(debugLabel: '_AddUserFormState');
  var _mailController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenInfo = MediaQuery.of(context);
    final screenWidth = screenInfo.size.width;
    final screenHeight = screenInfo.size.height;
    return Scaffold(
      appBar: AppBar(title: Text("Yeni Kullanıcı Yarat")),
      body: Align(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 10, left: screenWidth / 8, right: screenWidth / 8),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _mailController,
                  decoration: InputDecoration(labelText: "Email Adresi"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Mail Adresini Giriniz';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 10, left: screenWidth / 8, right: screenWidth / 8),
                child: TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "Şifre"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Şifre Giriniz';
                    }
                    return null;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          top: 10,
                          left: screenWidth / 8,
                          right: screenWidth / 8),
                      child: ElevatedButton(
                          onPressed: _addUser, child: Text("Ekle"))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addUser() async {
    try {
      if (_formKey.currentState!.validate()) {
        CustomLoader.show();
        var credentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _mailController.text,
                password: _passwordController.text);
        CustomLoader.close();
        if (credentials.user == null) {
          EasyLoading.showError("Kullanıcı eklenemedi",
              maskType: EasyLoadingMaskType.black);
        } else {
          EasyLoading.showSuccess("Kullanıcı Eklendi",
              maskType: EasyLoadingMaskType.black);
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      print(e);
      String message =
          (e as FirebaseAuthException).code.toString() == "invalid-email"
              ? "Geçerli bir mail adresi giriniz"
              : "";
      EasyLoading.showError("Kullanıcı eklenemedi\n" + message,
          maskType: EasyLoadingMaskType.black);
    }
  }
}
