import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/custom_animation.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/common/helper.dart';
import 'package:gazi_app/model/hisse_kurban.dart';

class AddKurban extends StatefulWidget {
  AddKurban({Key? key, this.hisseKurbanModel}) : super(key: key);
  final HisseKurbanModel? hisseKurbanModel;
  @override
  _AddKurbanState createState() => _AddKurbanState();
}

class _AddKurbanState extends State<AddKurban> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_AddKurbanFormState');
  final _saleNoController = TextEditingController();
  final _kotraNoController = TextEditingController();
  final _hisseNumController = TextEditingController();
  final _hisseAmountController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _aciklamaController = TextEditingController();
  int _buyukKurbanTip = 0;
  bool _isVekalet = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.hisseKurbanModel != null) {
      setState(() {
        _saleNoController.text = widget.hisseKurbanModel!.kurbanNo.toString();
        _kotraNoController.text = widget.hisseKurbanModel!.kotraNo.toString();
        _hisseNumController.text = widget.hisseKurbanModel!.hisseNo.toString();
        _hisseAmountController.text =
            widget.hisseKurbanModel!.hisseAmount.toString();
        _totalAmountController.text = (widget.hisseKurbanModel!.hisseAmount *
                widget.hisseKurbanModel!.hisseNo)
            .toString();
        _aciklamaController.text = widget.hisseKurbanModel!.aciklama.toString();
        _buyukKurbanTip = widget.hisseKurbanModel!.buyukKurbanTip;
        _isVekalet = widget.hisseKurbanModel!.isVekalet ?? false;
      });
    }
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
          defaultSelected: widget.hisseKurbanModel != null &&
                  widget.hisseKurbanModel!.buyukKurbanTip > 0
              ? widget.hisseKurbanModel!.buyukKurbanTip
              : null,
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

  @override
  Widget build(BuildContext context) {
    var screenInfo = MediaQuery.of(context);
    final screenWidth = screenInfo.size.width;
    final screenHeight = screenInfo.size.height;
    return StatefulBuilder(builder: (context, setState) {
      return Scaffold(
        appBar: AppBar(
            title: Text(widget.hisseKurbanModel == null
                ? "Yeni Hisse Ekle"
                : widget.hisseKurbanModel!.kurbanNo.toString() +
                    " Numaralı Hisse"),
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new),
                onPressed: () async {
                  var success = await askPrompt(context,
                      message:
                          "Geri giderseniz girdiğiniz bilgiler kaybolacaktır.\nÇıkmak istediğinizden emin misiniz?",
                      title: "Çıkış");
                  if (success) {
                    Navigator.pop(context, widget.hisseKurbanModel);
                  }
                })),
        body: Container(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _getBuyukbasTypeMenu(screenWidth),
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                      child: TextFormField(
                          validator: requiredValidator,
                          keyboardType: TextInputType.number,
                          controller: _saleNoController,
                          decoration: InputDecoration(labelText: 'Kurban No')),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _kotraNoController,
                          decoration: InputDecoration(labelText: 'Kotra No')),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                      child: TextFormField(
                          validator: requiredValidator,
                          keyboardType: TextInputType.number,
                          controller: _hisseNumController,
                          onChanged: calculateTotal,
                          decoration:
                              InputDecoration(labelText: 'Hisse Sayısı')),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                      child: TextFormField(
                          validator: requiredValidator,
                          keyboardType: TextInputType.number,
                          controller: _hisseAmountController,
                          onChanged: calculateTotal,
                          decoration:
                              InputDecoration(labelText: 'Hisse Tutarı')),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _totalAmountController,
                          readOnly: true,
                          decoration:
                              InputDecoration(labelText: 'Toplam Tutar')),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller: _aciklamaController,
                        maxLines: null,
                        minLines: 3,
                        decoration: InputDecoration(
                            labelText: 'Açıklama (İsteğe bağlı)'),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Vekaletli Hisse",
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center),
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
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                        child: ElevatedButton(
                            onPressed: addKurban,
                            child: Text(widget.hisseKurbanModel == null
                                ? "Ekle"
                                : "Güncelle"))),
                  ],
                ),
              ),
            )),
      );
    });
  }

  Future<void> addKurban() async {
    if (_buyukKurbanTip == 0) {
      CustomLoader.showError("Lütfen Kurban Cinsini Seçiniz");
      return;
    }
    if (_formKey.currentState!.validate()) {
      CustomLoader.show();
      if (widget.hisseKurbanModel == null ||
          widget.hisseKurbanModel!.kurbanNo.toString() !=
              _saleNoController.text) {
        var result = await DataRepository.instance
            .isSaleNumAlreadyGiven(int.tryParse(_saleNoController.text)!, 1);
        if (result) {
          CustomLoader.close();
          CustomLoader.showError("Bu kurban numarası daha önce verilmiş.");
          return;
        }
      }

      if (widget.hisseKurbanModel == null) {
        HisseKurbanModel hisseKurban = new HisseKurbanModel(
            int.parse(_saleNoController.text),
            int.parse(_kotraNoController.text),
            int.parse(_hisseNumController.text),
            int.parse(_hisseAmountController.text),
            buyukKurbanTip: _buyukKurbanTip,
            aciklama: _aciklamaController.text,
            remainingHisse: int.parse(_hisseNumController.text),
            isVekalet: _isVekalet);

        await DataRepository.instance.addItem(hisseKurban);
        CustomLoader.close();
        Navigator.pop(context, widget.hisseKurbanModel);
      } else {
        CustomLoader.show();
        widget.hisseKurbanModel!.aciklama = _aciklamaController.text;
        widget.hisseKurbanModel!.buyukKurbanTip = _buyukKurbanTip;
        widget.hisseKurbanModel!.hisseAmount =
            int.parse(_hisseAmountController.text);
        widget.hisseKurbanModel!.hisseNo = int.parse(_hisseNumController.text);
        widget.hisseKurbanModel!.isVekalet = _isVekalet;
        widget.hisseKurbanModel!.kotraNo = int.parse(_kotraNoController.text);
        widget.hisseKurbanModel!.kurbanNo = int.parse(_saleNoController.text);
        await DataRepository.instance.updateItem(widget.hisseKurbanModel!);
        Navigator.pop(context, widget.hisseKurbanModel!);
        CustomLoader.close();
      }
    }
  }

  void calculateTotal(val) {
    if (_hisseNumController.text.isNotEmpty &&
        _hisseAmountController.text.isNotEmpty) {
      setState(() {
        _totalAmountController.text = (int.parse(_hisseNumController.text) *
                int.parse(_hisseAmountController.text))
            .toString();
      });
    } else {
      _totalAmountController.text = "";
    }
  }
}
