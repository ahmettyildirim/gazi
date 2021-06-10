import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/model/hisse.dart';
import 'package:gazi_app/pages/add_hisse.dart';

class HisseList extends StatefulWidget {
  @override
  _HisseListState createState() => _HisseListState();
}

var refHisse = FirebaseDatabase.instance.reference().child("hisse");

class _HisseListState extends State<HisseList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kotralar"),
      ),
      body: Container(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddHisse()));
                },
                child: Text("Yeni Hisse Ekle")),
            Expanded(
              child: StreamBuilder<Event>(
                stream: refHisse.onValue,
                builder: (context, event) {
                  if (event.hasData) {
                    var hisseler = <Hisse>[];
                    var kotraValues = event.data!.snapshot.value;
                    if (kotraValues != null) {
                      kotraValues.forEach((key, value) {
                        var hisse = Hisse.fromJson(value);
                        hisseler.add(hisse);
                      });
                    }
                    return ListView.builder(
                      itemCount: hisseler.length,
                      itemBuilder: (context, index) {
                        var hisse = hisseler[index];

                        return Card(
                          child: ListTile(
                              title: Text(
                                  "Hisse tutarı : ${hisse.amount.toString()}"),
                              subtitle:
                                  Text("Max hisse sayısı :${hisse.count}")),
                        );
                      },
                    );
                  } else {
                    return Center();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
