import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/model/customer.dart';
import 'package:gazi_app/pages/add_customer.dart';

class KurbanPage extends StatefulWidget {
  @override
  _KurbanPageState createState() => _KurbanPageState();
}

var refCustomers = FirebaseDatabase.instance.reference().child("customers");
Future<void> getCustomers() async {
  refCustomers.onValue.listen((event) {
    var values = event.snapshot.value;
    if (values != null) {
      values.forEach((key, value) {
        var customer = CustomerModel.fromJson(value);
        print("********************");
        print("key  : $key");
        print("name  : ${customer.name}}");
        print("phone  : ${customer.phone}}");
        print("mail  : ${customer.email}}");
      });
    }
  });
}

class _KurbanPageState extends State<KurbanPage> {
  @override
  void initState() {
    super.initState();
    getCustomers();
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
              child: Text("Yeni Kurban Ekle")),
          Expanded(
            child: StreamBuilder<Event>(
              stream: refCustomers.onValue,
              builder: (context, event) {
                if (event.hasData) {
                  var customers = <CustomerModel>[];
                  var customerValues = event.data!.snapshot.value;
                  if (customerValues != null) {
                    customerValues.forEach((key, value) {
                      var customer = CustomerModel.fromJson(value);
                      customers.add(customer);
                    });
                  }
                  return ListView.builder(
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      var customer = customers[index];

                      return Card(
                        child: ListTile(
                            title: Text(customer.name),
                            subtitle: Text(customer.phone),
                            leading: const Icon(Icons.account_box_rounded)),
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
