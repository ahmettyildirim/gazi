import 'package:flutter/material.dart';

import 'package:gazi_app/model/customer.dart';
import 'package:gazi_app/pages/customers.dart';

class CustomerSelect extends StatefulWidget {
  late Function(CustomerModel)? onCustomerSelected;
  CustomerSelect({Key? key, this.onCustomerSelected}) : super(key: key);

  @override
  _CustomerSelectState createState() => _CustomerSelectState();
  _onCustomerSelected(CustomerModel model) {
    print(model.name);
    this.onCustomerSelected!(model);
  }
}

class _CustomerSelectState extends State<CustomerSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Müşteri Seçim Ekranı"),
      ),
      body: CustomerList(
        selectable: true,
        onCustomerSelected: widget._onCustomerSelected,
      ),
    );
  }
}
