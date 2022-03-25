import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/general_model.dart';

class HisseKurbanModel implements GenericModel {
  String id = "";
  int kurbanNo;
  int kotraNo;
  int hisseNo;
  int hisseAmount;
  bool? isVekalet;
  int remainingHisse = 0;
  late String? aciklama;
  late int buyukKurbanTip = 0;
  late CollectionReference<Map<String, dynamic>> colRef;
  late DateTime? createTime;
  late String? createUser;
  String collectionReferenceName = CollectionKeys.hisseKurban;

  HisseKurbanModel(this.kurbanNo, this.kotraNo, this.hisseNo, this.hisseAmount,
      {this.remainingHisse = 0,
      this.id = "",
      this.aciklama = "",
      this.createTime,
      this.createUser,
      required this.buyukKurbanTip,
      this.isVekalet = false}) {
    this.collectionReferenceName = CollectionKeys.hisseKurban;
    this.colRef = DataRepository.instance
        .getCollectionReference(CollectionKeys.hisseKurban);
  }

  factory HisseKurbanModel.fromJson(Map<dynamic, dynamic> json,
      {String id = ""}) {
    return HisseKurbanModel(
        json[FieldKeys.hisseKurbanKurbanNo] as int,
        json[FieldKeys.hisseKurbanKotraNo] as int,
        json[FieldKeys.hisseKurbanHisseNum] as int,
        json[FieldKeys.hisseKurbanHisseAmount] as int,
        buyukKurbanTip: json[FieldKeys.saleBuyukKurbanTip] as int,
        aciklama: (json[FieldKeys.aciklama] ?? "") as String,
        createTime: (json[FieldKeys.createTime] as Timestamp).toDate(),
        createUser: json[FieldKeys.createUser] as String,
        remainingHisse: json[FieldKeys.hisseKurbanRemainingHisse] as int,
        isVekalet: (json[FieldKeys.isVekalet] ?? false) as bool,
        id: id);
  }
  HashMap<String, dynamic> toMap() {
    var hisseKurban = HashMap<String, dynamic>();
    hisseKurban[FieldKeys.hisseKurbanKurbanNo] = this.kurbanNo;
    hisseKurban[FieldKeys.hisseKurbanKotraNo] = this.kotraNo;
    hisseKurban[FieldKeys.hisseKurbanHisseNum] = this.hisseNo;
    hisseKurban[FieldKeys.saleBuyukKurbanTip] = this.buyukKurbanTip;
    hisseKurban[FieldKeys.hisseKurbanHisseAmount] = this.hisseAmount;
    hisseKurban[FieldKeys.hisseKurbanRemainingHisse] = this.remainingHisse;
    hisseKurban[FieldKeys.aciklama] = this.aciklama;
    hisseKurban[FieldKeys.isVekalet] = this.isVekalet ?? false;
    return hisseKurban;
  }

  @override
  int? festYear;
}
