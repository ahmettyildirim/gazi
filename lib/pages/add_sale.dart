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
  AddSale({Key? key, this.sale}) : super(key: key);
  final SaleModel? sale;
  @override
  _AddSaleState createState() => _AddSaleState();
}

var _repositoryInstance = DataRepository.instance;

class _AddSaleState extends State<AddSale> {
  @override
  bool isAutoValidate = false;
  var _formKey = GlobalKey<FormState>(debugLabel: '_AddSaleFormState');
  var _saleNoController = TextEditingController();
  var _kotraNoController = TextEditingController();
  var _kgController = TextEditingController();
  var _adetController = TextEditingController();
  var _kgAmountController = TextEditingController();
  var _amountController = TextEditingController();
  var _totalAmountController = TextEditingController();
  var _kaparoController = TextEditingController();
  var _kalanTutarController = TextEditingController();
  var _hisseCountController = TextEditingController();
  var _aciklamaController = TextEditingController();
  var _phoneController = TextEditingController();
  var _nameController = TextEditingController();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '(###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});
  int _kurbanTip = 0;
  int _buyukKurbanTip = 0;
  int _kurbanSubTip = 0;
  CustomerModel? selectedCustomer;
  HisseKurbanModel? _selectedHisse;
  String _remainingHisseLabelText = 'Hisse Sayısı';

  void initState() {
    super.initState();
    if (widget.sale != null) {
      setState(() {
        _kurbanTip = widget.sale!.kurbanTip;
        _buyukKurbanTip = widget.sale!.buyukKurbanTip;
        _kurbanSubTip = widget.sale!.kurbanSubTip;
        selectedCustomer = widget.sale!.customer;
        _saleNoController.text = widget.sale!.kurbanNo.toString();
        _kotraNoController.text = widget.sale!.kotraNo.toString();
        _kgController.text = widget.sale!.kg.toString();
        _adetController.text = widget.sale!.adet.toString();
        _kgAmountController.text = widget.sale!.kgAmount.toString();
        _amountController.text = widget.sale!.amount.toString();
        _totalAmountController.text = widget.sale!.generalAmount.toString();
        _kaparoController.text = widget.sale!.kaparo.toString();
        _kalanTutarController.text = widget.sale!.remainingAmount.toString();
        _hisseCountController.text = widget.sale!.hisseNum.toString();
        _aciklamaController.text = widget.sale!.aciklama.toString();
        _phoneController.text = widget.sale!.customer.phone.toString();
        _nameController.text = widget.sale!.customer.name.toString();
      });
    }
  }

  void _selectKurban(HisseKurbanModel kurban) {
    setState(() {
      _saleNoController.text = kurban.kurbanNo.toString();
      _remainingHisseLabelText =
          "Hisse Sayısı (Kalan Hisse ${kurban.remainingHisse.toString()})";
      _selectedHisse = kurban;
      _amountController.text = kurban.hisseAmount.toString();
    });
  }

  String? _requiredValidator(String? text,
      {String information = "Bu alan boş olamaz"}) {
    if (text == null || text.isEmpty) {
      return information;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var screenInfo = MediaQuery.of(context);
    final screenWidth = screenInfo.size.width;
    final screenHeight = screenInfo.size.height;
    print("tipler");
    print(_kurbanTip);
    print(_kurbanSubTip);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sale == null
            ? "Yeni Satış"
            : widget.sale!.kurbanNo.toString() + " Numaralı Satış"),
      ),
      body: SafeArea(
        bottom: true,
        top: true,
        left: true,
        right: true,
        minimum: EdgeInsets.only(top: 30),
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
                ![4].contains(_kurbanSubTip)
                    ? Center()
                    : _getNumForHisse(screenWidth, screenHeight),
                _kurbanSubTip != 0
                    ? _getKotra(screenWidth, screenHeight)
                    : Center(),
                ![6].contains(_kurbanSubTip)
                    ? Center()
                    : _getAdet(screenWidth, screenHeight),
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
                            onPressed: addSale,
                            child: Text(
                                widget.sale == null ? "Ekle" : "Güncelle")))
                    : Center()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTypeMenu(double screenWidth) {
    if (widget.sale != null) {
      return Center();
    }
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
    if (widget.sale != null) {
      return Center();
    }
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
    if (widget.sale != null) {
      return Center();
    }
    return Column(
      children: [
        CustomRadioButton(
          enableButtonWrap: true,
          shapeRadius: 14.0,
          radius: 14.0,
          enableShape: false,
          unSelectedColor: Theme.of(context).canvasColor,
          buttonLables: ["Ayaktan", "Hisse", "Ayaktan(Kilo)", "Karkas"],
          buttonValues: [3, 4, 1, 2],
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
    if (widget.sale != null) {
      return Center();
    }
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

  Widget _getKotra(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 5),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: _kotraNoController,
        decoration: InputDecoration(labelText: 'Kotra No (İsteğe bağlı)'),
      ),
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
        validator: _requiredValidator,
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
              validator: _requiredValidator,
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
          enabled: widget.sale == null,
          validator: _requiredValidator,
          decoration: InputDecoration(labelText: 'Cep Telefonu'),
          onChanged: getCustomerByPhone),
    );
  }

  Future<void> getCustomerByPhone(phone) async {
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
    if (value.docs.isNotEmpty) {
      var customer = CustomerModel.fromJson(value.docs.first.data(),
          id: value.docs.first.id);
      setState(() {
        selectedCustomer = customer;
        _nameController.text = customer.name;
      });
    } else {
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
        enabled: widget.sale == null,
        validator: _requiredValidator,
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
          validator: _requiredValidator,
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
          validator: _requiredValidator,
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
          validator: _requiredValidator,
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
          validator: _requiredValidator,
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
        validator: _requiredValidator,
        keyboardType: TextInputType.number,
        controller: _kaparoController,
        enabled: widget.sale == null,
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
        validator: _requiredValidator,
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
    _kotraNoController.text = "";
    _hisseCountController.text = "";
    _kaparoController.text = "";
    _kgAmountController.text = "";
    _totalAmountController.text = "";
    _adetController.text = "";
    _aciklamaController.text = "";
    _remainingHisseLabelText = "Hisse Sayısı";
  }

  Future<void> addSale() async {
    if (_formKey.currentState!.validate()) {
      if (widget.sale == null) {
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
            kotraNo: _kotraNoController.text.isEmpty
                ? 0
                : int.parse(_kotraNoController.text),
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
            adet: _adetController.text.isEmpty
                ? 0
                : int.parse(_adetController.text),
            aciklama: _aciklamaController.text.isEmpty
                ? ""
                : _aciklamaController.text);
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
        await _showMyDialog(sale);
        Navigator.pop(context);
      } else {
        widget.sale!.kurbanNo = _saleNoController.text.isEmpty
            ? 0
            : int.parse(_saleNoController.text);
        widget.sale!.kotraNo = _kotraNoController.text.isEmpty
            ? 0
            : int.parse(_kotraNoController.text);
        widget.sale!.kg =
            _kgController.text.isEmpty ? 0 : int.parse(_kgController.text);
        widget.sale!.adet =
            _adetController.text.isEmpty ? 0 : int.parse(_adetController.text);
        widget.sale!.kgAmount = _kgAmountController.text.isEmpty
            ? 0
            : int.parse(_kgAmountController.text);
        widget.sale!.amount = _amountController.text.isEmpty
            ? 0
            : int.parse(_amountController.text);
        widget.sale!.generalAmount = _totalAmountController.text.isEmpty
            ? 0
            : int.parse(_totalAmountController.text);
        widget.sale!.remainingAmount = _kalanTutarController.text.isEmpty
            ? 0
            : int.parse(_kalanTutarController.text);
        widget.sale!.aciklama =
            _aciklamaController.text.isEmpty ? "" : _aciklamaController.text;
        await DataRepository.instance.updateItem(widget.sale!);
        Navigator.pop(context, widget.sale!);
      }
    }
  }

  Future<void> _showMyDialog(SaleModel saleModel) async {
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
                var phone = selectedCustomer!.phone;
                phone = phone.replaceAll(' ', '');
                phone = phone.replaceAll('(', '');
                phone = phone.replaceAll(')', '');
                phone = phone.replaceAll('-', '');
                phone = "90" + phone;

                wasup(phone, saleModel);
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

  Future<void> wasup(String num, SaleModel saleModel) async {
    String text = saleModel.kurbanNo.toString() +
        " numaralı kurban satış işleminiz gerçekleşti. " +
        saleModel.kaparo.toString() +
        " tutarında kapora alındı.";
    // FirebaseAuth.instance.signOut();
    var whatsappURlAndroid =
        "whatsapp://send?phone=" + num + "&text=${Uri.parse(text)}";
    var whatappURLIos = "https://wa.me/$num?text=${Uri.parse(text)}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURLIos)) {
        await launch(whatappURLIos, forceSafariVC: false);
        whatappURLIos = "https://wa.me/$num?text=${Uri.parse(text)}";
        await launch(whatappURLIos, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURlAndroid)) {
        await launch(whatsappURlAndroid);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }
}
