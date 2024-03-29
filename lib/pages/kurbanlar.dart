import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/hisse_kurban.dart';
import 'package:gazi_app/pages/add_kurban.dart';
import 'package:gazi_app/pages/hisse_detail.dart';

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
  final _amountController = TextEditingController();
  bool isOnlyEmpty = true;
  bool isVekaletSelected = false;
  String _searchText = "";
  String _searchAmountText = "";
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
    _amountController.addListener(() {
      if (_amountController.text.isEmpty) {
        setState(() {
          _searchAmountText = "";
        });
      } else {
        setState(() {
          _searchAmountText = _amountController.text;
        });
      }
    });
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> getFilteredResults(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> saleList,
      String filter,
      dynamic filterValue,
      {bool notEqual = false}) {
    if (notEqual) {
      return saleList
          .where((element) => (element.data()[filter] != filterValue))
          .toList();
    }
    return saleList
        .where((element) => (element.data()[filter] == filterValue))
        .toList();
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
                EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0, bottom: 0),
            child: TextField(
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                controller: _nameController,
                decoration:
                    InputDecoration(labelText: "Kurban numarası ile ara "),
                style:
                    TextStyle(fontSize: 14, height: 0.5, color: Colors.black)),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: 0, left: 10.0, right: 10.0, bottom: 0),
            child: TextField(
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                controller: _amountController,
                decoration: InputDecoration(labelText: "Hisse tutarı ile ara "),
                style:
                    TextStyle(fontSize: 14, height: 0.5, color: Colors.black)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Sadece Vekaletliler",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          overflow: TextOverflow.visible),
                      textAlign: TextAlign.center),
                  Switch(
                    value: isVekaletSelected,
                    onChanged: (value) {
                      setState(() {
                        isVekaletSelected = value;
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
                          fontSize: 12,
                          color: Colors.blue,
                          overflow: TextOverflow.visible),
                      textAlign: TextAlign.center),
                  Switch(
                    value: isOnlyEmpty,
                    onChanged: (value) {
                      setState(() {
                        isOnlyEmpty = value;
                      });
                    },
                    activeTrackColor: Colors.lightBlueAccent,
                    activeColor: Colors.blueAccent,
                  ),
                ],
              )
            ],
          ),
          Center(
            child: TextButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddKurban()));
                  setState(() {
                    // filterModel = val;
                  });
                },
                icon: Icon(Icons.add),
                label: Text("Yeni Hisse eskle")),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _repositoryInstance.getAllItems(
                  CollectionKeys.hisseKurban,
                  orderBy: FieldKeys.hisseKurbanKurbanNo),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var kurbanValues = snapshot.data!.docs.toList();
                  if (_searchText.isNotEmpty &&
                      int.tryParse(_searchText) != null) {
                    kurbanValues = getFilteredResults(
                        kurbanValues,
                        FieldKeys.hisseKurbanKurbanNo,
                        int.tryParse(_searchText));
                  } else {
                    if (isVekaletSelected) {
                      kurbanValues = getFilteredResults(
                          kurbanValues, FieldKeys.isVekalet, true);
                    }
                    if (isOnlyEmpty) {
                      kurbanValues = getFilteredResults(
                          kurbanValues, FieldKeys.hisseKurbanRemainingHisse, 0,
                          notEqual: true);
                    }
                  }
                  if (_searchAmountText.isNotEmpty &&
                      int.tryParse(_searchAmountText) != null) {
                    kurbanValues = getFilteredResults(
                        kurbanValues,
                        FieldKeys.hisseKurbanHisseAmount,
                        int.tryParse(_searchAmountText));
                  }
                  return ListView.builder(
                    itemCount: kurbanValues.length,
                    itemBuilder: (context, index) {
                      var hisseKurban = HisseKurbanModel.fromJson(
                          kurbanValues[index].data(),
                          id: kurbanValues[index].id);
                      return GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           // BubbleScreen()
                          //           HisseDetail(
                          //             hisse: hisseKurban,
                          //           )));
                          if (widget.onHisseSelected != null) {
                            widget.onHisseSelected!(hisseKurban);
                            Navigator.pop(context);
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        // BubbleScreen()
                                        HisseDetail(
                                          hisse: hisseKurban,
                                        )));
                          }
                        },
                        onLongPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      // BubbleScreen()
                                      HisseDetail(
                                        hisse: hisseKurban,
                                      )));
                        },
                        child: Card(
                          color: hisseKurban.remainingHisse == 0
                              ? Colors.red
                              : Colors.white,
                          child: ListTile(
                              subtitle: Text(
                                "Toplam Hisse :${hisseKurban.hisseNo}, Hisse Tutarı :${hisseKurban.hisseAmount}\nAçıklama :${hisseKurban.aciklama}",
                                style: TextStyle(
                                    color: hisseKurban.remainingHisse == 0
                                        ? Colors.white60
                                        : Color.fromARGB(255, 45, 82, 104)),
                              ),
                              title: Text(
                                  "Kalan Hisse Sayısı :${hisseKurban.remainingHisse}",
                                  style: TextStyle(
                                      color: hisseKurban.remainingHisse == 0
                                          ? Colors.white
                                          : Color.fromARGB(236, 9, 13, 49))),
                              leading: Text(
                                hisseKurban.kurbanNo.toString(),
                                style: TextStyle(
                                    fontSize: 30,
                                    color: hisseKurban.isVekalet == true
                                        ? Colors.blueAccent[100]
                                        : Color.fromARGB(255, 3, 2, 51)),
                              )),
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
