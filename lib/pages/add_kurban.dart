import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';
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
  @override
  Widget build(BuildContext context) {
    var screenInfo = MediaQuery.of(context);
    final screenWidth = screenInfo.size.width;
    final screenHeight = screenInfo.size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni Kurban Ekle"),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _saleNoController,
                    decoration: InputDecoration(labelText: 'Kurbann No')),
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
                    keyboardType: TextInputType.number,
                    controller: _hisseNumController,
                    onChanged: calculateTotal,
                    decoration: InputDecoration(labelText: 'Hisse Sayısı')),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _hisseAmountController,
                    onChanged: calculateTotal,
                    decoration: InputDecoration(labelText: 'Hisse Tutarı')),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _totalAmountController,
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Toplam Tutar')),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: _aciklamaController,
                  maxLines: null,
                  minLines: 2,
                  decoration:
                      InputDecoration(labelText: 'Açıklama (İsteğe bağlı)'),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: ElevatedButton(
                      onPressed: addKurban, child: Text("Ekle"))),
            ],
          ),
        ),
      )),
    );
  }

  Future<void> addKurban() async {
    HisseKurbanModel hisseKurban = new HisseKurbanModel(
        int.parse(_saleNoController.text),
        int.parse(_kotraNoController.text),
        int.parse(_hisseNumController.text),
        int.parse(_hisseAmountController.text),
        aciklama: _aciklamaController.text,
        remainingHisse: int.parse(_hisseNumController.text));
    await DataRepository.instance.addItem(hisseKurban);
    Navigator.pop(context);
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
