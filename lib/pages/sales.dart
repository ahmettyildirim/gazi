import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/main.dart';
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
String order = "";

String getImagePath(int index) {
  if (index == 1) {
    return "images/dana.jpg";
  } else {
    return "images/sheep.JPG";
  }
}

class _SalesListState extends State<SalesList> {
  final _nameController = TextEditingController();
  final _createUserController = TextEditingController();
  String _searchText = "";
  int _searchIndex = 0;
  //0 tarih yeniden eskiye, 1 tarih eskiden yeniye, 2 kurban no küçükten büyüğe/ 3 kurban no büyükten küçüğe

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
    _createUserController.addListener(() {
      if (_createUserController.text.isEmpty) {
        setState(() {
          filterModel.createUser = "";
        });
      } else {
        setState(() {
          filterModel.createUser = _createUserController.text;
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
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        controller: _createUserController,
                        decoration:
                            InputDecoration(labelText: "Satış Yapan Kişi "),
                        style: TextStyle(
                            fontSize: 14, height: 0.5, color: Colors.black)),
                    Divider(
                      height: 5.0,
                    ),
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
                    Divider(
                      height: 5.0,
                    ),
                    CheckboxListTile(
                      dense: true,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      title: Text("Ödemesi Tamamlananları Gösterme"),
                      value: filterModel.onlyRemaining,
                      onChanged: (val) {
                        setState(() {
                          filterModel.onlyRemaining = val!;
                        });
                      },
                    ),
                    Divider(
                      height: 5.0,
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton.icon(
                    label: Text("Filtreleri Temizle"),
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        filterModel.clear();
                        _createUserController.text = "";
                      });
                      // your code
                    }),
                ElevatedButton.icon(
                    label: Text("Uygula"),
                    icon: Icon(Icons.check),
                    onPressed: () {
                      Navigator.of(context).pop(filterModel);
                    })
              ],
            );
          });
        });
  }

  List<String> radioGroupOrderValues = [
    'Tarih (Yeniden Eskiye)',
    'Tarih (Eskiden Yeniye)',
    'Kurban No (Küçükten Büyüğe)',
    'Kurban No (Büyükten Küçüğe)'
  ];
  Future<int> showOrderDialog(BuildContext context) async {
    var _currentIndex = _searchIndex;
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState2) {
              return AlertDialog(
                title: Text('Sıralama'),
                actions: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context, _searchIndex);
                    },
                    icon: Icon(Icons.clear),
                    label: Text('İptal'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context, _currentIndex);
                    },
                    icon: Icon(Icons.check),
                    label: Text('Uygula'),
                  ),
                ],
                content: Container(
                  width: double.minPositive,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: radioGroupOrderValues.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RadioListTile(
                        value: index,
                        groupValue: _currentIndex,
                        title: Text(radioGroupOrderValues[index]),
                        onChanged: (val) {
                          setState2(() {
                            _currentIndex = index;
                          });
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        });
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> getFilteredResults(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> saleList,
      String filter,
      String filterValue,
      {bool equal = true}) {
    return equal
        ? saleList
            .where(
                (element) => (element.data()[filter].toString() == filterValue))
            .toList()
        : saleList
            .where(
                (element) => (element.data()[filter].toString() != filterValue))
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    String _orderBy = _searchIndex == 0 || _searchIndex == 1
        ? FieldKeys.createTime
        : FieldKeys.saleKurbanNo;
    bool _orderByDescending = _searchIndex == 0 || _searchIndex == 3;
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
              TextButton.icon(
                  onPressed: () async {
                    var val = await showOrderDialog(context);
                    setState(() {
                      _searchIndex = val;
                    });
                  },
                  icon: Icon(Icons.sort),
                  label: Text("Sırala")),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _repositoryInstance.getAllItems(CollectionKeys.sales,
                  orderBy: _orderBy, descending: _orderByDescending),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var saleValues = snapshot.data!.docs.toList();
                  if (_searchText.isNotEmpty) {
                    saleValues = getFilteredResults(
                        saleValues, FieldKeys.saleKurbanNo, _searchText);
                  } else {
                    if (filterModel.createUser.isNotEmpty) {
                      saleValues = getFilteredResults(saleValues,
                          FieldKeys.createUser, filterModel.createUser);
                    }
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
                      !_orderByDescending
                          ? finalList.sort(
                              (a, b) => a[_orderBy].compareTo(b[_orderBy]))
                          : finalList.sort(
                              (a, b) => b[_orderBy].compareTo(a[_orderBy]));
                      saleValues = finalList;
                    }
                    if (filterModel.onlyRemaining) {
                      saleValues = getFilteredResults(
                          saleValues, FieldKeys.saleRemainingAmount, "0",
                          equal: false);
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
                            color: sale.remainingAmount > 0
                                ? Color.fromARGB(255, 255, 230, 230)
                                : Color.fromARGB(255, 230, 255, 230),
                            child: ListTile(
                              title: Text(getKurbanTypeName(sale.kurbanTip) +
                                  "-" +
                                  getKurbanSubTypeName(sale.kurbanSubTip)),
                              subtitle: Text(
                                  "Müşteri :${sale.customer.name}\nToplam Tutar :${sale.kurbanSubTip == 3 ? sale.amount : sale.generalAmount} \nÖdenen Tutar : ${sale.kaparo}\nKalan Tutar : ${sale.remainingAmount}"),
                              leading: CircleAvatar(
                                backgroundImage:
                                    AssetImage(getImagePath(sale.kurbanTip)),
                              ),
                              dense: false,
                              trailing: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    sale.kurbanNo.toString(),
                                    style: TextStyle(fontSize: 23),
                                  ),
                                  Text(
                                    getFormattedDate(sale.createTime,
                                        format: "HH:mm"),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    getFormattedDate(sale.createTime,
                                        format: "dd-MM-yyyy"),
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
  bool onlyRemaining = false;
  String createUser = "";

  void clear() {
    this.buyukbasKurbanSelect = false;
    this.kucukbasKurbanSelect = false;
    this.buyukAyaktanKilo = false;
    this.buyukKarkas = false;
    this.buyukAyaktan = false;
    this.buyukHisse = false;
    this.kucukAyaktanKilo = false;
    this.kucukAyaktan = false;
    this.onlyRemaining = false;
    this.createUser = "";
  }
}
