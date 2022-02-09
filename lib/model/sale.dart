import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/customer.dart';
import 'package:gazi_app/model/general_model.dart';

String getBuyukKurbanCins(int typeId) {
  return typeId == 1 ? "Dana" : "Düve";
}

String getKurbanTypeName(int typeId) {
  return typeId == 1 ? "Büyükbaş" : "Küçükbaş";
}

String getKurbanSubTypeName(int typeId) {
  switch (typeId) {
    case 1:
      return "Ayaktan(Kilo)";
    case 2:
      return "Karkas";
    case 3:
      return "Ayaktan";
    case 4:
      return "Hisse";
    case 5:
      return "Ayaktan(Kilo)";
    case 6:
      return "Ayaktan";
    default:
      return "";
  }
}

class SaleModel implements GenericModel {
  String id = "";
  late String customerRef;
  late int kurbanTip = 0;
  late int buyukKurbanTip = 0;
  late int kurbanSubTip = 0;
  late int kurbanNo;
  late int kg;
  late int kgAmount;
  late int amount;
  late int generalAmount;
  late int kaparo;
  late int remainingAmount;
  late String hisseRef;
  late int hisseNum;
  late int adet;
  late String? aciklama;
  late CollectionReference<Map<String, dynamic>> colRef;
  late String collectionReferenceName = CollectionKeys.sales;
  late DateTime? createTime;
  late String? createUser;
  late CustomerModel customer;

  SaleModel(
      {required this.customerRef,
      required this.kurbanTip,
      required this.buyukKurbanTip,
      required this.kurbanSubTip,
      required this.kurbanNo,
      required this.kg,
      required this.kgAmount,
      required this.amount,
      required this.generalAmount,
      required this.kaparo,
      required this.remainingAmount,
      required this.hisseRef,
      required this.hisseNum,
      required this.adet,
      required this.aciklama,
      this.createTime,
      this.createUser,
      required this.customer}) {
    this.colRef =
        DataRepository.instance.getCollectionReference(CollectionKeys.sales);
  }

  factory SaleModel.fromJson(Map<dynamic, dynamic> json) {
    return SaleModel(
        customerRef: json[FieldKeys.saleCustomerRef] as String,
        kurbanTip: json[FieldKeys.saleKurbanTip] as int,
        buyukKurbanTip: json[FieldKeys.saleBuyukKurbanTip] as int,
        kurbanSubTip: json[FieldKeys.saleKurbanSubTip] as int,
        kurbanNo: json[FieldKeys.saleKurbanNo] as int,
        kg: json[FieldKeys.saleKg] as int,
        kgAmount: json[FieldKeys.saleKgAmount] as int,
        amount: json[FieldKeys.saleAmount] as int,
        generalAmount: json[FieldKeys.saleGeneralAmount] as int,
        kaparo: json[FieldKeys.saleKaparo] as int,
        remainingAmount: json[FieldKeys.saleRemainingAmount] as int,
        hisseNum: json[FieldKeys.saleHisseNum] as int,
        hisseRef: json[FieldKeys.saleHisseRef] as String,
        adet: json[FieldKeys.saleAdet] as int,
        aciklama: json[FieldKeys.aciklama] as String?,
        createTime: (json[FieldKeys.createTime] as Timestamp).toDate(),
        createUser: json[FieldKeys.createUser] as String,
        customer: CustomerModel.fromJson(json[FieldKeys.customer]));
  }

  HashMap<String, dynamic> toMap() {
    var sale = HashMap<String, dynamic>();
    sale[FieldKeys.saleCustomerRef] = this.customerRef;
    sale[FieldKeys.saleKurbanTip] = this.kurbanTip;
    sale[FieldKeys.saleBuyukKurbanTip] = this.buyukKurbanTip;
    sale[FieldKeys.saleKurbanSubTip] = this.kurbanSubTip;
    sale[FieldKeys.saleKurbanNo] = this.kurbanNo;
    sale[FieldKeys.saleKg] = this.kg;
    sale[FieldKeys.saleKgAmount] = this.kgAmount;
    sale[FieldKeys.saleAmount] = this.amount;
    sale[FieldKeys.saleGeneralAmount] = this.generalAmount;
    sale[FieldKeys.saleKaparo] = this.kaparo;
    sale[FieldKeys.saleRemainingAmount] = this.remainingAmount;
    sale[FieldKeys.saleHisseNum] = this.hisseNum;
    sale[FieldKeys.saleHisseRef] = this.hisseRef;
    sale[FieldKeys.saleAdet] = this.adet;
    sale[FieldKeys.aciklama] = this.aciklama;
    sale[FieldKeys.customer] = this.customer.toMap();
    return sale;
  }
}
