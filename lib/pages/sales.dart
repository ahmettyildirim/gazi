import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/customer.dart';
import 'package:gazi_app/model/sale.dart';
import 'package:gazi_app/pages/add_customer.dart';

class SalesList extends StatefulWidget {
  late bool selectable;
  late Function(CustomerModel)? onCustomerSelected;
  SalesList({
    Key? key,
    this.onCustomerSelected,
  }) : super();
  _SalesListState createState() => _SalesListState();
}

var _repositoryInstance = DataRepository.instance;
Future<void> getCustomersNew() async {}

String getImagePath(int index) {
  if (index == 1) {
    return "images/dana.jpg";
  } else {
    return "images/sheep.JPG";
  }
}

class _SalesListState extends State<SalesList> {
  final _nameController = TextEditingController();
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
            padding: EdgeInsets.all(10.0),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _nameController,
              decoration:
                  InputDecoration(labelText: "Kurban numarası ile ara.."),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.filter_alt),
                  label: Text("Filtrele")),
              TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.sort),
                  label: Text("Sırala")),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _repositoryInstance.getAllItems(CollectionKeys.sales,
                  orderBy: FieldKeys.saleKurbanNo),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var saleValues = snapshot.data!.docs.toList();
                  if (_searchText.isNotEmpty) {
                    saleValues = saleValues
                        .where((element) => (element
                                .data()[FieldKeys.saleKurbanNo]
                                .toString() ==
                            _searchText))
                        .toList();
                  }
                  //.snapshot.value;
                  return ListView.builder(
                    itemCount: saleValues.length,
                    itemBuilder: (context, index) {
                      var sale = SaleModel.fromJson(saleValues[index].data());
                      return Dismissible(
                        key: ObjectKey(sale),
                        child: GestureDetector(
                          onTap: () {},
                          child: Card(
                              child: ListTile(
                            title: Text(getKurbanTypeName(sale.kurbanTip) +
                                "-" +
                                getKurbanSubTypeName(sale.kurbanSubTip)),
                            subtitle: Text(
                                "Toplam tutar :${sale.generalAmount} \nÖdenen tutar : ${sale.kaparo}"),
                            leading: CircleAvatar(
                              backgroundImage:
                                  AssetImage(getImagePath(sale.kurbanTip)),
                            ),
                            trailing: Text(
                              sale.kurbanNo.toString(),
                              style: TextStyle(fontSize: 22),
                            ),
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
