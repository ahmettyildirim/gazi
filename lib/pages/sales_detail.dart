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
    return Column(
      children: [
        Padding(
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
        ),
        Divider(height: 2.0),
      ],
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
                getRowInfo("Müşteri Adı", widget.sale.customer.name),
                getRowInfo("Müşteri Telefonu", widget.sale.customer.phone),
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
