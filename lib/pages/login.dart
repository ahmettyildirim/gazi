import 'package:flutter/material.dart';
import 'package:gazi_app/common/authentiacation.dart';
import 'package:provider/provider.dart';

import '../main.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  // final VoidCallback onSignedIn;
  // LoginPage({required this.onSignedIn});
  LoginPage({
    required this.login,
  });
  final void Function(String email, String password) login;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_LoginFormState');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenInfo = MediaQuery.of(context);
    final screenWidth = screenInfo.size.width;
    final screenHeight = screenInfo.size.height;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight / 60),
                    child: Text(
                      'Gazi Et Mangal',
                      style: TextStyle(
                          fontFamily: "Pacifico",
                          fontSize: 40,
                          color: Colors.grey.shade100),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenHeight / 30),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your email address to continue';
                        }
                        return null;
                      },
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: "Email",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenHeight / 30),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Şifre",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenHeight / 30),
                    child: SizedBox(
                      width: screenWidth / 1.2,
                      height: screenHeight / 12,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              widget.login(
                                _emailController.text,
                                _passwordController.text,
                              );
                            }
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => WaveBackgroundPage()));
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.grey.shade500,
                              onPrimary: Colors.white),
                          child: Text(
                            "Giriş",
                            style: TextStyle(
                              fontSize: screenHeight / 30,
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
