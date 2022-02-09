import 'package:flutter/material.dart';
import 'package:gazi_app/model/sale.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SaleDetails extends StatefulWidget {
  SaleDetails({Key? key, required this.sale}) : super(key: key);
  final SaleModel sale;
  @override
  State<SaleDetails> createState() => _SaleDetailsState();
}

class _SaleDetailsState extends State<SaleDetails> {
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

  Widget getRowInfoForPhone(String value) {
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
                  value,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.end,
                ),
                onPressed: () {
                  _makePhoneCall("0" + value);
                },
              )
            ],
          ),
        ),
        Divider(height: 2.0),
      ],
    );
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
        DateFormat('dd-MM-yyyy kk:mm').format(widget.sale.createTime!);
    return Scaffold(
        appBar: AppBar(
          title: Text("Satış Detayı"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                getRowInfo("No", widget.sale.kurbanNo.toString()),
                getRowInfo("Müşteri Adı", widget.sale.customer.name),
                getRowInfoForPhone(widget.sale.customer.phone),
                getRowInfo("Tip", getKurbanTypeName(widget.sale.kurbanTip)),
                getRowInfo(
                    "Alt Tip", getKurbanSubTypeName(widget.sale.kurbanSubTip)),
                widget.sale.kurbanTip == 1
                    ? getRowInfo(
                        "Cins", getBuyukKurbanCins(widget.sale.buyukKurbanTip))
                    : Center(),
                widget.sale.kurbanTip == 1 ? Divider(height: 2.0) : Center(),
                widget.sale.kurbanSubTip == 6
                    ? getRowInfo("Adet", widget.sale.adet.toString())
                    : Center(),
                [0, 2, 3, 4, 6].contains(widget.sale.kurbanSubTip)
                    ? Center()
                    : getRowInfo("Kg", widget.sale.kg.toString() + " kg"),
                [0, 2, 3, 4, 6].contains(widget.sale.kurbanSubTip)
                    ? Center()
                    : getRowInfo("Kg Birim Fiyatı",
                        widget.sale.kgAmount.toString() + " TL"),
                ![3, 4, 6].contains(widget.sale.kurbanSubTip)
                    ? Center()
                    : getRowInfo(
                        "Birim Fiyatı", widget.sale.amount.toString() + " TL"),
                [0, 2, 3].contains(widget.sale.kurbanSubTip)
                    ? Center()
                    : getRowInfo("Genel Toplam",
                        widget.sale.generalAmount.toString() + " TL"),
                getRowInfo(
                    "Alınan Kaparo", widget.sale.kaparo.toString() + " TL"),
                [0, 2].contains(widget.sale.kurbanSubTip)
                    ? Center()
                    : getRowInfo("Kalan Tutar",
                        widget.sale.remainingAmount.toString() + " TL"),
                getRowInfo("Açıklama", widget.sale.aciklama!),
                getRowInfo("Satış Tarihi", formattedDate),
                getRowInfo("Satışı Yapan", widget.sale.createUser!),
              ],
            ),
          ),
        ));
  }
}
