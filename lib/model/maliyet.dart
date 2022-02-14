import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'dart:collection';

import 'package:gazi_app/model/general_model.dart';

String getMaliyetName(int typeId) {
  switch (typeId) {
    case 1:
      return "Danaların Maliyeti";
    case 2:
      return "Kuzuların Maliyeti";
    case 3:
      return "Toplam Yem-Saman Vs Tutarı";
    case 4:
      return "Yıllık Bakıcı Maaşları Toplamı";
    case 5:
      return "Yıllık Elektrik Faturası Toplamı";
    case 6:
      return "Kasaplara Ödenen Kasaplara Ödenen Kasaplara ÖdenenKasaplara Ödenen Kasaplara Ödenen Kasaplara Ödenen Kasaplara Ödenen Kasaplara Ödenen Toplam Tutar";
    case 7:
      return "Ambalajcıya Ödenen Toplam Tutar";
    case 8:
      return "Sucuk, Ekmek, Ayran,Su Maliyeti";
    case 9:
      return "Ekstra Maliyetler";
    case 10:
      return "Toplam Tutar";
    default:
      return "";
  }
}

class MaliyetModel implements GenericModel {
  late int maliyetTip;
  late int toplamTutar;
  String id = "";
  late CollectionReference<Map<String, dynamic>> colRef;
  late String collectionReferenceName = CollectionKeys.sales;
  late DateTime? createTime;
  late String? createUser;

  @override
  HashMap<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
