import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/kotra.dart';

class AddKotra extends StatefulWidget {
  _AddKotraState createState() => _AddKotraState();
}

class _AddKotraState extends State<AddKotra> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_AddKotraFormState');
  final _capasityController = TextEditingController();
  final _kotraNoController = TextEditingController();

  Future<void> addKotra() async {
    KotraModel kotra = new KotraModel(int.parse(_kotraNoController.text),
        int.parse(_capasityController.text), 0);
    await DataRepository.instance.addItem(kotra);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var screenInfo = MediaQuery.of(context);
    final screenWidth = screenInfo.size.width;
    final screenHeight = screenInfo.size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni Kotar Ekle"),
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
                  controller: _kotraNoController,
                  decoration: InputDecoration(hintText: 'Kotar Numarası'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenHeight / 30),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _capasityController,
                  decoration: InputDecoration(hintText: 'Kapasite'),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(screenHeight / 30),
                  child:
                      ElevatedButton(onPressed: addKotra, child: Text("Ekle"))),
            ],
          ),
        ),
      )),
    );
  }
}
