import 'package:flutter/material.dart';
import 'package:gazi_app/common/custom_animation.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/common/helper.dart';
import 'package:gazi_app/model/hisse_kurban.dart';

class AddKurban extends StatefulWidget {
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
  bool _isVekalet = false;
  @override
  Widget build(BuildContext context) {
    var screenInfo = MediaQuery.of(context);
    final screenWidth = screenInfo.size.width;
    final screenHeight = screenInfo.size.height;
    return StatefulBuilder(builder: (context, setState) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Yeni Kurban Ekle"),
        ),
        body: Container(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                            onPressed: addKurban, child: Text("Ekle"))),
                  ],
                ),
              ),
            )),
      );
    });
  }

  Future<void> addKurban() async {
    if (_formKey.currentState!.validate()) {
      CustomLoader.show();

      var result = await DataRepository.instance
          .isSaleNumAlreadyGiven(int.tryParse(_saleNoController.text)!, 1);
      if (result) {
        CustomLoader.close();
        CustomLoader.showError("Bu kurban numarası daha önce verilmiş.");
        return;
      }

      HisseKurbanModel hisseKurban = new HisseKurbanModel(
          int.parse(_saleNoController.text),
          int.parse(_kotraNoController.text),
          int.parse(_hisseNumController.text),
          int.parse(_hisseAmountController.text),
          aciklama: _aciklamaController.text,
          remainingHisse: int.parse(_hisseNumController.text),
          isVekalet: _isVekalet);

      await DataRepository.instance.addItem(hisseKurban);
      CustomLoader.close();
      Navigator.pop(context);
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
