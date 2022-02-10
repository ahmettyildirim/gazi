import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/hisse_kurban.dart';
import 'package:gazi_app/pages/add_kurban.dart';

class KurbanPage extends StatefulWidget {
  late bool selectable;
  late Function(HisseKurbanModel)? onHisseSelected;
  KurbanPage({
    Key? key,
    this.selectable = false,
    this.onHisseSelected,
  }) : super();
  @override
  _KurbanPageState createState() => _KurbanPageState();
}

var _repositoryInstance = DataRepository.instance;

class _KurbanPageState extends State<KurbanPage> {
  final _nameController = TextEditingController();
  bool isSwitched = true;
  String _searchText = "";
  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      if (_nameController.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _nameController.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0, bottom: 0),
            child: TextField(
              keyboardType:
                  TextInputType.numberWithOptions(decimal: true, signed: true),
              controller: _nameController,
              decoration:
                  InputDecoration(labelText: "Kurban numarası ile ara "),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Sadece Vekaletliler",
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                          overflow: TextOverflow.visible),
                      textAlign: TextAlign.center),
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    },
                    activeTrackColor: Colors.lightBlueAccent,
                    activeColor: Colors.blueAccent,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Dolu Hisseleri\nGösterme",
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                          overflow: TextOverflow.visible),
                      textAlign: TextAlign.center),
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    },
                    activeTrackColor: Colors.lightBlueAccent,
                    activeColor: Colors.blueAccent,
                  ),
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddKurban()));
                    setState(() {
                      // filterModel = val;
                    });
                  },
                  icon: Icon(Icons.add),
                  label: Text("Yeni Hisse ekle")),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _repositoryInstance.getAllItems(
                  CollectionKeys.hisseKurban,
                  orderBy: FieldKeys.hisseKurbanKurbanNo),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var kurbanValues = snapshot.data!.docs
                      .where((element) => element
                          .data()[FieldKeys.hisseKurbanKurbanNo]
                          .toString()
                          .contains(_searchText))
                      .toList(); //.snapshot.value;
                  return ListView.builder(
                    itemCount: kurbanValues.length,
                    itemBuilder: (context, index) {
                      var hisseKurban = HisseKurbanModel.fromJson(
                          kurbanValues[index].data(),
                          id: kurbanValues[index].id);
                      return Dismissible(
                        key: ObjectKey(hisseKurban),
                        child: GestureDetector(
                          onTap: () {
                            widget.onHisseSelected!(hisseKurban);
                            print("Kurban Selected");
                            Navigator.pop(context);
                          },
                          child: Card(
                            child: ListTile(
                                subtitle: Text(
                                    "Toplam Hisse: :${hisseKurban.hisseNo} ,Hisse Tutarı: :${hisseKurban.hisseAmount}\nKotra Numarası: :${hisseKurban.kotraNo}"),
                                title: Text(
                                    "Kalan Hisse Sayısı :${hisseKurban.remainingHisse}"),
                                leading: Text(
                                  hisseKurban.kurbanNo.toString(),
                                  style: TextStyle(fontSize: 30),
                                )),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
