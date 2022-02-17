import 'package:flutter/material.dart';
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

double getSmallDiameter(BuildContext context) =>
    MediaQuery.of(context).size.width * 2 / 3;
double getBiglDiameter(BuildContext context) =>
    MediaQuery.of(context).size.width * 7 / 8;

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
      backgroundColor: const Color(0xFFEEEEEE),
      body: Stack(
        children: <Widget>[
          Positioned(
            right: -getSmallDiameter(context) / 3,
            top: -getSmallDiameter(context) / 3,
            child: Container(
              width: getSmallDiameter(context),
              height: getSmallDiameter(context),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Colors.blue, Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
            ),
          ),
          Positioned(
            left: -getBiglDiameter(context) / 4,
            top: -getBiglDiameter(context) / 4,
            child: Container(
              child: const Center(
                child: Text(
                  "\nGazi Et\nMangal",
                  style: TextStyle(
                      fontFamily: "Pacifico",
                      fontSize: 30,
                      color: Colors.blueGrey),
                ),
              ),
              width: getBiglDiameter(context),
              height: getBiglDiameter(context),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Colors.white, Colors.blue],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
            ),
          ),
          Positioned(
            right: -getBiglDiameter(context) / 2,
            bottom: -getBiglDiameter(context) / 2,
            child: Container(
              width: getBiglDiameter(context),
              height: getBiglDiameter(context),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFFF3E9EE)),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        //border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.fromLTRB(20, 300, 20, 10),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Mail adresini giriniz';
                            }
                            return null;
                          },
                          controller: _emailController,
                          decoration: InputDecoration(
                              icon: const Icon(
                                Icons.email,
                                color: Colors.blueAccent,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade100)),
                              labelText: "Email",
                              enabledBorder: InputBorder.none,
                              labelStyle: const TextStyle(color: Colors.grey)),
                        ),
                        SizedBox(
                          height:20
                        ),
                        TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Şifre Giriniz';
                            }
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              icon: const Icon(
                                Icons.vpn_key,
                                color: Colors.blueAccent,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade100)),
                              labelText: "Şifre",
                              enabledBorder: InputBorder.none,
                              labelStyle: const TextStyle(color: Colors.grey)),
                        )
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 20, 10),
                          child: const Text(
                            "Şifremi Unuttum",
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 11),
                          ))),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 40,
                          child: Container(
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                splashColor: Colors.green,
                                onTap: () {
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
                                child: const Center(
                                  child: Text(
                                    "Giriş Yap",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                    colors: [
                                      Colors.lightBlue,
                                      Colors.blueAccent
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );

    // Scaffold(
    //   backgroundColor: Colors.white,
    //   body: Container(
    //     // decoration: BoxDecoration(
    //     //   image: DecorationImage(
    //     //     image: AssetImage("images/background.jpg"),
    //     //     fit: BoxFit.cover,
    //     //   ),
    //     // ),
    //     child: Center(
    //       child: SingleChildScrollView(
    //         child: Form(
    //           key: _formKey,
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Padding(
    //                 padding: EdgeInsets.only(bottom: screenHeight / 60),
    //                 child: Text(
    //                   'Gazi Et Mangal',
    //                   style: TextStyle(fontSize: 40, color: Colors.blue),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.all(screenHeight / 30),
    //                 child: TextFormField(
    //                   validator: (value) {
    //                     if (value!.isEmpty) {
    //                       return 'Mail adresini giriniz';
    //                     }
    //                     return null;
    //                   },
    //                   controller: _emailController,
    //                   decoration: InputDecoration(
    //                     hintText: "Email",
    //                     filled: false,
    //                     fillColor: Colors.white,
    //                   ),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.all(screenHeight / 30),
    //                 child: TextFormField(
    //                   controller: _passwordController,
    //                   validator: (value) {
    //                     if (value!.isEmpty) {
    //                       return 'Şifre Giriniz';
    //                     }
    //                   obscureText: true,
    //                   decoration: InputDecoration(
    //                     hintText: "Şifre",
    //                     filled: true,
    //                     fillColor: Colors.white,
    //                   ),
    //                   validator: (value) {
    //                     if (value!.isEmpty) {
    //                       return 'Şifre Giriniz';
    //                     }
    //                     return null;
    //                   },
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.all(screenHeight / 30),
    //                 child: SizedBox(
    //                   width: screenWidth / 1.2,
    //                   height: screenHeight / 12,
    //                   child: ElevatedButton(
    //                       onPressed: () {
    //                         if (_formKey.currentState!.validate()) {
    //                           widget.login(
    //                             _emailController.text,
    //                             _passwordController.text,
    //                           );
    //                         }
    //                         // Navigator.push(
    //                         //     context,
    //                         //     MaterialPageRoute(
    //                         //         builder: (context) => WaveBackgroundPage()));
    //                       },
    //                       child: Text(
    //                         "Giriş",
    //                         style: TextStyle(
    //                           fontSize: screenHeight / 30,
    //                         ),
    //                       )),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
