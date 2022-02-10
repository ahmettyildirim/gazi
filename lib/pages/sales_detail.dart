import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/payment.dart';
import 'package:gazi_app/model/sale.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SaleDetails extends StatefulWidget {
  SaleDetails({Key? key, required this.sale}) : super(key: key);
  final SaleModel sale;
  @override
  State<SaleDetails> createState() => _SaleDetailsState();
}

var _repositoryInstance = DataRepository.instance;

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
                  widget.sale.customer.phone,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.end,
                ),
                onPressed: () {
                  _makePhoneCall("0" + widget.sale.customer.phone);
                },
              )
            ],
          ),
        ),
        Divider(height: 2.0),
      ],
    );
  }

  Widget _getPayments() {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Yapılan Ödemeler"),
              Column(
                children: [
                  Container(
                    alignment: AlignmentDirectional.centerEnd,
                    width: width / 2,
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: _repositoryInstance
                            .getSalePaymentList(widget.sale.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var paymentValues = snapshot.data!.docs.toList();
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: paymentValues.length,
                              itemBuilder: (context, index) {
                                var payment = PaymentModel.fromJson(
                                    paymentValues[index].data());
                                return TextButton(
                                  style: ButtonStyle(
                                      alignment: Alignment.centerRight),
                                  child: Text(
                                    payment.amount.toString() + " TL",
                                    overflow: TextOverflow.visible,
                                    textAlign: TextAlign.end,
                                  ),
                                  onPressed: () {
                                    setState(() {});
                                  },
                                );
                              },
                            );
                          } else {
                            return Center();
                          }
                        }),
                  ),
                  Container(
                    width: width / 2,
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton.icon(
                        onPressed: () async {
                          var val = await showPaymentDialog(context);
                          if (val != null) {
                            setState(() {
                              widget.sale.kaparo = val + widget.sale.kaparo;
                              if (widget.sale.kurbanSubTip != 2) {
                                widget.sale.remainingAmount =
                                    widget.sale.remainingAmount - val;
                              }
                            });
                          }
                        },
                        icon: Icon(Icons.payment),
                        label: Text("Yeni Ödeme Ekle")),
                  )
                ],
              ),
              Divider(height: 2.0),
            ],
          ))
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
                getRowInfoForPhone(),
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
                _getPayments(),
                getRowInfo("Satış Tarihi", formattedDate),
                getRowInfo("Satışı Yapan", widget.sale.createUser!),
              ],
            ),
          ),
        ));
  }

  Future<int?> showPaymentDialog(BuildContext context) async {
    print(width);
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _paymentController =
              TextEditingController();
          final TextEditingController _aciklamaController =
              TextEditingController();
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Yeni Ödeme Ekle'),
              content: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Divider(
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Kalan Tutar"),
                            Container(
                                child: Text(
                              widget.sale.remainingAmount.toString(),
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.end,
                            )),
                            TextButton.icon(
                                onPressed: () {
                                  _paymentController.text =
                                      widget.sale.remainingAmount.toString();
                                },
                                icon: Icon(Icons.arrow_downward),
                                label: Text(""))
                          ],
                        ),
                      ),
                      Divider(
                        height: 8.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _paymentController,
                          decoration:
                              InputDecoration(labelText: "Ödeme Tutarı"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          controller: _aciklamaController,
                          maxLines: null,
                          minLines: 2,
                          decoration: InputDecoration(
                              labelText: 'Açıklama (İsteğe bağlı)'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                ButtonBar(alignment: MainAxisAlignment.spaceBetween, children: [
                  ElevatedButton(
                      child: Text("İptal"),
                      onPressed: () {
                        setState(() {
                          Navigator.of(context).pop();
                        });
                        // your code
                      }),
                  ElevatedButton(
                      child: Text("Onayla"),
                      onPressed: () async {
                        int tutar = int.parse(_paymentController.text);
                        PaymentModel payment = new PaymentModel(
                            amount: tutar,
                            paymentType: "Nakit",
                            aciklama: _aciklamaController.text);
                        await _repositoryInstance.addNewPaymentWithReferenceId(
                            widget.sale.id, payment);

                        Navigator.of(context).pop(tutar);
                      })
                ])
              ],
            );
          });
        });
  }
}
