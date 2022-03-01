import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/general_model.dart';

class CustomerModel implements GenericModel {
  String id = "";
  String name;
  String phone;
  late CollectionReference<Map<String, dynamic>> colRef;
  String collectionReferenceName = CollectionKeys.customers;
  late String? aciklama;
  late DateTime? createTime;
  late String? createUser;

  CustomerModel(
    this.name,
    this.phone, {
    this.id = "",
    this.aciklama = "",
    this.createTime,
    this.createUser,
  }) {
    this.colRef = DataRepository.instance
        .getCollectionReference(CollectionKeys.customers);
  }

  factory CustomerModel.fromJson(Map<dynamic, dynamic> json, {String id = ""}) {
    return CustomerModel(json["name"] as String, json["phone_number"] as String,
        aciklama: (json[FieldKeys.aciklama] ?? ""),
        createTime: json[FieldKeys.createTime] == null
            ? DateTime.now()
            : (json[FieldKeys.createTime] as Timestamp).toDate(),
        createUser: (json[FieldKeys.createUser] ?? "") as String,
        id: id);
  }
  // CustomerModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
  //     : this.fromJson(snapshot.data());

  HashMap<String, dynamic> toMap() {
    var customer = HashMap<String, dynamic>();
    customer[FieldKeys.customerName] = this.name;
    customer[FieldKeys.customerPhone] = this.phone;
    customer[FieldKeys.aciklama] = this.aciklama;
    return customer;
  }

  @override
  int? festYear;

  // CustomerModel.fromMap(Map<String, dynamic> map) {
  //   this.name = map[FieldKeys.customerName];
  //   this.email = map[FieldKeys.customerMail] ?? "";
  //   this.phone = map[FieldKeys.customerPhone];
  // }
}
