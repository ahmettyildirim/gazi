import 'package:flutter/material.dart';

class AddKurban extends StatefulWidget {
  @override
  _AddKurbanState createState() => _AddKurbanState();
}

class _AddKurbanState extends State<AddKurban> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_AddCustomerFormState');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni Kurban Ekle"),
      ),
      body: Text("data"),
    );
  }
}
