import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/common/helper.dart';
import 'package:gazi_app/model/customer.dart';
import 'package:gazi_app/model/sale.dart';
import 'package:gazi_app/pages/add_sale.dart';
import 'package:gazi_app/pages/sales_detail.dart';

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
  FilterModel filterModel = new FilterModel();
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

  Future<FilterModel> showFilterDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Filtreleme'),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile(
                      dense: true,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      title: Text("Büyükbaş"),
                      value: filterModel.buyukbasKurbanSelect,
                      onChanged: (val) {
                        setState(() {
                          filterModel.buyukbasKurbanSelect = val!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      title: Text("Küçükbaş"),
                      value: filterModel.kucukbasKurbanSelect,
                      onChanged: (val) {
                        setState(() {
                          filterModel.kucukbasKurbanSelect = val!;
                        });
                      },
                    ),
                    Divider(
                      height: 5.0,
                    ),
                    CheckboxListTile(
                      dense: true,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      title: Text("Büyükbaş Ayaktan(Kilo)"),
                      value: filterModel.buyukAyaktanKilo,
                      onChanged: (val) {
                        setState(() {
                          filterModel.buyukAyaktanKilo = val!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      title: Text("Büyükbaş Karkas"),
                      value: filterModel.buyukKarkas,
                      onChanged: (val) {
                        setState(() {
                          filterModel.buyukKarkas = val!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      title: Text("Büyükbaş Ayaktan"),
                      value: filterModel.buyukAyaktan,
                      onChanged: (val) {
                        setState(() {
                          filterModel.buyukAyaktan = val!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      title: Text("Büyükbaş Hisse"),
                      value: filterModel.buyukHisse,
                      onChanged: (val) {
                        setState(() {
                          filterModel.buyukHisse = val!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      title: Text("Küçükbaş Ayaktan(Kilo)"),
                      value: filterModel.kucukAyaktanKilo,
                      onChanged: (val) {
                        setState(() {
                          filterModel.kucukAyaktanKilo = val!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      title: Text("Küçükbaş Ayaktan"),
                      value: filterModel.kucukAyaktan,
                      onChanged: (val) {
                        setState(() {
                          filterModel.kucukAyaktan = val!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    child: Text("Filtreleri Temizle"),
                    onPressed: () {
                      setState(() {
                        filterModel.clear();
                      });
                      // your code
                    }),
                ElevatedButton(
                    child: Text("Onayla"),
                    onPressed: () {
                      Navigator.of(context).pop(filterModel);
                    })
              ],
            );
          });
        });
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> getFilteredResults(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> saleList,
      String filter,
      String filterValue) {
    return saleList
        .where((element) => (element.data()[filter].toString() == filterValue))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                  onPressed: () async {
                    var val = await showFilterDialog(context);
                    setState(() {
                      filterModel = val;
                    });
                  },
                  icon: Icon(Icons.filter_alt),
                  label: Text("Filtrele")),
              TextButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddSale()));
                  },
                  icon: Icon(Icons.add),
                  label: Text("Yeni Satış")),
              // TextButton.icon(
              //     onPressed: (_createExcel),
              //     icon: Icon(Icons.sort),
              //     label: Text("Sırala")),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _repositoryInstance.getAllItems(CollectionKeys.sales,
                  orderBy: FieldKeys.createTime, descending: true),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var saleValues = snapshot.data!.docs.toList();
                  if (_searchText.isNotEmpty) {
                    saleValues = getFilteredResults(
                        saleValues, FieldKeys.saleKurbanNo, _searchText);
                  } else {
                    if (filterModel.buyukbasKurbanSelect &&
                        !filterModel.kucukbasKurbanSelect) {
                      saleValues = getFilteredResults(
                          saleValues, FieldKeys.saleKurbanTip, "1");
                    } else if (!filterModel.buyukbasKurbanSelect &&
                        filterModel.kucukbasKurbanSelect) {
                      saleValues = getFilteredResults(
                          saleValues, FieldKeys.saleKurbanTip, "2");
                    }
                    if (filterModel.buyukAyaktan ||
                        filterModel.buyukAyaktanKilo ||
                        filterModel.buyukHisse ||
                        filterModel.buyukKarkas ||
                        filterModel.kucukAyaktan ||
                        filterModel.kucukAyaktanKilo) {
                      List<String> filteredList = [];
                      if (filterModel.buyukAyaktanKilo) {
                        filteredList.add("1");
                      }
                      if (filterModel.buyukKarkas) {
                        filteredList.add("2");
                      }
                      if (filterModel.buyukAyaktan) {
                        filteredList.add("3");
                      }
                      if (filterModel.buyukHisse) {
                        filteredList.add("4");
                      }
                      if (filterModel.kucukAyaktanKilo) {
                        filteredList.add("5");
                      }
                      if (filterModel.kucukAyaktan) {
                        filteredList.add("6");
                      }
                      var firstList = getFilteredResults(saleValues,
                          FieldKeys.saleKurbanSubTip, filteredList[0]);
                      var finalList = firstList;
                      for (int i = 1; i < filteredList.length; i++) {
                        firstList = getFilteredResults(saleValues,
                            FieldKeys.saleKurbanSubTip, filteredList[i]);
                        finalList += firstList;
                      }
                      finalList.sort((a, b) => a[FieldKeys.saleKurbanNo]
                          .compareTo(b[FieldKeys.saleKurbanNo]));
                      saleValues = finalList;
                    }
                  }

                  //.snapshot.value;
                  return ListView.builder(
                    itemCount: saleValues.length,
                    itemBuilder: (context, index) {
                      var sale = SaleModel.fromJson(saleValues[index].data(),
                          id: saleValues[index].id);
                      return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    // BubbleScreen()
                                    SaleDetails(
                                      sale: sale,
                                    ))),
                        child: Card(
                            child: ListTile(
                          title: Text(getKurbanTypeName(sale.kurbanTip) +
                              "-" +
                              getKurbanSubTypeName(sale.kurbanSubTip)),
                          subtitle: Text(
                              "Toplam tutar :${sale.kurbanSubTip == 3 ? sale.amount : sale.generalAmount} \nÖdenen tutar : ${sale.kaparo}\nMüşteri :${sale.customer.name}"),
                          leading: CircleAvatar(
                            backgroundImage:
                                AssetImage(getImagePath(sale.kurbanTip)),
                          ),
                          dense: false,
                          trailing: Column(
                            children: [
                              Text(
                                getFormattedDate(sale.createTime,
                                    format: "dd-MM-yyyy"),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                sale.kurbanNo.toString(),
                                style: TextStyle(fontSize: 23),
                              ),
                              Text(
                                getFormattedDate(sale.createTime,
                                    format: "HH-mm"),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        )),
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

class FilterModel {
  bool buyukbasKurbanSelect = false;
  bool kucukbasKurbanSelect = false;
  bool buyukAyaktanKilo = false;
  bool buyukKarkas = false;
  bool buyukAyaktan = false;
  bool buyukHisse = false;
  bool kucukAyaktanKilo = false;
  bool kucukAyaktan = false;
  FilterModel();

  void clear() {
    this.buyukbasKurbanSelect = false;
    this.kucukbasKurbanSelect = false;
    this.buyukAyaktanKilo = false;
    this.buyukKarkas = false;
    this.buyukAyaktan = false;
    this.buyukHisse = false;
    this.kucukAyaktanKilo = false;
    this.kucukAyaktan = false;
  }
}
