import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/maliyet.dart';
import 'package:gazi_app/model/sale.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'package:intl/intl.dart';

var _repositoryInstance = DataRepository.instance;
List<QueryDocumentSnapshot<Map<String, dynamic>>> getFilteredResults(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> saleList,
    String filter,
    String filterValue) {
  return saleList
      .where((element) => (element.data()[filter].toString() == filterValue))
      .toList();
}

Future<void> createExcelReport() async {
  // final xls.Workbook workbook = xls.Workbook();
  // final xls.Worksheet sheet = workbook.worksheets[0];
  // sheet.getRangeByName('A1').setText('Hello World!');
  // final List<int> bytes = workbook.saveAsStream();
  // workbook.dispose();

  var bytes = await _createReport();
  String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final String path = (await getApplicationSupportDirectory()).path;
  final String fileName = '$path/rapor_$date.xlsx';
  final File file = File(fileName);
  await file.writeAsBytes(bytes, flush: true);
  // await sendMail(file);
  await OpenFile.open(fileName);
  // file.open();
}

Future<List<int>> _createReport() async {
  var salesRef = await _repositoryInstance
      .getCollectionReference(CollectionKeys.sales)
      .get();
  var saleValues = salesRef.docs;

  List<MaliyetModel> maliyetList = List.empty(growable: true);
  var maliyetRef = await _repositoryInstance
      .getCollectionReference(CollectionKeys.maliyet)
      .get();
  var maliyetValues = maliyetRef.docs;
  for (int i = 0; i < maliyetValues.length; i++) {
    maliyetList.add(MaliyetModel.fromJson(maliyetValues[i].data()));
  }

  List<SaleModel> saleListTip1 = List.empty(growable: true);
  List<SaleModel> saleListTip2 = List.empty(growable: true);
  List<SaleModel> saleListTip3 = List.empty(growable: true);
  List<SaleModel> saleListTip4 = List.empty(growable: true);
  List<SaleModel> saleListTip5 = List.empty(growable: true);
  List<SaleModel> saleListTip6 = List.empty(growable: true);
  for (int i = 0; i < saleValues.length; i++) {
    var sale = SaleModel.fromJson(saleValues[i].data());
    switch (sale.kurbanSubTip) {
      case 1:
        saleListTip1.add(sale);
        break;
      case 2:
        saleListTip2.add(sale);
        break;
      case 3:
        saleListTip3.add(sale);
        break;
      case 4:
        saleListTip4.add(sale);
        break;
      case 5:
        saleListTip5.add(sale);
        break;
      case 6:
        saleListTip6.add(sale);
        break;
      default:
    }
  }
  final xls.Workbook workbook = xls.Workbook();
  final xls.Worksheet sheet1 = workbook.worksheets[0];
  sheet1.name = getKurbanTypeName(1) + "-" + getKurbanSubTypeName(1);
  _createSheet1(sheet1, saleListTip1);
  workbook.worksheets.add();
  final xls.Worksheet sheet2 = workbook.worksheets[1];
  sheet2.name = getKurbanTypeName(1) + "-" + getKurbanSubTypeName(2);
  _createSheet2(sheet2, saleListTip2);
  workbook.worksheets.add();
  final xls.Worksheet sheet3 = workbook.worksheets[2];
  sheet3.name = getKurbanTypeName(1) + "-" + getKurbanSubTypeName(3);
  _createSheet3(sheet3, saleListTip3);
  workbook.worksheets.add();
  final xls.Worksheet sheet4 = workbook.worksheets[3];
  sheet4.name = getKurbanTypeName(1) + "-" + getKurbanSubTypeName(4);
  _createSheet4(sheet4, saleListTip4);
  workbook.worksheets.add();
  final xls.Worksheet sheet5 = workbook.worksheets[4];
  sheet5.name = getKurbanTypeName(2) + "-" + getKurbanSubTypeName(5);
  _createSheet5(sheet5, saleListTip5);
  workbook.worksheets.add();
  final xls.Worksheet sheet6 = workbook.worksheets[5];
  sheet6.name = getKurbanTypeName(2) + "-" + getKurbanSubTypeName(6);
  _createSheet6(sheet6, saleListTip6);

  workbook.worksheets.add();
  final xls.Worksheet sheet7 = workbook.worksheets[6];
  sheet7.name = "Maliyet Tablosu";
  _createSheet7(sheet7, maliyetList);


  final List<int> bytes = workbook.saveAsStream();

  //Dispose the document.
  workbook.dispose();
  return bytes;
}

_createSheet1(xls.Worksheet sheet, List<SaleModel> saleList) {
  sheet.getRangeByName("A1").setText("Kurban No");
  sheet.getRangeByName("B1").setText("Cinsi");
  sheet.getRangeByName("C1").setText("Müşteri Tel");
  sheet.getRangeByName("D1").setText("Müşteri Adı");
  sheet.getRangeByName("E1").setText("Kotra No");
  sheet.getRangeByName("F1").setText("Kg");
  sheet.getRangeByName("G1").setText("Kg Birim Fiyatı");
  sheet.getRangeByName("H1").setText("Genel Toplam");
  sheet.getRangeByName("I1").setText("Alınan Kaparo");
  sheet.getRangeByName("J1").setText("Kalan Tutar");
  sheet.getRangeByName("K1").setText("Açıklama");
  for (int i = 0; i < saleList.length; i++) {
    sheet.getRangeByName("A${i + 2}").setText(saleList[i].kurbanNo.toString());
    sheet
        .getRangeByName("B${i + 2}")
        .setText(saleList[i].buyukKurbanTip == 1 ? "Dana" : "Düve");
    sheet.getRangeByName("C${i + 2}").setText(saleList[i].customer.phone);
    sheet.getRangeByName("D${i + 2}").setText(saleList[i].customer.name);
    sheet.getRangeByName("E${i + 2}").setText(saleList[i].kotraNo.toString());
    sheet.getRangeByName("F${i + 2}").setText(saleList[i].kg.toString());
    sheet.getRangeByName("G${i + 2}").setText(saleList[i].kgAmount.toString());
    sheet
        .getRangeByName("H${i + 2}")
        .setText(saleList[i].generalAmount.toString());
    sheet.getRangeByName("I${i + 2}").setText(saleList[i].kaparo.toString());
    sheet
        .getRangeByName("J${i + 2}")
        .setText(saleList[i].remainingAmount.toString());
    sheet.getRangeByName("K${i + 2}").setText(saleList[i].aciklama.toString());
  }
  sheet.autoFitColumn(1);
  sheet.autoFitColumn(2);
  sheet.autoFitColumn(3);
  sheet.autoFitColumn(4);
  sheet.autoFitColumn(5);
  sheet.autoFitColumn(6);
  sheet.autoFitColumn(7);
  sheet.autoFitColumn(8);
  sheet.autoFitColumn(9);
  sheet.autoFitColumn(10);
  sheet.autoFitColumn(11);
}

_createSheet2(xls.Worksheet sheet, List<SaleModel> saleList) {
  sheet.getRangeByName("A1").setText("Kurban No");
  sheet.getRangeByName("B1").setText("Cinsi");
  sheet.getRangeByName("C1").setText("Müşteri Tel");
  sheet.getRangeByName("D1").setText("Müşteri Adı");
  sheet.getRangeByName("E1").setText("Kotra No");
  sheet.getRangeByName("F1").setText("Kg Birim Fiyatı");
  sheet.getRangeByName("G1").setText("Alınan Kaparo");
  sheet.getRangeByName("H1").setText("Açıklama");
  for (int i = 0; i < saleList.length; i++) {
    sheet.getRangeByName("A${i + 2}").setText(saleList[i].kurbanNo.toString());
    sheet
        .getRangeByName("B${i + 2}")
        .setText(saleList[i].buyukKurbanTip == 1 ? "Dana" : "Düve");
    sheet.getRangeByName("C${i + 2}").setText(saleList[i].customer.phone);
    sheet.getRangeByName("D${i + 2}").setText(saleList[i].customer.name);
    sheet.getRangeByName("E${i + 2}").setText(saleList[i].kotraNo.toString());
    sheet.getRangeByName("F${i + 2}").setText(saleList[i].kgAmount.toString());
    sheet.getRangeByName("G${i + 2}").setText(saleList[i].kaparo.toString());
    sheet.getRangeByName("H${i + 2}").setText(saleList[i].aciklama.toString());
  }
  sheet.autoFitColumn(1);
  sheet.autoFitColumn(2);
  sheet.autoFitColumn(3);
  sheet.autoFitColumn(4);
  sheet.autoFitColumn(5);
  sheet.autoFitColumn(6);
  sheet.autoFitColumn(7);
  sheet.autoFitColumn(8);
}

_createSheet3(xls.Worksheet sheet, List<SaleModel> saleList) {
  sheet.getRangeByName("A1").setText("Kurban No");
  sheet.getRangeByName("B1").setText("Cinsi");
  sheet.getRangeByName("C1").setText("Müşteri Tel");
  sheet.getRangeByName("D1").setText("Müşteri Adı");
  sheet.getRangeByName("E1").setText("Kotra No");
  sheet.getRangeByName("F1").setText("Birim Fiyatı");
  sheet.getRangeByName("G1").setText("Alınan Kaparo");
  sheet.getRangeByName("H1").setText("Kalan Tutar");
  sheet.getRangeByName("I1").setText("Açıklama");
  for (int i = 0; i < saleList.length; i++) {
    sheet.getRangeByName("A${i + 2}").setText(saleList[i].kurbanNo.toString());
    sheet
        .getRangeByName("B${i + 2}")
        .setText(saleList[i].buyukKurbanTip == 1 ? "Dana" : "Düve");
    sheet.getRangeByName("C${i + 2}").setText(saleList[i].customer.phone);
    sheet.getRangeByName("D${i + 2}").setText(saleList[i].customer.name);
    sheet.getRangeByName("E${i + 2}").setText(saleList[i].kotraNo.toString());
    sheet.getRangeByName("F${i + 2}").setText(saleList[i].amount.toString());
    sheet.getRangeByName("G${i + 2}").setText(saleList[i].kaparo.toString());
    sheet
        .getRangeByName("H${i + 2}")
        .setText(saleList[i].remainingAmount.toString());
    sheet.getRangeByName("I${i + 2}").setText(saleList[i].aciklama.toString());
  }
  sheet.autoFitColumn(1);
  sheet.autoFitColumn(2);
  sheet.autoFitColumn(3);
  sheet.autoFitColumn(4);
  sheet.autoFitColumn(5);
  sheet.autoFitColumn(6);
  sheet.autoFitColumn(7);
  sheet.autoFitColumn(8);
  sheet.autoFitColumn(9);
}

_createSheet4(xls.Worksheet sheet, List<SaleModel> saleList) {
  sheet.getRangeByName("A1").setText("Kurban No");
  sheet.getRangeByName("B1").setText("Cinsi");
  sheet.getRangeByName("C1").setText("Müşteri Tel");
  sheet.getRangeByName("D1").setText("Müşteri Adı");
  sheet.getRangeByName("E1").setText("Kotra No");
  sheet.getRangeByName("F1").setText("Hisse Sayısı");
  sheet.getRangeByName("G1").setText("Birim Fiyatı");
  sheet.getRangeByName("H1").setText("Genel Toplam");
  sheet.getRangeByName("I1").setText("Alınan Kaparo");
  sheet.getRangeByName("J1").setText("Kalan Tutar");
  sheet.getRangeByName("K1").setText("Açıklama");
  for (int i = 0; i < saleList.length; i++) {
    sheet.getRangeByName("A${i + 2}").setText(saleList[i].kurbanNo.toString());
    sheet
        .getRangeByName("B${i + 2}")
        .setText(saleList[i].buyukKurbanTip == 1 ? "Dana" : "Düve");
    sheet.getRangeByName("C${i + 2}").setText(saleList[i].customer.phone);
    sheet.getRangeByName("D${i + 2}").setText(saleList[i].customer.name);
    sheet.getRangeByName("E${i + 2}").setText(saleList[i].kotraNo.toString());
    sheet.getRangeByName("F${i + 2}").setText(saleList[i].hisseNum.toString());
    sheet.getRangeByName("G${i + 2}").setText(saleList[i].amount.toString());
    sheet
        .getRangeByName("H${i + 2}")
        .setText(saleList[i].generalAmount.toString());
    sheet.getRangeByName("I${i + 2}").setText(saleList[i].kaparo.toString());
    sheet
        .getRangeByName("J${i + 2}")
        .setText(saleList[i].remainingAmount.toString());
    sheet.getRangeByName("K${i + 2}").setText(saleList[i].aciklama.toString());
  }
  sheet.autoFitColumn(1);
  sheet.autoFitColumn(2);
  sheet.autoFitColumn(3);
  sheet.autoFitColumn(4);
  sheet.autoFitColumn(5);
  sheet.autoFitColumn(6);
  sheet.autoFitColumn(7);
  sheet.autoFitColumn(8);
  sheet.autoFitColumn(9);
  sheet.autoFitColumn(10);
  sheet.autoFitColumn(11);
}

_createSheet5(xls.Worksheet sheet, List<SaleModel> saleList) {
  sheet.getRangeByName("A1").setText("Kurban No");
  sheet.getRangeByName("B1").setText("Müşteri Tel");
  sheet.getRangeByName("C1").setText("Müşteri Adı");
  sheet.getRangeByName("D1").setText("Kotra No");
  sheet.getRangeByName("E1").setText("KG");
  sheet.getRangeByName("F1").setText("KG Birim Fiyatı");
  sheet.getRangeByName("G1").setText("Genel Toplam");
  sheet.getRangeByName("H1").setText("Alınan Kaparo");
  sheet.getRangeByName("I1").setText("Kalan Tutar");
  sheet.getRangeByName("J1").setText("Açıklama");
  for (int i = 0; i < saleList.length; i++) {
    sheet.getRangeByName("A${i + 2}").setText(saleList[i].kurbanNo.toString());
    sheet.getRangeByName("B${i + 2}").setText(saleList[i].customer.phone);
    sheet.getRangeByName("C${i + 2}").setText(saleList[i].customer.name);
    sheet.getRangeByName("D${i + 2}").setText(saleList[i].kotraNo.toString());
    sheet.getRangeByName("E${i + 2}").setText(saleList[i].kg.toString());
    sheet.getRangeByName("F${i + 2}").setText(saleList[i].kgAmount.toString());
    sheet
        .getRangeByName("G${i + 2}")
        .setText(saleList[i].generalAmount.toString());
    sheet.getRangeByName("H${i + 2}").setText(saleList[i].kaparo.toString());
    sheet
        .getRangeByName("I${i + 2}")
        .setText(saleList[i].remainingAmount.toString());
    sheet.getRangeByName("J${i + 2}").setText(saleList[i].aciklama.toString());
  }
  sheet.autoFitColumn(1);
  sheet.autoFitColumn(2);
  sheet.autoFitColumn(3);
  sheet.autoFitColumn(4);
  sheet.autoFitColumn(5);
  sheet.autoFitColumn(6);
  sheet.autoFitColumn(7);
  sheet.autoFitColumn(8);
  sheet.autoFitColumn(9);
  sheet.autoFitColumn(10);
}

_createSheet6(xls.Worksheet sheet, List<SaleModel> saleList) {
  sheet.getRangeByName("A1").setText("Kurban No");
  sheet.getRangeByName("B1").setText("Müşteri Tel");
  sheet.getRangeByName("C1").setText("Müşteri Adı");
  sheet.getRangeByName("D1").setText("Kotra No");
  sheet.getRangeByName("E1").setText("Adet");
  sheet.getRangeByName("F1").setText("Birim Fiyatı");
  sheet.getRangeByName("G1").setText("Genel Toplam");
  sheet.getRangeByName("H1").setText("Alınan Kaparo");
  sheet.getRangeByName("I1").setText("Kalan Tutar");
  sheet.getRangeByName("J1").setText("Açıklama");
  for (int i = 0; i < saleList.length; i++) {
    sheet.getRangeByName("A${i + 2}").setText(saleList[i].kurbanNo.toString());
    sheet.getRangeByName("B${i + 2}").setText(saleList[i].customer.phone);
    sheet.getRangeByName("C${i + 2}").setText(saleList[i].customer.name);
    sheet.getRangeByName("D${i + 2}").setText(saleList[i].kotraNo.toString());
    sheet.getRangeByName("E${i + 2}").setText(saleList[i].adet.toString());
    sheet.getRangeByName("F${i + 2}").setText(saleList[i].amount.toString());
    sheet
        .getRangeByName("G${i + 2}")
        .setText(saleList[i].generalAmount.toString());
    sheet.getRangeByName("H${i + 2}").setText(saleList[i].kaparo.toString());
    sheet
        .getRangeByName("I${i + 2}")
        .setText(saleList[i].remainingAmount.toString());
    sheet.getRangeByName("J${i + 2}").setText(saleList[i].aciklama.toString());
  }
  sheet.autoFitColumn(1);
  sheet.autoFitColumn(2);
  sheet.autoFitColumn(3);
  sheet.autoFitColumn(4);
  sheet.autoFitColumn(5);
  sheet.autoFitColumn(6);
  sheet.autoFitColumn(7);
  sheet.autoFitColumn(8);
  sheet.autoFitColumn(9);
  sheet.autoFitColumn(10);
}

_createSheet7(xls.Worksheet sheet, List<MaliyetModel> maliyetList) {
  sheet.getRangeByName("A2").setText("Toplam Dana/Düve Sayısı");
  sheet.getRangeByName("A3").setText("Toplam Dana/Düve KG");
  sheet.getRangeByName("A4").setText("Dana/Düve KG Fiyatı");
  sheet.getRangeByName("A5").setText("TOPLAM DANA/DÜVE MALİYETİ");
  sheet.getRangeByName("A7").setText("Toplam Kuzu Sayısı");
  sheet.getRangeByName("A8").setText("Toplam Kuzu KG");
  sheet.getRangeByName("A9").setText("Kuzu KG Fiyatı");
  sheet.getRangeByName("A10").setText("TOPLAM KUZU MALİYETİ");
  sheet.getRangeByName("A12").setText("Toplam Yem Çuvalı Adedi");
  sheet.getRangeByName("A13").setText("Çuval Fiyatı");
  sheet.getRangeByName("A14").setText("TOPLAM YEM MALİYETİ");
  sheet.getRangeByName("A16").setText("Toplam Tuz Çuvalı Adedi");
  sheet.getRangeByName("A17").setText("Çuval Fiyatı");
  sheet.getRangeByName("A18").setText("TOPLAM TUZ MALİYETİ");
  sheet.getRangeByName("A20").setText("Toplam Saman Balyası Adedi");
  sheet.getRangeByName("A21").setText("Balya Fiyatı");
  sheet.getRangeByName("A22").setText("TOPLAM SAMAN MALİYETİ");
  sheet.getRangeByName("A24").setText("Toplam Yonca Balyası Adedi");
  sheet.getRangeByName("A25").setText("Balya Fiyatı");
  sheet.getRangeByName("A26").setText("TOPLAM YONCA MALİYETİ");
  sheet.getRangeByName("A28").setText("Toplam Pancar Küspesi KG");
  sheet.getRangeByName("A29").setText("KG Fiyatı");
  sheet.getRangeByName("A30").setText("TOPLAM PANCAR KÜSPESİ MALİYETİ");
  sheet.getRangeByName("A32").setText("Toplam Arpa Küspesi KG");
  sheet.getRangeByName("A33").setText("KG Fiyatı");
  sheet.getRangeByName("A34").setText("TOPLAM ARPA KÜSPESİ MALİYETİ");
  sheet.getRangeByName("A36").setText("BAKICI MAAŞLARI TOPLAMI");
  sheet.getRangeByName("A37").setText("ELEKTRİK FATURASI TOPLAMI");
  sheet.getRangeByName("A38").setText("KASAPLARA ÖDENEN TOPLAM TUTAR");
  sheet.getRangeByName("A39").setText("ÇALIŞANLARA ÖDENEN TOPLAM TUTAR");
  sheet.getRangeByName("A40").setText("AMBALAJCIYA ÖDENEN TOPLAM TUTAR");
  sheet.getRangeByName("A41").setText("SUCUK, EKMEK, AYRAN, SU MALİYETİ");
  sheet.getRangeByName("A42").setText("YILLIK TRAKTÖR MAZOT ÜCRETİ");
  sheet.getRangeByName("A43").setText("YILLIK TRAKTÖR BAKIM ÜCRETİ");
  sheet.getRangeByName("A45").setText("EKSTRA MASRAFLAR");
  sheet.getRangeByName("A46").setText("EKSTRA AÇIKLAMA");


  var tempList = maliyetList.where((element) => element.maliyetTip == 1).toList();
  if(maliyetList.isNotEmpty){
  sheet.getRangeByName("B2").setText(tempList.first.toplamSayi.toString());
  sheet.getRangeByName("B3").setText(tempList.first.adetSayisi.toString());
  sheet.getRangeByName("B4").setText(tempList.first.adetTutari.toString());
  sheet.getRangeByName("B5").setText(tempList.first.toplamTutar.toString());
  }

  tempList = maliyetList.where((element) => element.maliyetTip == 2).toList();
  if(maliyetList.isNotEmpty){
  sheet.getRangeByName("B7").setText(tempList.first.toplamSayi.toString());
  sheet.getRangeByName("B8").setText(tempList.first.adetSayisi.toString());
  sheet.getRangeByName("B9").setText(tempList.first.adetTutari.toString());
  sheet.getRangeByName("B10").setText(tempList.first.toplamTutar.toString());
  }

  tempList = maliyetList.where((element) => element.maliyetTip == 3).toList();
  if(maliyetList.isNotEmpty){
  sheet.getRangeByName("B12").setText(tempList.first.adetSayisi.toString());
  sheet.getRangeByName("B13").setText(tempList.first.adetTutari.toString());
  sheet.getRangeByName("B14").setText(tempList.first.toplamTutar.toString());
  }
  tempList = maliyetList.where((element) => element.maliyetTip == 4).toList();
  if(maliyetList.isNotEmpty){
  sheet.getRangeByName("B16").setText(tempList.first.adetSayisi.toString());
  sheet.getRangeByName("B17").setText(tempList.first.adetTutari.toString());
  sheet.getRangeByName("B18").setText(tempList.first.toplamTutar.toString());
  }
  tempList = maliyetList.where((element) => element.maliyetTip == 5).toList();
  if(maliyetList.isNotEmpty){
  sheet.getRangeByName("B20").setText(tempList.first.adetSayisi.toString());
  sheet.getRangeByName("B21").setText(tempList.first.adetTutari.toString());
  sheet.getRangeByName("B22").setText(tempList.first.toplamTutar.toString());
  }
  tempList = maliyetList.where((element) => element.maliyetTip == 6).toList();
  if(maliyetList.isNotEmpty){
  sheet.getRangeByName("B24").setText(tempList.first.adetSayisi.toString());
  sheet.getRangeByName("B25").setText(tempList.first.adetTutari.toString());
  sheet.getRangeByName("B26").setText(tempList.first.toplamTutar.toString());
  }
  tempList = maliyetList.where((element) => element.maliyetTip == 7).toList();
  if(maliyetList.isNotEmpty){
  sheet.getRangeByName("B28").setText(tempList.first.adetSayisi.toString());
  sheet.getRangeByName("B29").setText(tempList.first.adetTutari.toString());
  sheet.getRangeByName("B30").setText(tempList.first.toplamTutar.toString());
  }
  tempList = maliyetList.where((element) => element.maliyetTip == 8).toList();
  if(maliyetList.isNotEmpty){
  sheet.getRangeByName("B32").setText(tempList.first.adetSayisi.toString());
  sheet.getRangeByName("B33").setText(tempList.first.adetTutari.toString());
  sheet.getRangeByName("B34").setText(tempList.first.toplamTutar.toString());
  }
  tempList = maliyetList.where((element) => element.maliyetTip == 9).toList();
  if(maliyetList.isNotEmpty){
  sheet.getRangeByName("B36").setText(tempList.first.toplamTutar.toString());
  }
  tempList = maliyetList.where((element) => element.maliyetTip == 10).toList();
  if(maliyetList.isNotEmpty){
  sheet.getRangeByName("B37").setText(tempList.first.toplamTutar.toString());
  }
  tempList = maliyetList.where((element) => element.maliyetTip == 11).toList();
  if(maliyetList.isNotEmpty){
  sheet.getRangeByName("B38").setText(tempList.first.toplamTutar.toString());
  }
  tempList = maliyetList.where((element) => element.maliyetTip == 12).toList();
  if(maliyetList.isNotEmpty){
  sheet.getRangeByName("B39").setText(tempList.first.toplamTutar.toString());
  }
  tempList = maliyetList.where((element) => element.maliyetTip == 13).toList();
  if(maliyetList.isNotEmpty){
  sheet.getRangeByName("B40").setText(tempList.first.toplamTutar.toString());
  }
  tempList = maliyetList.where((element) => element.maliyetTip == 14).toList();
  if(maliyetList.isNotEmpty){
  sheet.getRangeByName("B41").setText(tempList.first.toplamTutar.toString());
  }
  tempList = maliyetList.where((element) => element.maliyetTip == 15).toList();
  if(maliyetList.isNotEmpty){
  sheet.getRangeByName("B42").setText(tempList.first.toplamTutar.toString());
  }
  tempList = maliyetList.where((element) => element.maliyetTip == 16).toList();
  if(maliyetList.isNotEmpty){
  sheet.getRangeByName("B43").setText(tempList.first.toplamTutar.toString());
  }
  tempList = maliyetList.where((element) => element.maliyetTip == 17).toList();
  if(maliyetList.isNotEmpty){
  sheet.getRangeByName("B45").setText(tempList.first.toplamTutar.toString());
  sheet.getRangeByName("B46").setText(tempList.first.aciklama.toString());
  }

  sheet.autoFitColumn(1);
  sheet.autoFitColumn(2);



}