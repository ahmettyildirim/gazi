import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onSignedIn;
  LoginPage({required this.onSignedIn});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Usernasme",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(screenHeight / 30),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Password",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(screenHeight / 30),
                  child: SizedBox(
                    width: screenWidth / 1.2,
                    height: screenHeight / 12,
                    child: ElevatedButton(
                        onPressed: () {
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
    );
  }
}
