import 'package:flutter/material.dart';
import 'package:gazi_app/model/sale.dart';
import 'package:intl/intl.dart';

class SaleDetails extends StatefulWidget {
  SaleDetails({Key? key, required this.sale}) : super(key: key);
  final SaleModel sale;
  @override
  State<SaleDetails> createState() => _SaleDetailsState();
}

class _SaleDetailsState extends State<SaleDetails> {
  double width = 0;
  Widget getRowInfo(String item, String value) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    String formattedDate =
        DateFormat('dd-MM-yyyy – kk:mm').format(widget.sale.createTime!);
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
                Divider(height: 2.0),
                getRowInfo("Müşteri Adı", widget.sale.customer.name),
                Divider(height: 2.0),
                getRowInfo("Müşteri Telefonu", widget.sale.customer.phone),
                Divider(height: 2.0),
                getRowInfo("Tip", getKurbanTypeName(widget.sale.kurbanTip)),
                Divider(height: 2.0),
                getRowInfo(
                    "Alt Tip", getKurbanSubTypeName(widget.sale.kurbanSubTip)),
                Divider(height: 2.0),
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
                Divider(height: 2.0),
                [0, 2, 3, 4, 6].contains(widget.sale.kurbanSubTip)
                    ? Center()
                    : getRowInfo("Kg Birim Fiyatı",
                        widget.sale.kgAmount.toString() + " TL"),
                Divider(height: 2.0),
                ![3, 4, 6].contains(widget.sale.kurbanSubTip)
                    ? Center()
                    : getRowInfo(
                        "Birim Fiyatı", widget.sale.amount.toString() + " TL"),
                Divider(height: 2.0),
                [0, 2, 3].contains(widget.sale.kurbanSubTip)
                    ? Center()
                    : getRowInfo("Genel Toplam",
                        widget.sale.generalAmount.toString() + " TL"),
                Divider(height: 2.0),
                getRowInfo(
                    "Alınan Kaparo", widget.sale.kaparo.toString() + " TL"),
                Divider(height: 2.0),
                [0, 2].contains(widget.sale.kurbanSubTip)
                    ? Center()
                    : getRowInfo("Kalan Tutar",
                        widget.sale.remainingAmount.toString() + " TL"),
                Divider(height: 2.0),
                getRowInfo("Açıklama", widget.sale.aciklama!),
                Divider(height: 2.0),
                getRowInfo("Satış Tarihi", formattedDate),
                Divider(height: 2.0),
                getRowInfo("Satışı Yapan", widget.sale.createUser!),
                Divider(height: 2.0),
              ],
            ),
          ),
        ));
  }
}
