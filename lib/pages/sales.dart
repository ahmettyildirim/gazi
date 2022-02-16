import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/customer.dart';
import 'package:gazi_app/model/sale.dart';
import 'package:gazi_app/pages/add_sale.dart';
import 'package:gazi_app/pages/sales_detail.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_mailer/flutter_mailer.dart';

class SalesList extends StatefulWidget {
  late bool selectable;
  late Function(CustomerModel)? onCustomerSelected;
  SalesList({
    Key? key,
    this.onCustomerSelected,
  }) : super();
  _SalesListState createState() => _SalesListState();
}

var _repositoryInstance = DataRepository.instance;
Future<void> getCustomersNew() async {}

String getImagePath(int index) {
  if (index == 1) {
    return "images/dana.jpg";
  } else {
    return "images/sheep.JPG";
  }
}

class _SalesListState extends State<SalesList> {
  final _nameController = TextEditingController();
  String _searchText = "";
  FilterModel filterModel = new FilterModel();
  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      if (_nameController.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _nameController.text;
        });
      }
    });
  }

  Future<FilterModel> showFilterDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Filtreleme'),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile(
                      dense: true,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      title: Text("Büyükbaş"),
                      value: filterModel.buyukbasKurbanSelect,
                      onChanged: (val) {
                        setState(() {
                          filterModel.buyukbasKurbanSelect = val!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      title: Text("Küçükbaş"),
                      value: filterModel.kucukbasKurbanSelect,
                      onChanged: (val) {
                        setState(() {
                          filterModel.kucukbasKurbanSelect = val!;
                        });
                      },
                    ),
                    Divider(
                      height: 5.0,
                    ),
                    CheckboxListTile(
                      dense: true,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      title: Text("Büyükbaş Ayaktan(Kilo)"),
                      value: filterModel.buyukAyaktanKilo,
                      onChanged: (val) {
                        setState(() {
                          filterModel.buyukAyaktanKilo = val!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      title: Text("Büyükbaş Karkas"),
                      value: filterModel.buyukKarkas,
                      onChanged: (val) {
                        setState(() {
                          filterModel.buyukKarkas = val!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      title: Text("Büyükbaş Ayaktan"),
                      value: filterModel.buyukAyaktan,
                      onChanged: (val) {
                        setState(() {
                          filterModel.buyukAyaktan = val!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      title: Text("Büyükbaş Hisse"),
                      value: filterModel.buyukHisse,
                      onChanged: (val) {
                        setState(() {
                          filterModel.buyukHisse = val!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      title: Text("Küçükbaş Ayaktan(Kilo)"),
                      value: filterModel.kucukAyaktanKilo,
                      onChanged: (val) {
                        setState(() {
                          filterModel.kucukAyaktanKilo = val!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      title: Text("Küçükbaş Ayaktan"),
                      value: filterModel.kucukAyaktan,
                      onChanged: (val) {
                        setState(() {
                          filterModel.kucukAyaktan = val!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    child: Text("Filtreleri Temizle"),
                    onPressed: () {
                      setState(() {
                        filterModel.clear();
                      });
                      // your code
                    }),
                ElevatedButton(
                    child: Text("Onayla"),
                    onPressed: () {
                      Navigator.of(context).pop(filterModel);
                    })
              ],
            );
          });
        });
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> getFilteredResults(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> saleList,
      String filter,
      String filterValue) {
    return saleList
        .where((element) => (element.data()[filter].toString() == filterValue))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //
          Padding(
            padding:
                EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0, bottom: 0),
            child: TextField(
              keyboardType:
                  TextInputType.numberWithOptions(decimal: true, signed: true),
              controller: _nameController,
              decoration:
                  InputDecoration(labelText: "Kurban numarası ile ara "),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                  onPressed: () async {
                    var val = await showFilterDialog(context);
                    setState(() {
                      filterModel = val;
                    });
                  },
                  icon: Icon(Icons.filter_alt),
                  label: Text("Filtrele")),
              TextButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddSale()));
                  },
                  icon: Icon(Icons.add),
                  label: Text("Yeni Satış")),
              TextButton.icon(
                  onPressed: _createExcel,
                  icon: Icon(Icons.sort),
                  label: Text("Sırala")),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _repositoryInstance.getAllItems(CollectionKeys.sales,
                  orderBy: FieldKeys.saleKurbanNo),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var saleValues = snapshot.data!.docs.toList();
                  if (_searchText.isNotEmpty) {
                    saleValues = getFilteredResults(
                        saleValues, FieldKeys.saleKurbanNo, _searchText);
                  } else {
                    if (filterModel.buyukbasKurbanSelect &&
                        !filterModel.kucukbasKurbanSelect) {
                      saleValues = getFilteredResults(
                          saleValues, FieldKeys.saleKurbanTip, "1");
                    } else if (!filterModel.buyukbasKurbanSelect &&
                        filterModel.kucukbasKurbanSelect) {
                      saleValues = getFilteredResults(
                          saleValues, FieldKeys.saleKurbanTip, "2");
                    }
                    if (filterModel.buyukAyaktan ||
                        filterModel.buyukAyaktanKilo ||
                        filterModel.buyukHisse ||
                        filterModel.buyukKarkas ||
                        filterModel.kucukAyaktan ||
                        filterModel.kucukAyaktanKilo) {
                      List<String> filteredList = [];
                      if (filterModel.buyukAyaktanKilo) {
                        filteredList.add("1");
                      }
                      if (filterModel.buyukKarkas) {
                        filteredList.add("2");
                      }
                      if (filterModel.buyukAyaktan) {
                        filteredList.add("3");
                      }
                      if (filterModel.buyukHisse) {
                        filteredList.add("4");
                      }
                      if (filterModel.kucukAyaktanKilo) {
                        filteredList.add("5");
                      }
                      if (filterModel.kucukAyaktan) {
                        filteredList.add("6");
                      }
                      var firstList = getFilteredResults(saleValues,
                          FieldKeys.saleKurbanSubTip, filteredList[0]);
                      var finalList = firstList;
                      for (int i = 1; i < filteredList.length; i++) {
                        firstList = getFilteredResults(saleValues,
                            FieldKeys.saleKurbanSubTip, filteredList[i]);
                        finalList += firstList;
                      }
                      finalList.sort((a, b) => a[FieldKeys.saleKurbanNo]
                          .compareTo(b[FieldKeys.saleKurbanNo]));
                      saleValues = finalList;
                    }
                  }

                  //.snapshot.value;
                  return ListView.builder(
                    itemCount: saleValues.length,
                    itemBuilder: (context, index) {
                      var sale = SaleModel.fromJson(saleValues[index].data(),
                          id: saleValues[index].id);
                      return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    // BubbleScreen()
                                    SaleDetails(
                                      sale: sale,
                                    ))),
                        child: Card(
                            child: ListTile(
                          title: Text(getKurbanTypeName(sale.kurbanTip) +
                              "-" +
                              getKurbanSubTypeName(sale.kurbanSubTip)),
                          subtitle: Text(
                              "Toplam tutar :${sale.kurbanSubTip == 3 ? sale.amount : sale.generalAmount} \nÖdenen tutar : ${sale.kaparo}"),
                          leading: CircleAvatar(
                            backgroundImage:
                                AssetImage(getImagePath(sale.kurbanTip)),
                          ),
                          dense: false,
                          trailing: Text(
                            sale.kurbanNo.toString(),
                            style: TextStyle(fontSize: 22),
                          ),
                        )),
                      );
                    },
                  );
                } else {
                  return Center();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> _createExcel() async {
    // final xls.Workbook workbook = xls.Workbook();
    // final xls.Worksheet sheet = workbook.worksheets[0];
    // sheet.getRangeByName('A1').setText('Hello World!');
    // final List<int> bytes = workbook.saveAsStream();
    // workbook.dispose();

    var bytes = await _createExcel2();
    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/Output.xlsx';
    print("******************************************");
    print(bytes);
    print(fileName);
    print("******************************************");
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    await sendMail(file);
    // OpenFile.open(fileName);
    // file.open();
  }

  Future<void> sendMail(File file) async {
    final MailOptions mailOptions = MailOptions(
        body: 'Raporları ekte bulabilirsiniz',
        subject: 'Satış Raporlaro',
        recipients: ['ahmetyildirim3@gmail.com'],
        attachments: [file.path],
        isHTML: true);

    final MailerResponse response = await FlutterMailer.send(mailOptions);
    // String platformResponse = "";
    // switch (response) {
    //   case MailerResponse.saved:

    //     /// ios only
    //     platformResponse = 'mail was saved to draft';
    //     break;
    //   case MailerResponse.sent:

    //     /// ios only
    //     platformResponse = 'mail was sent';
    //     break;
    //   case MailerResponse.cancelled:

    //     /// ios only
    //     platformResponse = 'mail was cancelled';
    //     break;
    //   case MailerResponse.android:
    //     platformResponse = 'intent was successful';
    //     break;
    //   default:
    //     platformResponse = 'unknown';
    //     break;
    // }
    // const GMAIL_SCHEMA = 'com.google.android.gm';

    // final bool gmailinstalled =
    //     await FlutterMailer.isAppInstalled(GMAIL_SCHEMA);

    // if (gmailinstalled) {
    //   final MailOptions mailOptions = MailOptions(
    //     body: 'a long body for the email <br> with a subset of HTML',
    //     subject: 'Detay',
    //     recipients: ['ahmetyildirim3@gmail.com'],
    //     isHTML: true,
    //     attachments: [file.path],
    //     appSchema: GMAIL_SCHEMA,
    //   );
    //   await FlutterMailer.send(mailOptions);
    //   final bool canSend = await FlutterMailer.canSendMail();

    //   // if (!canSend && Platform.isIOS) {
    //   //   final url = 'mailto:$recipient?body=$body&subject=$subject';
    //   //   if (await canLaunch(url)) {
    //   //     await launch(url);
    //   //   } else {
    //   //     throw 'Could not launch $url';
    //   //   }
    //   // }
    // }
  }

  Future<List<int>> _createExcel2() async {
//Create an Excel document.

    //Creating a workbook.
    final xls.Workbook workbook = xls.Workbook();
    //Accessing via index
    final xls.Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = false;

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();

    //Set data in the worksheet.
    sheet.getRangeByName('A1').columnWidth = 4.82;
    sheet.getRangeByName('B1:C1').columnWidth = 13.82;
    sheet.getRangeByName('D1').columnWidth = 13.20;
    sheet.getRangeByName('E1').columnWidth = 7.50;
    sheet.getRangeByName('F1').columnWidth = 9.73;
    sheet.getRangeByName('G1').columnWidth = 8.82;
    sheet.getRangeByName('H1').columnWidth = 4.46;

    sheet.getRangeByName('A1:H1').cellStyle.backColor = '#333F4F';
    sheet.getRangeByName('A1:H1').merge();
    sheet.getRangeByName('B4:D6').merge();

    sheet.getRangeByName('B4').setText('Invoice');
    sheet.getRangeByName('B4').cellStyle.fontSize = 32;

    sheet.getRangeByName('B8').setText('BILL TO:');
    sheet.getRangeByName('B8').cellStyle.fontSize = 9;
    sheet.getRangeByName('B8').cellStyle.bold = true;

    sheet.getRangeByName('B9').setText('Abraham Swearegin');
    sheet.getRangeByName('B9').cellStyle.fontSize = 12;

    sheet
        .getRangeByName('B10')
        .setText('United States, California, San Mateo,');
    sheet.getRangeByName('B10').cellStyle.fontSize = 9;

    sheet.getRangeByName('B11').setText('9920 BridgePointe Parkway,');
    sheet.getRangeByName('B11').cellStyle.fontSize = 9;

    sheet.getRangeByName('B12').setNumber(9365550136);
    sheet.getRangeByName('B12').cellStyle.fontSize = 9;
    sheet.getRangeByName('B12').cellStyle.hAlign = xls.HAlignType.left;

    final xls.Range range1 = sheet.getRangeByName('F8:G8');
    final xls.Range range2 = sheet.getRangeByName('F9:G9');
    final xls.Range range3 = sheet.getRangeByName('F10:G10');
    final xls.Range range4 = sheet.getRangeByName('F11:G11');
    final xls.Range range5 = sheet.getRangeByName('F12:G12');

    range1.merge();
    range2.merge();
    range3.merge();
    range4.merge();
    range5.merge();

    sheet.getRangeByName('F8').setText('INVOICE#');
    range1.cellStyle.fontSize = 8;
    range1.cellStyle.bold = true;
    range1.cellStyle.hAlign = xls.HAlignType.right;

    sheet.getRangeByName('F9').setNumber(2058557939);
    range2.cellStyle.fontSize = 9;
    range2.cellStyle.hAlign = xls.HAlignType.right;

    sheet.getRangeByName('F10').setText('DATE');
    range3.cellStyle.fontSize = 8;
    range3.cellStyle.bold = true;
    range3.cellStyle.hAlign = xls.HAlignType.right;

    sheet.getRangeByName('F11').dateTime = DateTime(2020, 08, 31);
    sheet.getRangeByName('F11').numberFormat =
        '[\$-x-sysdate]dddd, mmmm dd, yyyy';
    range4.cellStyle.fontSize = 9;
    range4.cellStyle.hAlign = xls.HAlignType.right;

    range5.cellStyle.fontSize = 8;
    range5.cellStyle.bold = true;
    range5.cellStyle.hAlign = xls.HAlignType.right;

    final xls.Range range6 = sheet.getRangeByName('B15:G15');
    range6.cellStyle.fontSize = 10;
    range6.cellStyle.bold = true;

    sheet.getRangeByIndex(15, 2).setText('Code');
    sheet.getRangeByIndex(16, 2).setText('CA-1098');
    sheet.getRangeByIndex(17, 2).setText('LJ-0192');
    sheet.getRangeByIndex(18, 2).setText('So-B909-M');
    sheet.getRangeByIndex(19, 2).setText('FK-5136');
    sheet.getRangeByIndex(20, 2).setText('HL-U509');

    sheet.getRangeByIndex(15, 3).setText('Description');
    sheet.getRangeByIndex(16, 3).setText('AWC Logo Cap');
    sheet.getRangeByIndex(17, 3).setText('Long-Sleeve Logo Jersey, M');
    sheet.getRangeByIndex(18, 3).setText('Mountain Bike Socks, M');
    sheet.getRangeByIndex(19, 3).setText('ML Fork');
    sheet.getRangeByIndex(20, 3).setText('Sports-100 Helmet, Black');

    sheet.getRangeByIndex(15, 3, 15, 4).merge();
    sheet.getRangeByIndex(16, 3, 16, 4).merge();
    sheet.getRangeByIndex(17, 3, 17, 4).merge();
    sheet.getRangeByIndex(18, 3, 18, 4).merge();
    sheet.getRangeByIndex(19, 3, 19, 4).merge();
    sheet.getRangeByIndex(20, 3, 20, 4).merge();

    sheet.getRangeByIndex(15, 5).setText('Quantity');
    sheet.getRangeByIndex(16, 5).setNumber(2);
    sheet.getRangeByIndex(17, 5).setNumber(3);
    sheet.getRangeByIndex(18, 5).setNumber(2);
    sheet.getRangeByIndex(19, 5).setNumber(6);
    sheet.getRangeByIndex(20, 5).setNumber(1);

    sheet.getRangeByIndex(15, 6).setText('Price');
    sheet.getRangeByIndex(16, 6).setNumber(8.99);
    sheet.getRangeByIndex(17, 6).setNumber(49.99);
    sheet.getRangeByIndex(18, 6).setNumber(9.50);
    sheet.getRangeByIndex(19, 6).setNumber(175.49);
    sheet.getRangeByIndex(20, 6).setNumber(34.99);

    sheet.getRangeByIndex(15, 7).setText('Total');
    sheet.getRangeByIndex(16, 7).setFormula('=E16*F16+(E16*F16)');
    sheet.getRangeByIndex(17, 7).setFormula('=E17*F17+(E17*F17)');
    sheet.getRangeByIndex(18, 7).setFormula('=E18*F18+(E18*F18)');
    sheet.getRangeByIndex(19, 7).setFormula('=E19*F19+(E19*F19)');
    sheet.getRangeByIndex(20, 7).setFormula('=E20*F20+(E20*F20)');
    sheet.getRangeByIndex(15, 6, 20, 7).numberFormat = '\$#,##0.00';

    sheet.getRangeByName('E15:G15').cellStyle.hAlign = xls.HAlignType.right;
    sheet.getRangeByName('B15:G15').cellStyle.fontSize = 10;
    sheet.getRangeByName('B15:G15').cellStyle.bold = true;
    sheet.getRangeByName('B16:G20').cellStyle.fontSize = 9;

    sheet.getRangeByName('E22:G22').merge();
    sheet.getRangeByName('E22:G22').cellStyle.hAlign = xls.HAlignType.right;
    sheet.getRangeByName('E23:G24').merge();

    final xls.Range range7 = sheet.getRangeByName('E22');
    final xls.Range range8 = sheet.getRangeByName('E23');
    range7.setText('TOTAL');
    range7.cellStyle.fontSize = 8;
    range8.setFormula('=SUM(G16:G20)');
    range8.numberFormat = '\$#,##0.00';
    range8.cellStyle.fontSize = 24;
    range8.cellStyle.hAlign = xls.HAlignType.right;
    range8.cellStyle.bold = true;

    sheet.getRangeByIndex(26, 1).text =
        '800 Interchange Blvd, Suite 2501, Austin, TX 78721 | support@adventure-works.com';
    sheet.getRangeByIndex(26, 1).cellStyle.fontSize = 8;

    final xls.Range range9 = sheet.getRangeByName('A26:H27');
    range9.cellStyle.backColor = '#ACB9CA';
    range9.merge();
    range9.cellStyle.hAlign = xls.HAlignType.center;
    range9.cellStyle.vAlign = xls.VAlignType.center;

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();
    return bytes;
    // //Save and launch file.
    // xls.SaveFilehelper.saveAndOpenFile(bytes);
  }
}

class FilterModel {
  bool buyukbasKurbanSelect = false;
  bool kucukbasKurbanSelect = false;
  bool buyukAyaktanKilo = false;
  bool buyukKarkas = false;
  bool buyukAyaktan = false;
  bool buyukHisse = false;
  bool kucukAyaktanKilo = false;
  bool kucukAyaktan = false;
  FilterModel();

  void clear() {
    this.buyukbasKurbanSelect = false;
    this.kucukbasKurbanSelect = false;
    this.buyukAyaktanKilo = false;
    this.buyukKarkas = false;
    this.buyukAyaktan = false;
    this.buyukHisse = false;
    this.kucukAyaktanKilo = false;
    this.kucukAyaktan = false;
  }
}
