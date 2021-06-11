import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/hisse.dart';
import 'package:gazi_app/pages/add_hisse.dart';

class HisseList extends StatefulWidget {
  @override
  _HisseListState createState() => _HisseListState();
}

var _repositoryInstance = DataRepository.instance;

class _HisseListState extends State<HisseList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hisseler"),
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
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _repositoryInstance.getAllItems(CollectionKeys.hisse),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var hisseValues = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: hisseValues.length,
                      itemBuilder: (context, index) {
                        var hisse =
                            HisseModel.fromJson(hisseValues[index].data());
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
