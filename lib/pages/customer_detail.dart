import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/customer.dart';
import 'package:gazi_app/model/sale.dart';
import 'package:gazi_app/pages/sales_detail.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerDetail extends StatefulWidget {
  CustomerDetail({Key? key, required this.customer}) : super(key: key);
  final CustomerModel customer;

  @override
  _CustomerDetailState createState() => _CustomerDetailState();
}

var _repositoryInstance = DataRepository.instance;

class _CustomerDetailState extends State<CustomerDetail> {
  double width = 0;
  Widget getRowInfo(String item, String value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item),
              Container(
                  width: width / 2,
                  child: Text(
                    value,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.end,
                  ))
            ],
          ),
        ),
        Divider(height: 2.0),
      ],
    );
  }

  Widget getRowInfoForPhone() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Müşteri Telefonu"),
              TextButton(
                child: Text(
                  widget.customer.phone,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.end,
                ),
                onPressed: () {
                  _makePhoneCall("0" + widget.customer.phone);
                },
              )
            ],
          ),
        ),
        Divider(height: 2.0),
      ],
    );
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
  Widget _getSales() {
    return Column(
      children: [
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Yapılan Satışlar"),
              Container(
                alignment: AlignmentDirectional.centerStart,
                width: width / 2,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _repositoryInstance
                        .getAllItems(CollectionKeys.sales),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var saleValues = snapshot.data!.docs.where((element) => element.data()[FieldKeys.saleCustomerRef].toString() == widget.customer.id).toList();
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: saleValues.length,
                          itemBuilder: (context, index) {
                            var sale = SaleModel.fromJson(
                                saleValues[index].data(),
                                id: saleValues[index].id);
                            return TextButton(
                              style: ButtonStyle(
                                  alignment: Alignment.centerRight),
                              child: Text(
                                "Tip :" + getKurbanSubTypeName(sale.kurbanSubTip) + " \nKurban No :" + sale.kurbanNo.toString() + " " ,
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.start,
                              ),
                              onPressed: () {
                                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                // BubbleScreen()
                                SaleDetails(
                                  sale: sale,
                                )));
                              },
                            );
                          },
                        );
                      } else {
                        return Center();
                      }
                    }),
              ),
              
            ],
          )),
        Divider(height: 2.0),
    ]);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    String formattedDate =
    widget.customer.createTime == null ? "" :
        DateFormat('dd-MM-yyyy kk:mm').format(widget.customer.createTime!);
    return Scaffold(
        appBar: AppBar(
          title: Text("Müşteri Detayı"),
        ),
        body:SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20.0), child: Column(children: [

                getRowInfo("Müşteri Adı", widget.customer.name.toString()),
                getRowInfoForPhone(),
                getRowInfo("Açıklama", widget.customer.aciklama.toString()),
                getRowInfo("Kayıt Tarihi", formattedDate),
                getRowInfo("Kaydı Yapan", widget.customer.createUser!),
                _getSales()

            ])))
    );
  }
}
