import 'package:flutter/material.dart';
import 'package:gazi_app/model/customer.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:gazi_app/common/data_repository.dart';

class AddCustomer extends StatefulWidget {
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_AddCustomerFormState');
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '(###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});

  Future<void> addCustomer() async {
    CustomerModel customer = new CustomerModel(
        _nameController.text,  _phoneController.text);
    await DataRepository.instance.addItem(customer);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var screenInfo = MediaQuery.of(context);
    final screenWidth = screenInfo.size.width;
    final screenHeight = screenInfo.size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni Müşteri Ekle"),
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
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  inputFormatters: [maskFormatter],
                  decoration: InputDecoration(hintText: 'Cep Telefonu'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenHeight / 30),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: 'Ad-Soyad'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenHeight / 30),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(hintText: 'Mail Adresi'),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(screenHeight / 30),
                  child: ElevatedButton(
                      onPressed: addCustomer, child: Text("Ekle"))),
            ],
          ),
        ),
      )),
    );
  }
}
