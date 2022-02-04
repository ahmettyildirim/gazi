import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/sale.dart';

class SummaryPage extends StatefulWidget {
  @override
  _SummaryPageState createState() => _SummaryPageState();
}

var _repositoryInstance = DataRepository.instance;

class _SummaryPageState extends State<SummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 100, bottom: 200, left: 20),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _repositoryInstance.getAllItems(CollectionKeys.sales),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var saleValues = snapshot.data!.docs;
                var length = saleValues.length;
                List<SaleModel> salelist = List.empty(growable: true);
                for (int i = 0; i < length; i++) {
                  salelist.add(SaleModel.fromJson(saleValues[i].data()));
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Büyükbaş",
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      "Ayaktan Kilo",
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Toplam Satış Adeti: "),
                        Text(salelist
                            .where((element) => element.kurbanSubTip == 1)
                            .length
                            .toString())
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Ödenen Kaparo : "),
                        Text(salelist
                            .where((element) => element.kurbanSubTip == 1)
                            .toList()
                            .fold(
                                0,
                                (previousValue, element) =>
                                    int.parse(previousValue.toString()) +
                                    element.kaparo)
                            .toString())
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Kalan Para : "),
                        Text(salelist
                            .where((element) => element.kurbanSubTip == 1)
                            .toList()
                            .fold(
                                0,
                                (previousValue, element) =>
                                    int.parse(previousValue.toString()) +
                                    element.remainingAmount)
                            .toString())
                      ],
                    ),
                    Text(
                      "Karkas",
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Toplam Satış Adeti: "),
                        Text(salelist
                            .where((element) => element.kurbanSubTip == 2)
                            .length
                            .toString())
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Ödenen Kaparo : "),
                        Text(salelist
                            .where((element) => element.kurbanSubTip == 2)
                            .toList()
                            .fold(
                                0,
                                (previousValue, element) =>
                                    int.parse(previousValue.toString()) +
                                    element.kaparo)
                            .toString())
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Kalan Para : "),
                        Text(salelist
                            .where((element) => element.kurbanSubTip == 2)
                            .toList()
                            .fold(
                                0,
                                (previousValue, element) =>
                                    int.parse(previousValue.toString()) +
                                    element.remainingAmount)
                            .toString())
                      ],
                    ),
                    Text(
                      "Ayaktan",
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Toplam Satış Adeti: "),
                        Text(salelist
                            .where((element) => element.kurbanSubTip == 3)
                            .length
                            .toString())
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Ödenen Kaparo : "),
                        Text(salelist
                            .where((element) => element.kurbanSubTip == 3)
                            .toList()
                            .fold(
                                0,
                                (previousValue, element) =>
                                    int.parse(previousValue.toString()) +
                                    element.kaparo)
                            .toString())
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Kalan Para : "),
                        Text(salelist
                            .where((element) => element.kurbanSubTip == 3)
                            .toList()
                            .fold(
                                0,
                                (previousValue, element) =>
                                    int.parse(previousValue.toString()) +
                                    element.remainingAmount)
                            .toString())
                      ],
                    ),
                    Text(
                      "Hisse",
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Toplam Satış Adeti: "),
                        Text(salelist
                            .where((element) => element.kurbanSubTip == 4)
                            .toList()
                            .fold(
                                0,
                                (previousValue, element) =>
                                    int.parse(previousValue.toString()) +
                                    element.hisseNum)
                            .toString())
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Ödenen Kaparo : "),
                        Text(salelist
                            .where((element) => element.kurbanSubTip == 4)
                            .toList()
                            .fold(
                                0,
                                (previousValue, element) =>
                                    int.parse(previousValue.toString()) +
                                    element.kaparo)
                            .toString())
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Kalan Para : "),
                        Text(salelist
                            .where((element) => element.kurbanSubTip == 4)
                            .toList()
                            .fold(
                                0,
                                (previousValue, element) =>
                                    int.parse(previousValue.toString()) +
                                    element.remainingAmount)
                            .toString())
                      ],
                    ),
                    Text(
                      "Küçükbaş",
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      "Ayaktan Kilo",
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Toplam Satış Adeti: "),
                        Text(salelist
                            .where((element) => element.kurbanSubTip == 5)
                            .length
                            .toString())
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Ödenen Kaparo : "),
                        Text(salelist
                            .where((element) => element.kurbanSubTip == 5)
                            .toList()
                            .fold(
                                0,
                                (previousValue, element) =>
                                    int.parse(previousValue.toString()) +
                                    element.kaparo)
                            .toString())
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Kalan Para : "),
                        Text(salelist
                            .where((element) => element.kurbanSubTip == 5)
                            .toList()
                            .fold(
                                0,
                                (previousValue, element) =>
                                    int.parse(previousValue.toString()) +
                                    element.remainingAmount)
                            .toString())
                      ],
                    ),
                    Text(
                      "Ayaktan",
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Toplam Satış Adeti: "),
                        Text(getKucukKurbanAdet(salelist).toString())
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Ödenen Kaparo : "),
                        Text(salelist
                            .where((element) => element.kurbanSubTip == 6)
                            .toList()
                            .fold(
                                0,
                                (previousValue, element) =>
                                    int.parse(previousValue.toString()) +
                                    element.kaparo)
                            .toString())
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Kalan Para : "),
                        Text(salelist
                            .where((element) => element.kurbanSubTip == 6)
                            .toList()
                            .fold(
                                0,
                                (previousValue, element) =>
                                    int.parse(previousValue.toString()) +
                                    element.remainingAmount)
                            .toString())
                      ],
                    ),
                    Text(salelist
                        .where((element) => element.buyukKurbanTip == 2)
                        .length
                        .toString())
                  ],
                );
              } else {
                return Center();
              }
            },
          ),
        ),
      ),
    );
  }
}

int getKucukKurbanAdet(List<SaleModel> list) {
  return list.where((element) => element.kurbanSubTip == 6).toList().fold(
      0,
      (previousValue, element) =>
          int.parse(previousValue.toString()) + element.adet);
}
