import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/general_model.dart';

class HisseModel implements GenericModel {
  String id = "";
  int amount;
  int count;
  late String collectionReferenceName;

  HisseModel(this.amount, this.count) {
    this.colRef =
        DataRepository.instance.getCollectionReference(CollectionKeys.hisse);
  }

  factory HisseModel.fromJson(Map<dynamic, dynamic> json) {
    return HisseModel(
      json["amount"] as int,
      json["count"] as int,
    );
  }

  @override
  HashMap<String, dynamic> toMap() {
    var item = HashMap<String, dynamic>();
    item[FieldKeys.hisseAmount] = this.amount;
    item[FieldKeys.hisseCount] = this.count;
    return item;
  }

  @override
  late CollectionReference<Map<String, dynamic>> colRef;
}
