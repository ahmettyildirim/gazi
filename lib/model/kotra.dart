import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/general_model.dart';

class KotraModel implements GenericModel {
  String id = "";
  int no;
  int capacity;
  int numOfItems;
  late String collectionReferenceName;

  KotraModel(this.no, this.capacity, this.numOfItems) {
    this.colRef =
        DataRepository.instance.getCollectionReference(CollectionKeys.kotra);
  }

  factory KotraModel.fromJson(Map<dynamic, dynamic> json) {
    return KotraModel(
      json["no"] as int,
      json["capacity"] as int,
      json["numOfItems"] as int,
    );
  }

  @override
  late CollectionReference<Map<String, dynamic>> colRef;

  @override
  HashMap<String, dynamic> toMap() {
    var kotra = HashMap<String, dynamic>();
    kotra[FieldKeys.kotraNo] = this.no;
    kotra[FieldKeys.kotraCapacity] = this.capacity;
    kotra[FieldKeys.kotraNumOfItems] = this.numOfItems;
    return kotra;
  }
}
