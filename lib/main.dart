import 'package:flutter/material.dart';
import 'package:gazi_app/pages/home.dart';
import 'package:gazi_app/pages/login.dart';
import 'package:toast/toast.dart' show Toast;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gazi Et Mangal',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

class _MyHomePageState extends State<MyHomePage> {
  AuthStatus authStatus = AuthStatus.notDetermined;

  @override
  void initState() {
    super.initState();
    var auth = FirebaseAuthentication();
    auth.currentUser().then((user) {
      setState(() {
        authStatus =
            user == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
      Toast.show("Logged in successfully", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
    });
  }

  void _signedOut() {
    setState(() {
      Toast.show("Logged out successfully", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = UserModelRepository.instance.currentUser;
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return _buildWaitingScreen();
      case AuthStatus.notSignedIn:
        return LoginPage(
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return HomePage(
            // onSignedOut: _signedOut,
            );
    }
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new ExactAssetImage('images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
