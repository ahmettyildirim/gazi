import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/sale.dart';

class SummaryPage extends StatefulWidget {
  @override
  _SummaryPageState createState() => _SummaryPageState();
}

var _repositoryInstance = DataRepository.instance;
String getTitle(int index) {
  switch (index) {
    case 1:
      return "Ayaktan Kilo";
    case 2:
      return "Karkas";
    case 3:
      return "Ayaktan";
    case 4:
      return "Hisse";
    case 5:
      return "Ayaktan Kilo";
    case 6:
      return "Ayaktan";
    default:
      return "";
  }
}

String getImagePath(int index) {
  if (index < 5) {
    return "images/dana.jpg";
  } else {
    return "images/sheep.JPG";
  }
}

String getMainText(List<SaleModel> values, int index) {
  String totalSaleAmount = index != 6
      ? values.length.toString()
      : getKucukKurbanAdet(values).toString();
  String totalPaidAmount = values
      .toList()
      .fold(
          0,
          (previousValue, element) =>
              int.parse(previousValue.toString()) + element.kaparo)
      .toString();
  String totalRemainingAmount = values
      .toList()
      .fold(
          0,
          (previousValue, element) =>
              int.parse(previousValue.toString()) + element.remainingAmount)
      .toString();
  return "Satış Adeti :" +
      totalSaleAmount +
      "\nÖdenen Tutar: " +
      totalPaidAmount +
      "\nKalan Tutar:" +
      totalRemainingAmount;
}

class _SummaryPageState extends State<SummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top:40, left:10, right:10, bottom:10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10),
              child: Text(
            "Satış Özetleri",
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 23,
            ),
          )),
          Expanded(
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

                  return ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider(height: 15);
                      },
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var currentList = salelist
                            .where((element) => element.kurbanSubTip == index + 1)
                            .toList();
                        if (index > 5) {
                          return ListTile(
                            dense: false,
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(getImagePath(3 + 1)),
                            ),
                            title: Text(getTitle(3 + 1)),
                            subtitle: Text(getMainText(currentList, 3 + 1)),
                          );
                        } else {
                          return ListTile(
                            dense: false,
                            leading: CircleAvatar(
                              backgroundImage:
                                  AssetImage(getImagePath(index + 1)),
                            ),
                            title: Text(getTitle(index + 1)),
                            subtitle: Text(getMainText(currentList, index + 1)),
                          );
                        }
                      },
                      itemCount: 6,
                      padding: EdgeInsets.all(5),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical);
                } else {
                  return Center();
                }
              },
            ),
          ),
        ],
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
