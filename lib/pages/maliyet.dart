import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/custom_animation.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/common/helper.dart';
import 'package:gazi_app/model/maliyet.dart';
import 'package:gazi_app/model/sale.dart';
import 'package:gazi_app/pages/maliyet_detay.dart';

class MaliyetPage extends StatefulWidget {
  MaliyetPage({Key? key}) : super(key: key);

  @override
  State<MaliyetPage> createState() => _MaliyetPageState();
}

var _repositoryInstance = DataRepository.instance;

int _totalMaliyet = 0;
int _danaTotal = 0;
int _kuzuTotal = 0;

getTotalSales() async {
  var sales = await _repositoryInstance
      .getCollectionReference(CollectionKeys.sales)
      .where(FieldKeys.festYear, isEqualTo: SystemVariables.currentYear)
      .get();
  var saleValues = sales.docs;
  var length = saleValues.length;
  List<SaleModel> salelist = List.empty(growable: true); 
  for (int i = 0; i < length; i++) {
    salelist.add(SaleModel.fromJson(saleValues[i].data()));
  }
  var danaList = salelist.where((element) => element.kurbanTip == 1);
  var kuzuList = salelist.where((element) => element.kurbanTip == 2);
  _danaTotal = danaList.toList().fold(
      0,
      (previousValue, element) =>
          previousValue +
          (element.kurbanSubTip == 3 ? element.amount : element.generalAmount));
  _kuzuTotal = kuzuList.toList().fold(
      0, (previousValue, element) => previousValue + element.generalAmount);
}

class _MaliyetPageState extends State<MaliyetPage> {
  @override
  Widget build(BuildContext context) {
    getTotalSales();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Maliyetler"),
      ),
      body: SafeArea(
          bottom: true,
          top: true,
          left: true,
          right: true,
          minimum: EdgeInsets.only(top: 20, bottom: 20, left: 8, right: 8),
          child: Column(
            children: [
              Container(
                child: Flexible(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: _repositoryInstance
                          .getAllItems(CollectionKeys.maliyet),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var maliyetValues = snapshot.data!.docs;
                          var length = maliyetValues.length;
                          List<MaliyetModel> maliyetlist =
                              List.empty(growable: true);
                          for (int i = 0; i < length; i++) {
                            maliyetlist.add(MaliyetModel.fromJson(
                                maliyetValues[i].data(),
                                id: maliyetValues[i].id));
                          }
                          _totalMaliyet = maliyetlist.fold(
                              0,
                              (previousValue, element) =>
                                  previousValue + element.toplamTutar);

                          return ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                var filterMaliyet = maliyetlist
                                    .where((element) =>
                                        element.maliyetTip == index + 1)
                                    .toList();
                                // MaliyetModel maliyet = filterMaliyet.isNotEmpty
                                //     ? filterMaliyet.first
                                //     : MaliyetModel(
                                //         maliyetTip: index + 1,
                                //         altMaliyetTip: 0,
                                //         toplamTutar: 0,
                                //         toplamSayi: 0);

                                return index == 21
                                    ? SizedBox(
                                        height: height / 25,
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: index == 20
                                                ? Colors.blue
                                                : Colors.white),
                                        child: ListTile(
                                          title: Container(
                                              width: width / 4,
                                              child: Text(
                                                  getMaliyetName(index + 1),
                                                  style: TextStyle(
                                                      fontSize: index >= 17
                                                          ? width / 17
                                                          : width / 25))),
                                          dense: true,
                                          trailing: index == 17
                                              ? Text(
                                                  getMoneyString(_totalMaliyet),
                                                  style: TextStyle(
                                                      fontSize: width / 17),
                                                )
                                              : index == 18
                                                  ? Text(
                                                      getMoneyString(
                                                          _danaTotal),
                                                      style: TextStyle(
                                                          fontSize: width / 17))
                                                  : index == 19
                                                      ? Text(
                                                          getMoneyString(
                                                              _kuzuTotal),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  width / 17))
                                                      : index == 20
                                                          ? Text(
                                                              getMoneyString(
                                                                  (_danaTotal +
                                                                      _kuzuTotal -
                                                                      _totalMaliyet)),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      width /
                                                                          17))
                                                          : TextButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            // BubbleScreen()
                                                                            MaliyetDetay(maliyetTipId: index + 1)));
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    getMoneyString(
                                                                        getToplamTutar(
                                                                            filterMaliyet)),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            width /
                                                                                25),
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        width /
                                                                            100,
                                                                  ), // <-- Text

                                                                  Icon(
                                                                    // <-- Icon
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    size:
                                                                        width /
                                                                            25,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                          // onPressed: () {},
                                          // icon: Icon(Icons.arrow_forward_ios,
                                          //     textDirection: TextDirection.ltr),
                                          // label: Text((index * 12500).toString() + " TL"))
                                        ),
                                      );
                              },
                              physics: const AlwaysScrollableScrollPhysics(),
                              separatorBuilder: (context, index) {
                                return Divider(
                                  height: 5,
                                  thickness: 1,
                                );
                              },
                              itemCount: 22);
                        } else {
                          return Center();
                        }
                      }),
                ),
              ),
              Divider(
                height: 10,
              ),
            ],
          )),
    );
  }

  int getToplamTutar(List<MaliyetModel> maliyetList) {
    if (maliyetList.isEmpty) {
      return 0;
    }
    return maliyetList.fold(
        0, (previousValue, element) => previousValue + element.toplamTutar);
  }
}
