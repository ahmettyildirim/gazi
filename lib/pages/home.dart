import 'package:flutter/material.dart';
import 'package:gazi_app/pages/account.dart';
import 'package:gazi_app/pages/customers.dart';
import 'package:gazi_app/pages/kurbanlar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _page = 1;
  Duration pageChanging =
      Duration(milliseconds: 300); //this is for page animation-not necessary
  Curve animationCurve =
      Curves.linear; //this is for page animation-not necessary
  _HomePageState();
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    if (this.mounted) {
      setState(() {
        this._page = page;
      });
    }
  }

  void navigationTapped(int page) {
    setState(() {
      _page = page;
    });
  }

  Widget currentPage(int currentPageNum) {
    switch (currentPageNum) {
      case 0:
        return Text("Anasayfa");
      case 1:
        return CustomerList();
      case 2:
        return KurbanPage();
      case 3:
        return Text("Satışlar");
      case 4:
        return AccountPage();
      default:
        return Text("Anasayfa");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      //   elevation: 2.0,
      // ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page, // this will be set when a new tab is tapped
        onTap: navigationTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.people),
            label: 'Müşteriler',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_tree_outlined),
            label: 'Kurbanlar',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.receipt_long),
            label: 'Satışlar',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_box),
            label: 'Kullanıcı',
          ),
        ],
      ),
      body: Center(child: currentPage(_page)),
    );
  }
}
