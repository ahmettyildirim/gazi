import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/general_model.dart';

enum PaymentType { Nakit, KrediKarti, Senet, Havale }

class PaymentModel implements GenericModel {
  String id = "";
  int amount;
  String paymentType;
  late String collectionReferenceName;
  late DateTime? createTime;
  late String? createUser;

  PaymentModel({required this.amount, required this.paymentType}) {
    this.colRef =
        DataRepository.instance.getCollectionReference(CollectionKeys.payment);
  }

  factory PaymentModel.fromJson(Map<dynamic, dynamic> json) {
    return PaymentModel(
      amount: json["amount"] as int,
      paymentType: json["type"] as String,
    );
  }

  @override
  HashMap<String, dynamic> toMap() {
    var item = HashMap<String, dynamic>();
    item[FieldKeys.paymentAmount] = this.amount;
    item[FieldKeys.paymentType] = this.paymentType;
    return item;
  }

  @override
  late CollectionReference<Map<String, dynamic>> colRef;
}
