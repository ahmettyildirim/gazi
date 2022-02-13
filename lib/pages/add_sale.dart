import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/customer.dart';
import 'package:gazi_app/model/hisse_kurban.dart';
import 'package:gazi_app/model/payment.dart';
import 'package:gazi_app/model/sale.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'hisse_select.dart';

class AddSale extends StatefulWidget {  
  @override
  _AddSaleState createState() => _AddSaleState();
}

var _repositoryInstance = DataRepository.instance;

class _AddSaleState extends State<AddSale> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_AddHisseFormState');
  final _saleNoController = TextEditingController();
  final _kgController = TextEditingController();
  final _adetController = TextEditingController();
  final _kgAmountController = TextEditingController();
  final _amountController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _kaparoController = TextEditingController();
  final _kalanTutarController = TextEditingController();
  final _hisseCountController = TextEditingController();
  final _aciklamaController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '(###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});
  int _kurbanTip = 0;
  int _buyukKurbanTip = 0;
  int _kurbanSubTip = 0;
  Color _inActiveColor = Colors.blue.shade100;
  Color _activeColor = Colors.blue.shade700;
  Color _inActiveFontColor = Colors.grey.shade700;
  Color _activeFontColor = Colors.grey.shade50;
  CustomerModel? selectedCustomer;
  HisseKurbanModel? _selectedHisse;
  String _remainingHisseLabelText = 'Hisse Sayısı';
  void _selectKurban(HisseKurbanModel kurban) {
    setState(() {
      _saleNoController.text = kurban.kurbanNo.toString();
      _remainingHisseLabelText =
          "Hisse Sayısı (Kalan Hisse ${kurban.remainingHisse.toString()})";
      _selectedHisse = kurban;
      _amountController.text = kurban.hisseAmount.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenInfo = MediaQuery.of(context);
    final screenWidth = screenInfo.size.width;
    final screenHeight = screenInfo.size.height;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Yeni Satış"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _getTypeMenu(screenWidth),
                SizedBox(height: 10),
                Divider(height: 3),
                SizedBox(height: 10),
                _kurbanTip == 1
                    ? _getBuyukbasTypeMenu(screenWidth)
                    : _kurbanTip == 2
                        ? _getKucukbasSubmenu(screenWidth)
                        : Center(),
                _kurbanTip == 1
                    ? _buyukKurbanTip != 0
                        ? _getBuyukbasSubmenu(screenWidth)
                        : Center()
                    : Center(),
                _kurbanSubTip != 0
                    ? _getPhone(screenWidth, screenHeight)
                    : Center(),
                _kurbanSubTip != 0
                    ? _getName(screenWidth, screenHeight)
                    : Center(),
                [0, 4].contains(_kurbanSubTip)
                    ? Center()
                    : _getNum(screenWidth, screenHeight),
                ![6].contains(_kurbanSubTip)
                    ? Center()
                    : _getAdet(screenWidth, screenHeight),
                ![4].contains(_kurbanSubTip)
                    ? Center()
                    : _getNumForHisse(screenWidth, screenHeight),
                ![4].contains(_kurbanSubTip)
                    ? Center()
                    : _getHisse(screenWidth, screenHeight),
                [0, 2, 3, 4, 6].contains(_kurbanSubTip)
                    ? Center()
                    : _getKg(screenWidth, screenHeight),
                [0, 3, 4, 6].contains(_kurbanSubTip)
                    ? Center()
                    : _getKgAmount(screenWidth, screenHeight),
                ![3, 4, 6].contains(_kurbanSubTip)
                    ? Center()
                    : _getAmount(screenWidth, screenHeight),
                [0, 2, 3].contains(_kurbanSubTip)
                    ? Center()
                    : _getTotal(screenWidth, screenHeight),
                [0].contains(_kurbanSubTip)
                    ? Center()
                    : _getKaparo(screenWidth, screenHeight),
                [0, 2].contains(_kurbanSubTip)
                    ? Center()
                    : _getKalanTutar(screenWidth, screenHeight),
                _kurbanSubTip != 0
                    ? _getAciklama(screenWidth, screenHeight)
                    : Center(),
                _kurbanSubTip != 0
                    ? Padding(
                        padding: EdgeInsets.all(screenHeight / 30),
                        child: ElevatedButton(
                            onPressed: addSale, child: Text("Ekle")))
                    : Center()
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _getTypeMenu(double screenWidth) {
    return CustomRadioButton(
      enableButtonWrap: true,
      shapeRadius: 14.0,
      radius: 14.0,
      enableShape: false,
      unSelectedColor: Theme.of(context).canvasColor,
      buttonLables: [
        "Büyükbaş",
        "Küçükbaş",
      ],
      buttonValues: [
        1,
        2,
      ],
      radioButtonValue: (value) => {
        setState(() {
          _kurbanTip = int.parse(value.toString());
          _kurbanSubTip = 0;
          _buyukKurbanTip = 0;
        })
      },
      selectedColor: Theme.of(context).colorScheme.secondary,
    );
  }

  Widget _getBuyukbasTypeMenu(double screenWidth) {
    return Column(
      children: [
        CustomRadioButton(
          enableButtonWrap: true,
          shapeRadius: 14.0,
          radius: 14.0,
          enableShape: false,
          unSelectedColor: Theme.of(context).canvasColor,
          buttonLables: [
            "Dana",
            "Düve",
          ],
          buttonValues: [
            1,
            2,
          ],
          radioButtonValue: (value) => {
            setState(() {
              _buyukKurbanTip = int.parse(value.toString());
            })
          },
          selectedColor: Theme.of(context).colorScheme.secondary,
        ),
        SizedBox(height: 10),
        Divider(height: 3),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _getBuyukbasSubmenu(double screenWidth) {
    return Column(
      children: [
        CustomRadioButton(
          enableButtonWrap: true,
          shapeRadius: 14.0,
          radius: 14.0,
          enableShape: false,
          unSelectedColor: Theme.of(context).canvasColor,
          buttonLables: ["Ayaktan(Kilo)", "Karkas", "Ayaktan", "Hisse"],
          buttonValues: [1, 2, 3, 4],
          buttonTextStyle:
              ButtonTextStyle(textStyle: TextStyle(fontSize: 10.0)),
          width: screenWidth / 3,
          radioButtonValue: (value) => {
            setState(() {
              _kurbanSubTip = int.parse(value.toString());
              refreshFields();
            })
          },
          selectedColor: Theme.of(context).colorScheme.secondary,
        ),
        SizedBox(height: 10),
        Divider(height: 3),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _getKucukbasSubmenu(double screenWidth) {
    return Column(
      children: [
        CustomRadioButton(
          enableButtonWrap: true,
          shapeRadius: 14.0,
          radius: 14.0,
          enableShape: false,
          unSelectedColor: Theme.of(context).canvasColor,
          buttonLables: ["Ayaktan(Kilo)", "Ayaktan"],
          buttonValues: [5, 6],
          buttonTextStyle:
              ButtonTextStyle(textStyle: TextStyle(fontSize: 10.0)),
          width: screenWidth / 3,
          radioButtonValue: (value) => {
            setState(() {
              _kurbanSubTip = int.parse(value.toString());
              refreshFields();
            })
          },
          selectedColor: Theme.of(context).colorScheme.secondary,
        ),
        SizedBox(height: 10),
        Divider(height: 3),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _getNum(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 5),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: _saleNoController,
        decoration: InputDecoration(labelText: 'Kurban No'),
      ),
    );
  }

  Widget _getNumForHisse(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _saleNoController,
              decoration: InputDecoration(labelText: "Kurban No"),
              onChanged: searchForHisse,
              enabled: false,
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HisseKurbanSelect(
                              onHisseSelected: _selectKurban,
                            )));
              },
              child: Text("Listeden Seç "))
        ],
      ),
    );
  }

  Widget _getPhone(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 5),
      child: TextFormField(
          keyboardType: TextInputType.phone,
          controller: _phoneController,
          inputFormatters: [maskFormatter],
          decoration: InputDecoration(labelText: 'Cep Telefonu'),
          onChanged: getCustomerByPhone),
    );
  }

  Future<void> getCustomerByPhone(phone) async {
    print("başladı");
    print(phone.length);
    if (phone.length != 15) {
      setState(() {
        _nameController.text = "";
        selectedCustomer = null;
      });
      return;
    }
    var value = await _repositoryInstance.getAllItemsByFilter(
        CollectionKeys.customers,
        filterName: FieldKeys.customerPhone,
        filterValue: _phoneController.text);
    // if(phone!=_phoneController.text){
    //   getCustomerByPhone(_phoneController.text);
    // }
    if (value.docs.isNotEmpty) {
      print('girdi');
      var customer = CustomerModel.fromJson(value.docs.first.data(),
          id: value.docs.first.id);
      setState(() {
        selectedCustomer = customer;
        _nameController.text = customer.name;
      });
    } else {
      print('girmedi');
      setState(() {
        _nameController.text = "";
        selectedCustomer = null;
      });
    }
  }

  Widget _getName(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 5),
      child: TextFormField(
        controller: _nameController,
        decoration: InputDecoration(labelText: 'Müşteri Adı Soyadı'),
      ),
    );
  }

  Widget _getKg(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 5),
      child: TextFormField(
          keyboardType: TextInputType.number,
          controller: _kgController,
          decoration: InputDecoration(labelText: 'KG'),
          onChanged: calculateTotal),
    );
  }

  Widget _getAdet(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 5),
      child: TextFormField(
          keyboardType: TextInputType.number,
          controller: _adetController,
          decoration: InputDecoration(labelText: 'Adet'),
          onChanged: calculateTotal),
    );
  }

  Widget _getKgAmount(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 5),
      child: TextFormField(
          keyboardType: TextInputType.number,
          controller: _kgAmountController,
          decoration: InputDecoration(labelText: 'KG Birim Biyatı'),
          onChanged: calculateTotal),
    );
  }

  Widget _getAmount(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 5),
      child: TextFormField(
          readOnly: _kurbanSubTip == 4,
          keyboardType: TextInputType.number,
          controller: _amountController,
          decoration: InputDecoration(labelText: 'Birim Biyatı'),
          onChanged: getRemainingAmountForNotKg),
    );
  }

  Widget _getTotal(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 5),
      child: TextFormField(
        keyboardType: TextInputType.number,
        readOnly: true,
        controller: _totalAmountController,
        decoration: InputDecoration(labelText: 'Genel Toplam'),
      ),
    );
  }

  Widget _getKaparo(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 5),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: _kaparoController,
        decoration: InputDecoration(labelText: 'Alınan Kaparo'),
        onChanged: getRemainingAmount,
      ),
    );
  }

  Widget _getKalanTutar(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 5),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: _kalanTutarController,
        readOnly: true,
        decoration: InputDecoration(labelText: 'Kalan Tutar'),
        onChanged: getRemainingAmount,
      ),
    );
  }

  Widget _getHisse(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 5),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: _hisseCountController,
        onChanged: calculateTotal,
        decoration: InputDecoration(labelText: _remainingHisseLabelText),
      ),
    );
  }

  Widget _getAciklama(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 5),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        controller: _aciklamaController,
        maxLines: null,
        minLines: 2,
        decoration: InputDecoration(labelText: 'Açıklama (İsteğe bağlı)'),
      ),
    );
  }

  void getRemainingAmount(val) {
    if (_kurbanSubTip == 2) {
      return;
    }
    if (_kurbanSubTip == 3) {
      getRemainingAmountForNotKg(val);
      return;
    }
    if (_totalAmountController.text.isNotEmpty) {
      int kaparo = _kaparoController.text.isEmpty
          ? 0
          : int.parse(_kaparoController.text);
      setState(() {
        _kalanTutarController.text =
            (int.parse(_totalAmountController.text) - kaparo).toString();
      });
    }
  }

  void getRemainingAmountForNotKg(val) {
    if (_kurbanSubTip == 6) {
      calculateTotal(val);
      return;
    }
    if (_amountController.text.isNotEmpty) {
      int kaparo = _kaparoController.text.isEmpty
          ? 0
          : int.parse(_kaparoController.text);
      setState(() {
        _kalanTutarController.text =
            (int.parse(_amountController.text) - kaparo).toString();
      });
    }
  }

  void calculateTotal(val) {
    if (_kurbanSubTip == 4) {
      if (_hisseCountController.text.isNotEmpty &&
          _amountController.text.isNotEmpty) {
        setState(() {
          _totalAmountController.text = (int.parse(_hisseCountController.text) *
                  int.parse(_amountController.text))
              .toString();
        });
        getRemainingAmount(val);
      } else {
        _totalAmountController.text = "";
      }
    } else if (_kurbanSubTip == 6) {
      if (_adetController.text.isNotEmpty &&
          _amountController.text.isNotEmpty) {
        setState(() {
          _totalAmountController.text = (int.parse(_adetController.text) *
                  int.parse(_amountController.text))
              .toString();
        });
        getRemainingAmount(val);
      } else {
        _totalAmountController.text = "";
      }
    } else {
      if (_kgController.text.isNotEmpty &&
          _kgAmountController.text.isNotEmpty) {
        setState(() {
          _totalAmountController.text = (int.parse(_kgController.text) *
                  int.parse(_kgAmountController.text))
              .toString();
        });
        getRemainingAmount(val);
      } else {
        _totalAmountController.text = "";
      }
    }
  }

  void refreshFields() {
    _kgController.text = "";
    _kalanTutarController.text = "";
    _amountController.text = "";
    _saleNoController.text = "";
    _hisseCountController.text = "";
    _kaparoController.text = "";
    _kgAmountController.text = "";
    _totalAmountController.text = "";
    _adetController.text = "";
    _aciklamaController.text = "";
    _remainingHisseLabelText = "Hisse Sayısı";
  }

  Future<void> addSale() async {
    if (selectedCustomer == null) {
      CustomerModel customer =
          new CustomerModel(_nameController.text, _phoneController.text);
      var customerref = await DataRepository.instance.addNewItem(customer);
      // await getCustomerByPhone(_phoneController.text);
      var value = await _repositoryInstance.getAllItemsByFilter(
          CollectionKeys.customers,
          filterName: FieldKeys.customerPhone,
          filterValue: _phoneController.text);
      if (value.docs.isNotEmpty) {
        var customer = CustomerModel.fromJson(value.docs.first.data(),
            id: value.docs.first.id);
        setState(() {
          selectedCustomer = customer;
          _nameController.text = customer.name;
        });
      }
    }
    if (selectedCustomer!.name != _nameController.text) {
      selectedCustomer!.name = _nameController.text;
      await _repositoryInstance.updateItem(selectedCustomer!);
    }
    SaleModel sale = new SaleModel(
        customer: selectedCustomer!,
        customerRef: selectedCustomer!.id,
        kurbanTip: _kurbanTip,
        buyukKurbanTip: _buyukKurbanTip,
        kurbanSubTip: _kurbanSubTip,
        kurbanNo: _saleNoController.text.isEmpty
            ? 0
            : int.parse(_saleNoController.text),
        kg: _kgController.text.isEmpty ? 0 : int.parse(_kgController.text),
        kgAmount: _kgAmountController.text.isEmpty
            ? 0
            : int.parse(_kgAmountController.text),
        amount: _amountController.text.isEmpty
            ? 0
            : int.parse(_amountController.text),
        generalAmount: _totalAmountController.text.isEmpty
            ? 0
            : int.parse(_totalAmountController.text),
        kaparo: 0,
        remainingAmount: _kalanTutarController.text.isEmpty
            ? 0
            : int.parse(_kalanTutarController.text),
        hisseNum: _hisseCountController.text.isEmpty
            ? 0
            : int.parse(_hisseCountController.text),
        hisseRef: _selectedHisse == null ? "" : _selectedHisse!.id,
        adet:
            _adetController.text.isEmpty ? 0 : int.parse(_adetController.text),
        aciklama:
            _aciklamaController.text.isEmpty ? "" : _aciklamaController.text);
    var addedItem = await DataRepository.instance.addNewItem(sale);
    if (_kaparoController.text.isNotEmpty) {
      PaymentModel payment = new PaymentModel(
          amount: int.parse(_kaparoController.text),
          paymentType: "Nakit",
          aciklama: "İlk ödeme");
      var result =
          await DataRepository.instance.addNewPayment(addedItem, payment);
    }
    if (_kurbanSubTip == 4) {
      _selectedHisse!.remainingHisse = _selectedHisse!.remainingHisse -
          int.parse(_hisseCountController.text);
      await _repositoryInstance.updateItem(_selectedHisse!);
    }
    await _showMyDialog();
    Navigator.pop(context);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Satış Tamamlandı'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Satış İşlemi Tamamlandı..'),
                Text('Müşteriye whatsapp mesajı göndermek ister misiniz?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Evet'),
              onPressed: () {
                print('Confirmed');
                var phone = selectedCustomer!.phone;
                phone = phone.replaceAll(' ', '');
                phone = phone.replaceAll('(', '');
                phone = phone.replaceAll(')', '');
                phone = phone.replaceAll('-', '');
                phone = "90" + phone;

                wasup(phone);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Hayır'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> searchForHisse(val) async {
    int? kurbanId = int.tryParse(val);
    if (kurbanId == null) {
      setState(() {
        _remainingHisseLabelText = "Hisse Sayısı";
        _selectedHisse = null;
        _amountController.text = "";
      });
      return;
    }
    var value = await _repositoryInstance.getAllItemsByFilter(
        CollectionKeys.hisseKurban,
        filterName: FieldKeys.hisseKurbanKurbanNo,
        filterValue: kurbanId);
    if (value.docs.isNotEmpty) {
      var kurban = HisseKurbanModel.fromJson(value.docs.first.data(),
          id: value.docs.first.id);
      setState(() {
        _remainingHisseLabelText =
            "Hisse Sayısı (Kalan Hisse ${kurban.remainingHisse.toString()})";
        _selectedHisse = kurban;
        _amountController.text = kurban.hisseAmount.toString();
      });
    } else {
      setState(() {
        _remainingHisseLabelText = "Hisse Sayısı";
        _selectedHisse = null;
        _amountController.text = "";
      });
    }
  }

  Future<void> wasup(String num) async {
    var whatsapp = "905309383594";
    // FirebaseAuth.instance.signOut();
    var whatsappURl_android = "whatsapp://send?phone=" + num + "&text=hello";
    var whatappURL_ios =
        "https://wa.me/$num?text=${Uri.parse("Kurban satış işlemi gerçekleşti")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
        whatappURL_ios =
            "https://wa.me/$num?text=${Uri.parse("Kurban satış işlemi gerçekleşti")}";
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }
}
