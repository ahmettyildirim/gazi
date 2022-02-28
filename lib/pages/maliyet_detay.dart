import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/custom_animation.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/common/helper.dart';
import 'package:gazi_app/model/maliyet.dart';
import 'package:gazi_app/pages/maliyet_add.dart';

class MaliyetDetay extends StatefulWidget {
  MaliyetDetay({Key? key, required this.maliyetTipId}) : super(key: key);
  int maliyetTipId;

  @override
  State<MaliyetDetay> createState() => _MaliyetDetayState();
}

var _repositoryInstance = DataRepository.instance;

class _MaliyetDetayState extends State<MaliyetDetay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getMaliyetDetayTitle(widget.maliyetTipId)),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          var tempModel = MaliyetModel(
                              maliyetTip: widget.maliyetTipId,
                              altMaliyetTip: 0,
                              toplamTutar: 0,
                              toplamSayi: 0);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      // BubbleScreen()
                                      MaliyetAdd(maliyet: tempModel)));
                        },
                        icon: Icon(Icons.add),
                        label: Text("Yeni Ekle"))
                  ],
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _repositoryInstance.getFilteredItemList(
                        CollectionKeys.maliyet,
                        filterName: FieldKeys.maliyetTip,
                        filterValue: widget.maliyetTipId,
                        orderBy: FieldKeys.createTime),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var maliyetValues =
                            snapshot.data!.docs.toList(); //.snapshot.value;
                        return ListView.builder(
                          itemCount: maliyetValues.length,
                          itemBuilder: (context, index) {
                            var maliyet = MaliyetModel.fromJson(
                                maliyetValues[index].data(),
                                id: maliyetValues[index].id);
                            // return ListTile(
                            //   dense: true,
                            //   title: Text(
                            //       getMaliyetDetayTitle(maliyet.maliyetTip)),
                            // );
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            // BubbleScreen()
                                            MaliyetAdd(
                                              maliyet: maliyet,
                                            )));
                              },
                              child: Card(
                                borderOnForeground: true,
                                child: ListTile(
                                  dense: false,
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(getMaliyetNameForList(
                                            maliyet.maliyetTip) +
                                        " :" +
                                        getMoneyString(maliyet.toplamTutar)),
                                  ),
                                  subtitle: Text(([1, 2]
                                              .contains(maliyet.maliyetTip)
                                          ? getToplamSayiAdi(
                                                  maliyet.maliyetTip) +
                                              " :" +
                                              maliyet.toplamSayi.toString() +
                                              "\n"
                                          : "") +
                                      ([1, 2, 3, 4, 5, 6, 7, 8]
                                              .contains(maliyet.maliyetTip)
                                          ? getAdetSayisiName(
                                                  maliyet.maliyetTip) +
                                              " :" +
                                              maliyet.adetSayisi.toString() +
                                              "\n"
                                          : "") +
                                      ([1, 2, 3, 4, 5, 6, 7, 8]
                                              .contains(maliyet.maliyetTip)
                                          ? getAdetTutar(maliyet.maliyetTip) +
                                              " :" +
                                              getMoneyString(maliyet.adetTutari)
                                          : "")),
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
                ),
              ],
            ),
          ),
        ));
  }
}
