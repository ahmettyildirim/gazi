import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/customer.dart';
import 'package:gazi_app/pages/add_customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerList extends StatefulWidget {
  @override
  _CustomerListState createState() => _CustomerListState();
}

var _repositoryInstance = DataRepository.instance;
// var refCustomers = FirebaseDatabase.instance.reference().child("customers");
// var refCustomersNew = FirebaseFirestore.instance.collection("customers");
// Future<void> getCustomers() async {
//   refCustomers.onValue.listen((event) {
//     var values = event.snapshot.value;
//     if (values != null) {
//       values.forEach((key, value) {
//         var customer = CustomerModel.fromJson(value);
//       });
//     }
//   });
// }

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
    // getCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  hintText: "Müşteri Adı ya da cep telefonu ile filtrele",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddCustomer()));
              },
              child: Text("Yeni Müşteri Ekle")),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _repositoryInstance.getAllItems(CollectionKeys.customers),
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
                          CustomerModel.fromJson(customerValues[index].data());
                      return Dismissible(
                        key: ObjectKey(customer),
                        child: Card(
                          child: ListTile(
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
