import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/general_model.dart';

class HisseKurbanModel implements GenericModel {
  int kurbanNo;
  int kotraNo;
  int hisseNo;
  int hisseAmount;
  int remainingHisse = 0;
  late CollectionReference<Map<String, dynamic>> colRef;

  HisseKurbanModel(
      this.kurbanNo, this.kotraNo, this.hisseNo, this.hisseAmount, {this.remainingHisse = 0}) {
    this.colRef = DataRepository.instance
        .getCollectionReference(CollectionKeys.hisseKurban);
  }

  factory HisseKurbanModel.fromJson(Map<dynamic, dynamic> json) {
    return HisseKurbanModel(
      json[FieldKeys.hisseKurbanKurbanNo] as int,
      json[FieldKeys.hisseKurbanKotraNo] as int,
      json[FieldKeys.hisseKurbanHisseNum] as int,
      json[FieldKeys.hisseKurbanHisseAmount] as int,
      remainingHisse: json[FieldKeys.hisseKurbanRemainingHisse] as int,
    );
  }
  HashMap<String, dynamic> toMap() {
    var hisseKurban = HashMap<String, dynamic>();
    hisseKurban[FieldKeys.hisseKurbanKurbanNo] = this.kurbanNo;
    hisseKurban[FieldKeys.hisseKurbanKotraNo] = this.kotraNo;
    hisseKurban[FieldKeys.hisseKurbanHisseNum] = this.hisseNo;
    hisseKurban[FieldKeys.hisseKurbanHisseAmount] = this.hisseAmount;
    hisseKurban[FieldKeys.hisseKurbanRemainingHisse] = this.remainingHisse;
    return hisseKurban;
  }

}
