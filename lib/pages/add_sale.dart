import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/customer.dart';
import 'package:gazi_app/model/hisse.dart';
import 'package:gazi_app/pages/customer_Select.dart';

class AddSale extends StatefulWidget {
  @override
  _AddSaleState createState() => _AddSaleState();
}

var _repositoryInstance = DataRepository.instance;

class _AddSaleState extends State<AddSale> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_AddHisseFormState');
  final _saleNoController = TextEditingController();
  final _customerController = TextEditingController();
  final _kgController = TextEditingController();
  final _kgAmountController = TextEditingController();
  final _kaparoController = TextEditingController();
  final _kalanTutarController = TextEditingController();
  final _hisseCountController = TextEditingController();
  int _kurbanTip = 0;
  int _kurbanSubTip = 0;
  Color _inActiveColor = Colors.blue.shade100;
  Color _activeColor = Colors.blue.shade700;
  Color _inActiveFontColor = Colors.grey.shade700;
  Color _activeFontColor = Colors.grey.shade50;
  CustomerModel? selectedCustomer;
  HisseModel? _selectedHisse;

  void _selectCustomer(CustomerModel customer) {
    setState(() {
      _customerController.text = customer.name;
      selectedCustomer = customer;
    });
  }

  void _changeKurbanTip() {}

  @override
  Widget build(BuildContext context) {
    var screenInfo = MediaQuery.of(context);
    final screenWidth = screenInfo.size.width;
    final screenHeight = screenInfo.size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni Satış"),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.all(screenHeight / 30),
                child: TextFormField(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerSelect(
                                  onCustomerSelected: _selectCustomer,
                                )));
                  },
                  keyboardType: TextInputType.number,
                  controller: _customerController,
                  decoration: InputDecoration(
                      hintText: 'Müşteri Seçmek İçin Buraya Tıklayın'),
                  readOnly: true,
                ),
              ),
              selectedCustomer != null ? _getTypeMenu(screenWidth) : Center(),
              _kurbanTip == 1
                  ? _getBuyukbasSubmenu(screenWidth)
                  : _kurbanTip == 2
                      ? _getKucukbasSubmenu(screenWidth)
                      : Center(),
              _kurbanSubTip != 0
                  ? _getNum(screenWidth, screenHeight)
                  : Center(),
              [0, 6].contains(_kurbanSubTip)
                  ? Center()
                  : _getKg(screenWidth, screenHeight),
              [0, 6].contains(_kurbanSubTip)
                  ? Center()
                  : _getKgAmount(screenWidth, screenHeight),
              [0].contains(_kurbanSubTip)
                  ? Center()
                  : _getKaparo(screenWidth, screenHeight),
              [0].contains(_kurbanSubTip)
                  ? Center()
                  : _getKalanTutar(screenWidth, screenHeight),
              ![4].contains(_kurbanSubTip)
                  ? Center()
                  : _getHisseType(screenWidth, screenHeight),
              ![4].contains(_kurbanSubTip)
                  ? Center()
                  : _getHisse(screenWidth, screenHeight),
              Padding(
                  padding: EdgeInsets.all(screenHeight / 30),
                  child: ElevatedButton(onPressed: () {}, child: Text("Ekle"))),
            ],
          ),
        ),
      )),
    );
  }

  Widget _getTypeMenu(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _kurbanTip = _kurbanTip == 1 ? 0 : 1;
              _kurbanSubTip = 0;
            });
          },
          child: SizedBox(
            width: screenWidth / 3,
            height: 40,
            child: Container(
              alignment: Alignment.center,
              color: _kurbanTip == 1 ? _activeColor : _inActiveColor,
              child: Text(
                "Büyükbaş",
                style: TextStyle(
                    color:
                        _kurbanTip == 1 ? _activeFontColor : _inActiveFontColor,
                    fontSize: screenWidth / 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _kurbanTip = _kurbanTip == 2 ? 0 : 2;
              _kurbanSubTip = 0;
            });
          },
          child: SizedBox(
            width: screenWidth / 3,
            height: 40,
            child: Container(
              alignment: Alignment.center,
              color: _kurbanTip == 2 ? _activeColor : _inActiveColor,
              child: Text(
                "Küçükbaş",
                style: TextStyle(
                    color:
                        _kurbanTip == 2 ? _activeFontColor : _inActiveFontColor,
                    fontSize: screenWidth / 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _getBuyukbasSubmenu(double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _kurbanSubTip = _kurbanSubTip == 1 ? 0 : 1;
              });
            },
            child: SizedBox(
              width: screenWidth / 5,
              height: 35,
              child: Container(
                alignment: Alignment.center,
                color: _kurbanSubTip == 1 ? _activeColor : _inActiveColor,
                child: Text(
                  "Ayaktan(Kilo)",
                  style: TextStyle(
                      color: _kurbanSubTip == 1
                          ? _activeFontColor
                          : _inActiveFontColor,
                      fontSize: screenWidth / 33,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _kurbanSubTip = _kurbanSubTip == 2 ? 0 : 2;
              });
            },
            child: SizedBox(
              width: screenWidth / 5,
              height: 35,
              child: Container(
                alignment: Alignment.center,
                color: _kurbanSubTip == 2 ? _activeColor : _inActiveColor,
                child: Text(
                  "Karkas",
                  style: TextStyle(
                      color: _kurbanSubTip == 2
                          ? _activeFontColor
                          : _inActiveFontColor,
                      fontSize: screenWidth / 27,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _kurbanSubTip = _kurbanSubTip == 3 ? 0 : 3;
              });
            },
            child: SizedBox(
              width: screenWidth / 5,
              height: 35,
              child: Container(
                alignment: Alignment.center,
                color: _kurbanSubTip == 3 ? _activeColor : _inActiveColor,
                child: Text(
                  "Ayaktan",
                  style: TextStyle(
                      color: _kurbanSubTip == 3
                          ? _activeFontColor
                          : _inActiveFontColor,
                      fontSize: screenWidth / 27,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _kurbanSubTip = _kurbanSubTip == 4 ? 0 : 4;
              });
            },
            child: SizedBox(
              width: screenWidth / 5,
              height: 35,
              child: Container(
                alignment: Alignment.center,
                color: _kurbanSubTip == 4 ? _activeColor : _inActiveColor,
                child: Text(
                  "Hisse",
                  style: TextStyle(
                      color: _kurbanSubTip == 4
                          ? _activeFontColor
                          : _inActiveFontColor,
                      fontSize: screenWidth / 27,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getKucukbasSubmenu(double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _kurbanSubTip = _kurbanSubTip == 5 ? 0 : 5;
              });
            },
            child: SizedBox(
              width: screenWidth / 4,
              height: 35,
              child: Container(
                alignment: Alignment.center,
                color: _kurbanSubTip == 5 ? _activeColor : _inActiveColor,
                child: Text(
                  "Ayaktan(Kilo)",
                  style: TextStyle(
                      color: _kurbanSubTip == 5
                          ? _activeFontColor
                          : _inActiveFontColor,
                      fontSize: screenWidth / 33,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _kurbanSubTip = _kurbanSubTip == 6 ? 0 : 6;
              });
            },
            child: SizedBox(
              width: screenWidth / 4,
              height: 35,
              child: Container(
                alignment: Alignment.center,
                color: _kurbanSubTip == 6 ? _activeColor : _inActiveColor,
                child: Text(
                  "Ayaktan",
                  style: TextStyle(
                      color: _kurbanSubTip == 6
                          ? _activeFontColor
                          : _inActiveFontColor,
                      fontSize: screenWidth / 27,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getNum(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: _saleNoController,
        decoration: InputDecoration(
            hintText: _kurbanSubTip != 6
                ? 'Kurban No'
                : 'Kurban Numaraları (virgul ile ayırabilirsiniz)'),
      ),
    );
  }

  Widget _getKg(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: _kgController,
        decoration: InputDecoration(hintText: 'KG'),
      ),
    );
  }

  Widget _getKgAmount(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: _kgAmountController,
        decoration: InputDecoration(hintText: 'KG Birim Biyatı'),
      ),
    );
  }

  Widget _getKaparo(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: _kaparoController,
        decoration: InputDecoration(hintText: 'Alınan Kaparo'),
      ),
    );
  }

  Widget _getKalanTutar(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: _kalanTutarController,
        decoration: InputDecoration(hintText: 'Kalan Tutar'),
      ),
    );
  }

  Widget _getHisse(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: _hisseCountController,
        decoration: InputDecoration(hintText: 'Hisse Sayısı'),
      ),
    );
  }

  Widget _getHisseType(double screenWidth, double screenHeight) {
    return SizedBox(
      width: screenWidth,
      height: 100,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _repositoryInstance.getAllItems(CollectionKeys.hisse),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Text("Loading.....");
            else {
              List<DropdownMenuItem<HisseModel>> hisseItems = [];
              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                DocumentSnapshot snap = snapshot.data!.docs[i];
                var hisse = HisseModel.fromJson(snapshot.data!.docs[i].data());
                hisseItems.add(
                  DropdownMenuItem(
                    child: Text(
                      hisse.amount.toString(),
                      style: TextStyle(color: Colors.grey),
                    ),
                    value: hisse,
                  ),
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DropdownButton<HisseModel>(
                    items: hisseItems,
                    onChanged: (currencyValue) {
                      print(currencyValue!.amount.toString());
                    },
                    // value: selectedCurrency,
                    isExpanded: false,
                    hint: new Text(
                      "Hisse Tipini Seçiniz",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
