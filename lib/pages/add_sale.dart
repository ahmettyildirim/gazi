import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/custom_animation.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/common/helper.dart';
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
  var _kesimSaatiController = TextEditingController();
  bool _isVekalet = false;
  var maskFormatter = new MaskTextInputFormatter(
      mask: '(###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      initialText: "(5");
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
        _kesimSaatiController.text = widget.sale!.kesimSaati.toString();
        _isVekalet = widget.sale!.isVekalet!;
      });
    }
  }

  void _selectKurban(HisseKurbanModel kurban) {
    setState(() {
      _saleNoController.text = kurban.kurbanNo.toString();
      _kesimSaatiController.text = getKesimSaati(1, kurban.kurbanNo);
      _remainingHisseLabelText =
          "Hisse Sayısı (Kalan Hisse ${kurban.remainingHisse.toString()})";
      _selectedHisse = kurban;
      _amountController.text = kurban.hisseAmount.toString();
      _kotraNoController.text = kurban.kotraNo.toString();
    });
    calculateTotal(_amountController.text);
  }

  String? _requiredValidator(String? text,
      {String information = "Bu alan boş olamaz"}) {
    if (text == null || text.isEmpty) {
      return information;
    }
    return null;
  }

  String? _remainingHisseValidator(String? text) {
    if (text == null || text.isEmpty) {
      return "Bu alan boş olamaz";
    }
    if (_selectedHisse != null) {
      if (_selectedHisse!.remainingHisse < int.parse(text)) {
        return "Hisse sayısı kalan hisseden(${_selectedHisse!.remainingHisse}) büyük olamaz";
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var screenInfo = MediaQuery.of(context);
    final screenWidth = screenInfo.size.width;
    final screenHeight = screenInfo.size.height;
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.sale == null
              ? "Yeni Satış"
              : widget.sale!.kurbanNo.toString() + " Numaralı Satış"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new),
              onPressed: () async {
                var success = await askPrompt(context,
                    message:
                        "Geri giderseniz girdiğiniz bilgiler kaybolacaktır.\nÇıkmak istediğinizden emin misiniz?",
                    title: "Çıkış");
                if (success) {
                  Navigator.pop(context, widget.sale);
                }
              })),
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
                [0, 3, 4, 6].contains(_kurbanSubTip)
                    ? Center()
                    : _getKg(screenWidth, screenHeight),
                [0, 3, 4, 6].contains(_kurbanSubTip)
                    ? Center()
                    : _getKgAmount(screenWidth, screenHeight),
                ![3, 4].contains(_kurbanSubTip)
                    ? Center()
                    : _getAmount(screenWidth, screenHeight),
                [0, 3].contains(_kurbanSubTip)
                    ? Center()
                    : _getTotal(screenWidth, screenHeight),
                [0].contains(_kurbanSubTip)
                    ? Center()
                    : _getKaparo(screenWidth, screenHeight),
                [0].contains(_kurbanSubTip)
                    ? Center()
                    : _getKalanTutar(screenWidth, screenHeight),
                _kurbanSubTip != 0
                    ? _getKesimSaati(screenWidth, screenHeight)
                    : Center(),
                _kurbanSubTip != 0
                    ? _getIsVekalet(screenWidth, screenHeight)
                    : Center(),
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
    // if (widget.sale != null) {
    //   return Center();
    // }
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
          defaultSelected: _buyukKurbanTip > 0 ? _buyukKurbanTip : null,
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
        enabled: _kurbanSubTip != 4,
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
        onChanged: _fillKesimSaati,
        decoration: InputDecoration(labelText: 'Kurban No'),
        validator: _requiredValidator,
      ),
    );
  }

  void _fillKesimSaati(String val) {
    if (val.isNotEmpty) {
      _kesimSaatiController.text = getKesimSaati(_kurbanTip, int.parse(val));
    }
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
          validator: _requiredValidator,
          decoration: InputDecoration(labelText: 'Cep Telefonu'),
          onChanged: getCustomerByPhone),
    );
  }

  Future<void> getCustomerByPhone(phone) async {
    if (_phoneController.text.length == 2 && _phoneController.text != "(5") {
      _phoneController.text = "";
      return;
    }
    if (phone.length != 15) {
      setState(() {
        _nameController.text = "";
        selectedCustomer = null;
      });
      return;
    }
    var value = await _repositoryInstance.getAllItemsByFilterNoDate(
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
        validator: _requiredValidator,
        controller: _nameController,
        decoration: InputDecoration(labelText: 'Müşteri Adı Soyadı'),
      ),
    );
  }

  Widget _getKg(double screenWidth, double screenHeight) {
    if (_kurbanSubTip == 2) {
      if (widget.sale == null) {
        return Center();
      }
    }
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
        validator: _requiredValidator,
        keyboardType: TextInputType.number,
        controller: _adetController,
        decoration: InputDecoration(labelText: 'Adet'),
      ),
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
          decoration: InputDecoration(labelText: 'KG Birim Fiyatı'),
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
          decoration: InputDecoration(labelText: 'Birim Fiyatı'),
          onChanged: getRemainingAmountForNotKg),
    );
  }

  Widget _getTotal(double screenWidth, double screenHeight) {
    if (_kurbanSubTip == 2) {
      if (widget.sale == null) {
        return Center();
      }
    }
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 5),
      child: TextFormField(
        keyboardType: TextInputType.number,
        readOnly: _kurbanSubTip != 6,
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
    if (_kurbanSubTip == 2) {
      if (widget.sale == null) {
        return Center();
      }
    }
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
        validator: _remainingHisseValidator,
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

  Widget _getKesimSaati(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenHeight / 30, right: screenHeight / 30, top: 5),
      child: TextFormField(
        keyboardType: TextInputType.datetime,
        controller: _kesimSaatiController,
        readOnly: true,
        decoration: InputDecoration(labelText: 'Tahmini Kesim Saati'),
      ),
    );
  }

  Widget _getIsVekalet(double screenWidth, double screenHeight) {
    return Padding(
        padding: EdgeInsets.only(
            left: screenHeight / 30, right: screenHeight / 30, top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Vekaletli Satış",
                style: TextStyle(fontSize: 15), textAlign: TextAlign.center),
            Switch(
              value: _isVekalet,
              onChanged: (value) {
                setState(() {
                  _isVekalet = value;
                });
              },
              activeTrackColor: Colors.lightBlueAccent,
              activeColor: Colors.blueAccent,
            ),
          ],
        ));
  }

  void getRemainingAmount(val) {
    if (_kurbanSubTip == 2 && widget.sale == null) {
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
    int kg = _kgController.text.isEmpty ? 0 : int.parse(_kgController.text);
    int kgAmount = _kgAmountController.text.isEmpty
        ? 0
        : int.parse(_kgAmountController.text);
    int hisseCount = _hisseCountController.text.isEmpty
        ? 0
        : int.parse(_hisseCountController.text);
    int adet =
        _adetController.text.isEmpty ? 0 : int.parse(_adetController.text);

    int amount =
        _amountController.text.isEmpty ? 0 : int.parse(_amountController.text);

    if (_kurbanSubTip == 4) {
      setState(() {
        _totalAmountController.text = (hisseCount * amount).toString();
      });
      getRemainingAmount(val);
    } else if (_kurbanSubTip == 6) {
      setState(() {
        _totalAmountController.text = (adet * amount).toString();
      });
      getRemainingAmount(val);
    } else {
      setState(() {
        _totalAmountController.text = (kg * kgAmount).toString();
      });
      getRemainingAmount(val);
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
      if (selectedCustomer == null) {
        CustomLoader.show();
        CustomerModel customer =
            new CustomerModel(_nameController.text, _phoneController.text);
        var customerref = await DataRepository.instance.addNewItem(customer);
        // await getCustomerByPhone(_phoneController.text);
        var value = await _repositoryInstance.getAllItemsByFilterNoDate(
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
      if (_kurbanSubTip != 4) {
        //hisseli satış dışında aynı kurban nosunu başkasına satılmamasıç
        if (widget.sale == null ||
            widget.sale!.kurbanNo.toString() != _saleNoController.text) {
          var result = await _repositoryInstance.isSaleNumAlreadyGiven(
              int.tryParse(_saleNoController.text)!, _kurbanTip);
          if (result) {
            CustomLoader.close();
            CustomLoader.showError("Bu kurban numarası daha önce verilmiş.");
            return;
          }
        }
      }
      if (selectedCustomer!.name != _nameController.text) {
        selectedCustomer!.name = _nameController.text;
        await _repositoryInstance.updateItem(selectedCustomer!);
      }
      if (widget.sale == null) {
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
            kesimSaati: _kesimSaatiController.text,
            isVekalet: _isVekalet,
            aciklama: _aciklamaController.text.isEmpty
                ? ""
                : _aciklamaController.text);

        var addedItem = await DataRepository.instance.addNewItem(sale);
        if (_kaparoController.text.isNotEmpty &&
            int.tryParse(_kaparoController.text) != 0) {
          PaymentModel payment = new PaymentModel(
              amount: int.parse(_kaparoController.text),
              paymentType: "Nakit",
              aciklama: "Kaparo");
          await DataRepository.instance.addNewPayment(addedItem, payment);
        }
        if (_kurbanSubTip == 4) {
          _selectedHisse!.remainingHisse = _selectedHisse!.remainingHisse -
              int.parse(_hisseCountController.text);
          await _repositoryInstance.updateItem(_selectedHisse!);
        }
        CustomLoader.close();
        var phone = selectedCustomer!.phone;
        wasup(phone, sale);
        Navigator.of(context).pop();
      } else {
        CustomLoader.show();
        widget.sale!.customer = selectedCustomer!;
        widget.sale!.customerRef = selectedCustomer!.id;
        widget.sale!.kurbanNo = _saleNoController.text.isEmpty
            ? 0
            : int.parse(_saleNoController.text);
        widget.sale!.buyukKurbanTip = _buyukKurbanTip;
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
        widget.sale!.kesimSaati = _kesimSaatiController.text;
        widget.sale!.isVekalet = _isVekalet;
        widget.sale!.aciklama =
            _aciklamaController.text.isEmpty ? "" : _aciklamaController.text;
        await DataRepository.instance.updateItem(widget.sale!);
        Navigator.pop(context, widget.sale!);
        CustomLoader.close();
      }
    }
  }

  Future<void> searchForHisse(val) async {
    int? kurbanId = int.tryParse(val);
    if (kurbanId == null) {
      setState(() {
        _remainingHisseLabelText = "Hisse Sayısı";
        _selectedHisse = null;
        _amountController.text = "";
      });
      calculateTotal(val);
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
        _kotraNoController.text = kurban.kotraNo.toString();
      });
    } else {
      setState(() {
        _remainingHisseLabelText = "Hisse Sayısı";
        _selectedHisse = null;
        _amountController.text = "";
      });
    }
  }

  String getKaparo() {
    if (_kaparoController.text.isNotEmpty && _kaparoController.text != "0") {
      int kaparo = int.parse(_kaparoController.text);
      return "Ödenen Kaparo - ${getMoneyString(kaparo)}\n";
    }
    return "";
  }

  Future<void> wasup(String num, SaleModel saleModel) async {
    String text = "**GAZİ ET MANGAL ÇİFTLİĞİ**\n"
        "Kurban satış işleminiz gerçekleşmiştir. Allah Kabul etsin. Bayram sabahı görüşmek dileğiyle... \nKurban No - ${saleModel.kurbanNo}\n";
    switch (saleModel.kurbanSubTip) {
      case 1:
      case 2:
      case 5:
        text += saleModel.kg != 0 ? "KG - ${saleModel.kg}\n" : "";
        text += "KG Birim Fiyatı - ${getMoneyString(saleModel.kgAmount)}\n";
        text += saleModel.generalAmount != 0
            ? "Toplam Fiyat - ${getMoneyString(saleModel.generalAmount)}\n"
            : "";
        text += getKaparo();
        text +=
            "Tahmini Kesim Saati - ${saleModel.kesimSaati!.replaceAll(":", "-")}\n(Bu saatten yarım saat kadar önce kesim yerinde olmanız önemle rica olunur.)";
        break;
      case 3:
        text += "Kurban Fiyatı - ${getMoneyString(saleModel.amount)}\n";
        text += getKaparo();
        text +=
            "Tahmini Kesim Saati - ${saleModel.kesimSaati!.replaceAll(":", "-")}\n(Bu saatten yarım saat kadar önce kesim yerinde olmanız önemle rica olunur.)";
        break;
      case 4:
        text += "Hisse Sayısı - ${saleModel.hisseNum}\n";
        text += "Hisse Fiyatı - ${getMoneyString(saleModel.amount)}\n";
        text += "Toplam Fiyat - ${getMoneyString(saleModel.generalAmount)}\n";
        text += getKaparo();
        text +=
            "Tahmini Kesim Saati - ${saleModel.kesimSaati!.replaceAll(":", "-")}\n(Bu saatten yarım saat kadar önce kesim yerinde olmanız önemle rica olunur.)";
        var value = await _repositoryInstance.getAllItemsByFilter(
            CollectionKeys.sales,
            filterName: FieldKeys.saleHisseRef,
            filterValue: _selectedHisse!.id);
        if (value.docs.isNotEmpty) {
          text += "Diğer Hisse Sahipleri - \n";
          for (int i = 0; i < value.docs.length; i++) {
            var sale = SaleModel.fromJson(value.docs[i].data());
            text += sale.customer.name +
                " - 0" +
                sale.customer.phone +
                "(" +
                sale.hisseNum.toString() +
                " Adet)\n";
          }
        }
        break;
      case 6:
        text += "Adet - ${saleModel.adet}\n";
        text += "Toplam Fiyat - ${getMoneyString(saleModel.generalAmount)}\n";
        text += getKaparo();
        text +=
            "Tahmini Kesim Saati - ${saleModel.kesimSaati!.replaceAll(":", "-")}\n(Bu saatten yarım saat kadar önce kesim yerinde olmanız önemle rica olunur.)";
        break;
      default:
    }
    text += "\n\n02242621313\n05161691313 ";
    await launchWhatsApp(num: num, text: text);
  }
}
