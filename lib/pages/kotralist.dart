import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/model/kotra.dart';
import 'package:gazi_app/pages/add_kotra.dart';

class KotraList extends StatefulWidget {
  @override
  _KotraListState createState() => _KotraListState();
}

var refCustomers = FirebaseDatabase.instance.reference().child("kotra");

class _KotraListState extends State<KotraList> {
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
                      MaterialPageRoute(builder: (context) => AddKotra()));
                },
                child: Text("Yeni Kota Ekle")),
            Expanded(
              child: StreamBuilder<Event>(
                stream: refCustomers.onValue,
                builder: (context, event) {
                  if (event.hasData) {
                    var kotras = <Kotra>[];
                    var kotraValues = event.data!.snapshot.value;
                    if (kotraValues != null) {
                      kotraValues.forEach((key, value) {
                        var kotra = Kotra.fromJson(value);
                        kotras.add(kotra);
                      });
                    }
                    return ListView.builder(
                      itemCount: kotras.length,
                      itemBuilder: (context, index) {
                        var kotra = kotras[index];

                        return Card(
                          child: ListTile(
                              leading: Text(
                                kotra.no.toString(),
                                style: TextStyle(fontSize: 40),
                              ),
                              title: Text(
                                  "Toplam Kapasite : ${kotra.capacity.toString()}"),
                              subtitle: Text(
                                  "Doluluk oranı :%${(kotra.numOfItems / kotra.capacity * 100).toInt()}      (Dolu:${kotra.numOfItems} - Boş: ${(kotra.capacity - kotra.numOfItems)})")),
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
