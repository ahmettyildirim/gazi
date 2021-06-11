import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/model/customer.dart';
import 'package:gazi_app/pages/add_customer.dart';
import 'package:gazi_app/pages/add_kurban.dart';

class KurbanPage extends StatefulWidget {
  @override
  _KurbanPageState createState() => _KurbanPageState();
}

class _KurbanPageState extends State<KurbanPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Müşteri Adı ya da cep telefonu ile filtrele",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddKurban()));
              },
              child: Text("Yeni Kurban Ekle")),
        ],
      ),
    );
  }
}
