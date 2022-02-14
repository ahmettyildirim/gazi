import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'dart:collection';

import 'package:gazi_app/model/general_model.dart';

String getMaliyetName(int typeId) {
  switch (typeId) {
    case 1:
      return "Dana/Düve Maliyeti";
    case 2:
      return "Kuzuların Maliyeti";
    case 3:
      return "Toplam Yem Maliyeti";
    case 4:
      return "Toplam Tuz Maliyeti";
    case 5:
      return "Toplam Saman Maliyeti";
    case 6:
      return "Toplam Yonca Maliyeti";
    case 7:
      return "Toplam Pancar Küspesi Maliyeti";
    case 8:
      return "Toplam Arpa Küspesi Maliyeti";
    case 9:
      return "Yıllık Bakıcı Maaşları Toplamı";
    case 10:
      return "Yıllık Elektrik Faturası Toplamı";
    case 11:
      return "Kasaplara Ödenen Toplam Tutar";
    case 12:
      return "Çalışanlara Ödenen Toplam Tutar";
    case 13:
      return "Ambalajcıya Ödenen Toplam Tutar";
    case 14:
      return "Sucuk, Ekmek, Ayran,Su Maliyeti";
    case 15:
      return "Yıllık Traktör Mazot Ücreti";
    case 16:
      return "Yıllık Traktör Bakım Ücreti";
    case 17:
      return "Ekstra Maliyetler";
    case 18:
      return "Toplam Tutar";
    case 19:
      return "Dana Satış";
    case 20:
      return "Kuzu Satış";
    case 21:
      return "Toplam Kar";
    default:
      return "";
  }
}

String getToplamSayiAdi(int typeId) {
  switch (typeId) {
    case 1:
      return "Dana/Düve Sayısı";
    case 2:
      return "Kuzuların Sayısı";
    default:
      return "";
  }
}

String getAdetSayisiName(int typeId, {int subTypeId = 0}) {
  switch (typeId) {
    case 1:
      return "Dana/Düve Toplam KG";
    case 2:
      return "Kuzu Toplam KG";
    case 3:
      return "Yem Çuvalı Adedi";
    case 4:
      return "Tuz Çuvalı Adedi";
    case 5:
      return "Saman Balyası Adedi";
    case 6:
      return "Yonca Balyası Adedi";
    case 7:
      return "Pancar Küspesi Toplam KG";
    case 8:
      return "Arpa Küspesi Toplam KG";
    default:
      return "";
  }
}

String getAdetSayisiNameWithSubType(int subTypeId) {
  switch (subTypeId) {
    case 1:
      return "";
    case 2:
      return "";
    case 3:
      return "";
    case 4:
      return "";
    case 5:
      return "";
    default:
      return "";
  }
}

String getAdetTutar(int typeId, {int subTypeId = 0}) {
  switch (typeId) {
    case 1:
      return "Dana/Düve KG Fiyatı";
    case 2:
      return "Kuzu KG Fiyatı";
    case 3:
    case 4:
      return "Çuval Fiyatı";
    case 5:
    case 6:
      return "Balya Fiyatı";
    case 7:
    case 8:
      return "Kg Fiyatı";
    default:
      return "";
  }
}

String getAdetTutarWithSubType(int subTypeId) {
  return "";
}

String getMaliyetDetayTitle(int typeId, {int subTypeId = 0}) {
  switch (typeId) {
    case 1:
      return "Dana/Düve Maliyeti";
    case 2:
      return "Kuzuların Maliyeti";
    case 3:
      return "Yem Maliyeti";
    case 4:
      return "Tuz Maliyeti";
    case 5:
      return "Saman Maliyeti";
    case 6:
      return "Yonca Maliyeti";
    case 7:
      return "Pancar Küspesi Maliyeti";
    case 8:
      return "Arpa Küspesi Maliyeti";
    case 9:
      return "Bakıcı Maliyeti";
    case 10:
      return "Elektrik Maliyeti";
    case 11:
      return "Kasap Maliyeti";
    case 12:
      return "Çalışan Maliyeti";
    case 13:
      return "Ambalajcı Maliyeti";
    case 14:
      return "Sucuk, Ekmek, Ayran,Su Maliyeti";
    case 15:
      return "Traktör Mazot Maliyeti";
    case 16:
      return "Traktör Bakım Maliyeti";
    case 17:
      return "Ekstra Maliyetler";
    case 18:
      return "Toplam Maliyet";
    case 18:
      return "Toplam Tutar";
    case 18:
      return "Toplam Tutar";
    case 18:
      return "Toplam Tutar";
    default:
      return "";
  }
}

String getToplamTutarWithSubType(int subTypeId) {
  return "";
}

class MaliyetModel implements GenericModel {
  late int maliyetTip;
  late int altMaliyetTip;
  late int toplamTutar;
  late int toplamSayi; //dana-kuzu sayısı
  late int adetSayisi; //dana-kuzu toplam kg
  late int adetTutari; //dana kuzu kg tutarı
  late String? aciklama;
  String id = "";
  late CollectionReference<Map<String, dynamic>> colRef;
  late String collectionReferenceName = CollectionKeys.maliyet;
  late DateTime? createTime;
  late String? createUser;

  MaliyetModel({
    required this.maliyetTip,
    required this.altMaliyetTip,
    required this.toplamTutar,
    required this.toplamSayi,
    this.aciklama = "",
    this.adetSayisi = 0,
    this.adetTutari = 0,
    this.createTime,
    this.createUser,
    this.id = "",
  }) {
    this.colRef =
        DataRepository.instance.getCollectionReference(CollectionKeys.maliyet);
  }
  @override
  HashMap<String, dynamic> toMap() {
    var maliyet = HashMap<String, dynamic>();
    maliyet[FieldKeys.maliyetTip] = this.maliyetTip;
    maliyet[FieldKeys.maliyetAltTip] = this.toplamTutar;
    maliyet[FieldKeys.maliyetToplamTutar] = this.toplamTutar;
    maliyet[FieldKeys.maliyetToplamSayi] = this.toplamSayi;
    maliyet[FieldKeys.maliyetAdetSayisi] = this.adetSayisi;
    maliyet[FieldKeys.maliyetAdetTutari] = this.adetTutari;
    maliyet[FieldKeys.aciklama] = this.aciklama;
    return maliyet;
  }

  factory MaliyetModel.fromJson(Map<dynamic, dynamic> json, {String id = ""}) {
    return MaliyetModel(
        maliyetTip: json[FieldKeys.maliyetTip] as int,
        altMaliyetTip: json[FieldKeys.maliyetAltTip] as int,
        toplamTutar: json[FieldKeys.maliyetToplamTutar] as int,
        toplamSayi: json[FieldKeys.maliyetToplamSayi] as int,
        adetSayisi: json[FieldKeys.maliyetAdetSayisi] as int,
        adetTutari: json[FieldKeys.maliyetAdetTutari] as int,
        createTime: (json[FieldKeys.createTime] as Timestamp).toDate(),
        createUser: json[FieldKeys.createUser] as String,
        aciklama: json[FieldKeys.aciklama] as String?,
        id: id);
  }
}
