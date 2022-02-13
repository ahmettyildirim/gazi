import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/customer.dart';
import 'package:gazi_app/pages/add_customer.dart';
import 'package:gazi_app/pages/customer_detail.dart';

class CustomerList extends StatefulWidget {
  late bool selectable;
  late Function(CustomerModel)? onCustomerSelected;
  CustomerList({
    Key? key,
    this.selectable = false,
    this.onCustomerSelected,
  }) : super();
  _CustomerListState createState() => _CustomerListState();
}

var _repositoryInstance = DataRepository.instance;
Future<void> getCustomersNew() async {}

class _CustomerListState extends State<CustomerList> {
  final _nameController = TextEditingController();
  String _searchText = "";
  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      if (_nameController.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _nameController.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0, bottom: 0),
            child: TextField(
              keyboardType:
                  TextInputType.numberWithOptions(decimal: true, signed: true),
              controller: _nameController,
              decoration:
                  InputDecoration(labelText: "Müşteri Adı ya da cep telefonu ile filtrele"),
            ),
          ),
          TextButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddCustomer()));
              },
              icon: Icon(Icons.add),
              label: Text("Yeni Müşteri Ekle")),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _repositoryInstance.getAllItems(CollectionKeys.customers,
                  orderBy: FieldKeys.customerName),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var customerValues = snapshot.data!.docs
                      .where((element) =>
                          (element
                              .data()[FieldKeys.customerName]
                              .toString()
                              .toLowerCase()
                              .contains(_searchText.toLowerCase())) ||
                          (element
                              .data()[FieldKeys.customerPhone]
                              .toString()
                              .replaceAll(' ', '')
                              .replaceAll('(', '')
                              .replaceAll(')', '')
                              .replaceAll('-', '')
                              .contains(_searchText
                                  .replaceAll(' ', '')
                                  .replaceAll('(', '')
                                  .replaceAll(')', '')
                                  .replaceAll('-', ''))))
                      .toList(); //.snapshot.value;
                  return ListView.builder(
                    itemCount: customerValues.length,
                    itemBuilder: (context, index) {
                      var customer =
                          CustomerModel.fromJson(customerValues[index].data(),id: customerValues[index].id);
                      return GestureDetector(
                        onTap: () {
                          if (widget.onCustomerSelected != null) {
                            widget.onCustomerSelected!(customer);
                            Navigator.pop(context);
                          }else{
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    // BubbleScreen()
                                    CustomerDetail(
                                      customer: customer,
                                    )));
                          }
                        },
                        child: Card(
                          child: ListTile(
                              dense: true,
                              title: Text(customer.name),
                              subtitle: Text(customer.phone),
                              leading: const Icon(Icons.account_box_rounded)),
                        ),
                      );
                    },
                  );
                } else {
                  return Center();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
