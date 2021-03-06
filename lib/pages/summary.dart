import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/sale.dart';
import 'package:gazi_app/pages/maliyet.dart';

class SummaryPage extends StatefulWidget {
  @override
  _SummaryPageState createState() => _SummaryPageState();
}

var _repositoryInstance = DataRepository.instance;
final _formKey = GlobalKey<FormState>(debugLabel: '_AddSaleFormState');
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
  String totalSaleAmount = "";
  switch (index) {
    case 4:
      totalSaleAmount = getHisseKurbanAdet(values).toString();
      break;
    case 5:
    case 6:
      totalSaleAmount = getKucukKurbanAdet(values).toString();
      break;
    default:
      totalSaleAmount = values.length.toString();
      break;
  }

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
      padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "Satış Özetleri",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18,
              ),
            ),
            TextButton.icon(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.account_circle_outlined),
                label: Text("")),
          ]),
          Divider(
            height: 3,
          ),
          SizedBox(
            height: 5,
          ),
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
                            .where(
                                (element) => element.kurbanSubTip == index + 1)
                            .toList();
                        return GestureDetector(
                          onTap: () {},
                          child: ListTile(
                            dense: false,
                            leading: CircleAvatar(
                              backgroundImage:
                                  AssetImage(getImagePath(index + 1)),
                            ),
                            title: Text(getTitle(index + 1)),
                            subtitle: Text(getMainText(currentList, index + 1)),
                          ),
                        );
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

Future<bool> showPassword(BuildContext context) async {
  var _textPasswordController = TextEditingController();
  return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Kısıtlı Alan',
                style: TextStyle(fontSize: 15, color: Colors.blueGrey)),
            content: Form(
              key: _formKey,
              child: Container(
                child: TextFormField(
                  validator: _passwordValidator,
                  controller: _textPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(label: Text("Şifre")),
                ),
              ),
            ),
            actions: [
              ButtonBar(alignment: MainAxisAlignment.spaceBetween, children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        textStyle: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    child: Text(
                      "İptal",
                      style: TextStyle(fontSize: 12),
                    ),
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).pop(false);
                      });
                      // your code
                    }),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        textStyle: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    child: Text("Giriş", style: TextStyle(fontSize: 12)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_textPasswordController.text == "1234") {
                          Navigator.of(context)
                              .pop(_textPasswordController.text == "1234");
                        }
                      }
                    })
              ])
            ],
          );
        });
      });
}

String? _passwordValidator(String? text) {
  if (text != "1234") {
    return "Hatalı Şifre";
  }
  return null;
}

int getKucukKurbanAdet(List<SaleModel> list) {
  return list.where((element) => element.kurbanTip == 2).toList().fold(
      0,
      (previousValue, element) =>
          int.parse(previousValue.toString()) +
          (element.adet != 0 ? element.adet : 1));
}

int getHisseKurbanAdet(List<SaleModel> list) {
  return list.where((element) => element.kurbanSubTip == 4).toList().fold(
      0,
      (previousValue, element) =>
          int.parse(previousValue.toString()) + element.hisseNum);
}
