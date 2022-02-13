import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/kotra.dart';
import 'package:gazi_app/pages/add_kotra.dart';

class KotraList extends StatefulWidget {
  @override
  _KotraListState createState() => _KotraListState();
}

var _repositoryInstance = DataRepository.instance;

class _KotraListState extends State<KotraList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kotarlar"),
      ),
      body: Container(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddKotra()));
                },
                child: Text("Yeni Kotar Ekle")),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _repositoryInstance.getAllItems(CollectionKeys.kotra,
                    orderBy: FieldKeys.kotraNo),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var kotraValues = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: kotraValues.length,
                      itemBuilder: (context, index) {
                        var kotra =
                            KotraModel.fromJson(kotraValues[index].data());

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
