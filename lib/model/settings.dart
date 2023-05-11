import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/general_model.dart';

class SettingsModel implements GenericModel {
  String id = "";
  int startHour;
  int startMinute;
  int buyukbasEndHour;
  int buyukbasEndMinute;
  int kucukbasEndHour;
  int kucukbasEndMinute;
  int buyukbasNumber;
  int kucukbasNumber;
  late String collectionReferenceName;
  late DateTime? createTime;
  late String? createUser;

  SettingsModel(
    this.startHour,
    this.startMinute,
    this.buyukbasEndHour,
    this.buyukbasEndMinute,
    this.buyukbasNumber,
    this.kucukbasEndHour,
    this.kucukbasEndMinute,
    this.kucukbasNumber, {
    this.createTime,
    this.createUser,
  }) {
    this.colRef =
        DataRepository.instance.getCollectionReference(CollectionKeys.settings);
  }

  factory SettingsModel.fromJson(Map<dynamic, dynamic> json, {String id = ""}) {
    return SettingsModel(
      json["startHour"] as int,
      json["startMinute"] as int,
      json["buyukbasEndHour"] as int,
      json["buyukbasEndMinute"] as int,
      json["buyukbasNumber"] as int,
      json["kucukbasEndHour"] as int,
      json["kucukbasEndMinute"] as int,
      json["kucukbasNumber"] as int,
      createTime: (json[FieldKeys.createTime] as Timestamp).toDate(),
      createUser: json[FieldKeys.createUser] as String,
    );
  }

  @override
  late CollectionReference<Map<String, dynamic>> colRef;

  @override
  HashMap<String, dynamic> toMap() {
    var settings = HashMap<String, dynamic>();
    settings[FieldKeys.startHour] = this.startHour;
    settings[FieldKeys.startMinute] = this.startMinute;
    settings[FieldKeys.buyukbasEndHour] = this.buyukbasEndHour;
    settings[FieldKeys.buyukbasEndMinute] = this.buyukbasEndMinute;
    settings[FieldKeys.buyukbasNumber] = this.buyukbasNumber;
    settings[FieldKeys.kucukbasEndHour] = this.kucukbasEndHour;
    settings[FieldKeys.kucukbasEndMinute] = this.kucukbasEndMinute;
    settings[FieldKeys.kucukbasNumber] = this.kucukbasNumber;
    return settings;
  }

  @override
  int? festYear;
}
