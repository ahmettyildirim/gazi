import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';

class AddHisse extends StatefulWidget {
  @override
  _AddHisseState createState() => _AddHisseState();
}

class _AddHisseState extends State<AddHisse> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_AddHisseFormState');
  final _amountController = TextEditingController();
  final _countController = TextEditingController();
  Future<void> addHisse() async {
    await addNewHisse(
        int.parse(_amountController.text), int.parse(_countController.text));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var screenInfo = MediaQuery.of(context);
    final screenWidth = screenInfo.size.width;
    final screenHeight = screenInfo.size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni Kotra Ekle"),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(screenHeight / 30),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  decoration: InputDecoration(hintText: 'Hisse Tutarı'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenHeight / 30),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _countController,
                  decoration: InputDecoration(hintText: 'Hisse Miktarı'),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(screenHeight / 30),
                  child:
                      ElevatedButton(onPressed: addHisse, child: Text("Ekle"))),
            ],
          ),
        ),
      )),
    );
  }
}
