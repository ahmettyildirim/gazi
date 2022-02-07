import 'package:flutter/material.dart';
import 'package:gazi_app/pages/add_sale.dart';
import 'package:gazi_app/pages/customers.dart';
import 'package:gazi_app/pages/kurbanlar.dart';
import 'package:gazi_app/pages/sales.dart';
import 'package:gazi_app/pages/summary.dart';

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
        return SummaryPage();
      case 1:
        return CustomerList();
      case 2:
        return KurbanPage();
      case 3:
        return SalesList();
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
      floatingActionButton: Visibility(
        visible: true,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddSale()));
          },
          child: const Icon(Icons.add),
          elevation: 10.0,
          backgroundColor: Colors.blue,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            label: 'Hisseler',
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
