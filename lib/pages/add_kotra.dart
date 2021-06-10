import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';

class AddKotra extends StatefulWidget {
  _AddKotraState createState() => _AddKotraState();
}

class _AddKotraState extends State<AddKotra> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_AddKotraFormState');
  final _capasityController = TextEditingController();
  final _kotraNoController = TextEditingController();

  Future<void> addKotra() async {
    await addNewKotra(int.parse(_kotraNoController.text),
        int.parse(_capasityController.text));
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
                  controller: _kotraNoController,
                  decoration: InputDecoration(hintText: 'Kotra Numarası'),
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
