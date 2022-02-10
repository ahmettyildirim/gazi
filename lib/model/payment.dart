import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/general_model.dart';

enum PaymentType { Nakit, KrediKarti, Senet, Havale }

class PaymentModel implements GenericModel {
  String id = "";
  int amount;
  String paymentType;
  late String? aciklama;
  late String collectionReferenceName;
  late DateTime? createTime;
  late String? createUser;

  PaymentModel(
      {required this.amount,
      required this.paymentType,
      required this.aciklama,
      this.createTime,
      this.createUser,
      this.id = ""}) {
    this.colRef =
        DataRepository.instance.getCollectionReference(CollectionKeys.payment);
  }

  factory PaymentModel.fromJson(Map<dynamic, dynamic> json, {String id = ""}) {
    return PaymentModel(
        amount: json[FieldKeys.paymentAmount] as int,
        paymentType: json[FieldKeys.paymentType] as String,
        aciklama: json[FieldKeys.aciklama] as String?,
        createTime: (json[FieldKeys.createTime] as Timestamp).toDate(),
        createUser: json[FieldKeys.createUser] as String,
        id: id);
  }

  @override
  HashMap<String, dynamic> toMap() {
    var item = HashMap<String, dynamic>();
    item[FieldKeys.paymentAmount] = this.amount;
    item[FieldKeys.paymentType] = this.paymentType;
    item[FieldKeys.aciklama] = this.aciklama ?? "";
    return item;
  }

  @override
  late CollectionReference<Map<String, dynamic>> colRef;
}
