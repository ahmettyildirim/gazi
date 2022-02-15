import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/pages/add_sale.dart';
import 'package:gazi_app/pages/customers.dart';
import 'package:gazi_app/pages/kurbanlar.dart';
import 'package:gazi_app/pages/maliyet.dart';
import 'package:gazi_app/pages/sales.dart';
import 'package:gazi_app/pages/summary.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _page = 0;
  Duration pageChanging =
      Duration(milliseconds: 300); //this is for page animation-not necessary
  Curve animationCurve =
      Curves.linear; //this is for page animation-not necessary
  _HomePageState();
  final _formKey = GlobalKey<FormState>(debugLabel: '_AddSaleFormState');
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
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
        return SalesList();
      case 2:
        return KurbanPage();
      case 3:
        return CustomerList();
      default:
        return Text("Anasayfa");
    }
  }

  String? _passwordValidator(String? text) {
    if (text != "1234") {
      return "Hatalı Şifre";
    }
    return null;
  }

  Future<bool> showPassword(BuildContext context) async {
    var _textPasswordController = TextEditingController();
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Kısıtlı Alan',
                  style: TextStyle(fontSize: 15, color: Colors.blueGrey)),
              content: Form(
                key: _formKey,
                child: Container(
                  child: TextFormField(
                    validator: _passwordValidator,
                    controller: _textPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(label: Text("Şifre")),
                  ),
                ),
              ),
              actions: [
                ButtonBar(alignment: MainAxisAlignment.spaceBetween, children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      child: Text(
                        "İptal",
                        style: TextStyle(fontSize: 12),
                      ),
                      onPressed: () {
                        setState(() {
                          Navigator.of(context).pop(false);
                        });
                        // your code
                      }),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      child: Text("Giriş", style: TextStyle(fontSize: 12)),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_textPasswordController.text == "1234") {
                            Navigator.of(context)
                                .pop(_textPasswordController.text == "1234");
                          }
                        }
                      })
                ])
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: new Icon(Icons.animation),
            label: 'Satışlar',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_tree_outlined),
            label: 'Hisseler',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.people),
            label: 'Müşteriler',
          ),
        ],
      ),
      body: Center(child: currentPage(_page)),
      drawer: Drawer(
        child: ListView(
          // padding: EdgeInsets.only(left: 10.0, top: 30.0, right: 10.0),
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Ahmet Yıldırım "),
              accountEmail: Text("ahmetyildirim3@gmail.com"),
            ),
            ListTile(
                title: Text("Kullanıcı İşlemleri"),
                trailing: Icon(Icons.supervisor_account),
                onTap: () {
                  // Navigator.pop(context);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => GoogleMapExample()));
                }),
            Divider(),
            ListTile(
              title: Text("Maliyet Tablosu"),
              trailing: Icon(Icons.analytics_outlined),
              onTap: () async {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             // BubbleScreen()
                //             MaliyetPage()));
                var success = await showPassword(context);
                if (success) {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              // BubbleScreen()
                              MaliyetPage()));
                }
              },
            ),
            Divider(),
            ListTile(
                title: Text("Çıkış"),
                trailing: Icon(Icons.exit_to_app),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  // logOut();
                  // Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
