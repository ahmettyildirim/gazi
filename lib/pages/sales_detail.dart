import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/custom_animation.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/common/helper.dart';
import 'package:gazi_app/model/payment.dart';
import 'package:gazi_app/model/sale.dart';
import 'package:gazi_app/pages/add_sale.dart';
import 'package:url_launcher/url_launcher.dart';

class SaleDetails extends StatefulWidget {
  SaleDetails({Key? key, required this.sale}) : super(key: key);
  SaleModel sale;
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
                    width: width / 2,
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton.icon(
                        onPressed: () async {
                          var val = await showPaymentDialog(context);
                          if (val != null) {
                            setState(() {
                              widget.sale.kaparo = val + widget.sale.kaparo;
                              widget.sale.remainingAmount =
                                  widget.sale.remainingAmount - val;
                              widget.sale.remainingAmount =
                                  widget.sale.remainingAmount < 0
                                      ? widget.sale.remainingAmount = 0
                                      : widget.sale.remainingAmount;
                            });
                          }
                        },
                        icon: Icon(Icons.payment),
                        label: Text("Yeni Ödeme Ekle")),
                  ),
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
                                    paymentValues[index].data(),
                                    id: paymentValues[index].id);
                                return TextButton(
                                  style: ButtonStyle(
                                      alignment: Alignment.centerRight),
                                  child: Text(
                                    getMoneyString(payment.amount),
                                    overflow: TextOverflow.visible,
                                    textAlign: TextAlign.end,
                                  ),
                                  onPressed: () async {
                                    var result = await showPaymentDetail(
                                        context, payment);
                                    if (result) {
                                      setState(() {
                                        widget.sale.kaparo =
                                            widget.sale.kaparo - payment.amount;
                                        widget.sale.remainingAmount =
                                            widget.sale.remainingAmount +
                                                payment.amount;
                                        widget.sale.remainingAmount =
                                            widget.sale.remainingAmount < 0
                                                ? widget.sale.remainingAmount =
                                                    0
                                                : widget.sale.remainingAmount;
                                      });
                                    }
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
              )
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

  Future<void> checkKesimSaati(BuildContext context) async {
    String _kesimSaati = await _repositoryInstance.getKesimSaati(
        widget.sale.kurbanTip, widget.sale.kurbanNo);
    if (widget.sale.kesimSaati.toString() != _kesimSaati) {
      bool response = await askPrompt(context,
          message:
              "Kesim saati güncellendi. Yeni saati ($_kesimSaati) kaydetmek ve müşteriye günceleme mesajı göndermek ister misiniz?",
          title: "Kesim Saati Güncelleme");
      if (response) {
        String whatsAppText =
            "**GAZİ ET MANGAL ÇİFTLİĞİ**\nKurban kesim saatini ${_kesimSaati.replaceAll(":", "-")} olarak güncellemiştir. Bilgilerinize sunarız.";
        widget.sale.kesimSaati = _kesimSaati;
        _repositoryInstance.updateItem(widget.sale);
        launchWhatsApp(num: widget.sale.customer.phone, text: whatsAppText);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    String formattedDate = getFormattedDate(widget.sale.createTime);
    Future.delayed(Duration.zero, () => checkKesimSaati(context));
    return Scaffold(
        appBar: AppBar(
          title: Text("Satış Detayı"),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    SaleModel result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                // BubbleScreen()
                                AddSale(
                                  sale: widget.sale,
                                )));
                    setState(() {
                      widget.sale = result;
                    });
                  },
                  child: Icon(
                    Icons.edit,
                    size: 20.0,
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    var success = await askPrompt(context,
                        message:
                            "Bu satış işlemini sistemden silmek üzeresiniz. Emin misiniz?",
                        title: "!!!Dikkat!!!");
                    if (success) {
                      _repositoryInstance.deleteSale(widget.sale);
                      Navigator.pop(context, widget.sale);
                    }
                  },
                  child: Icon(
                    Icons.delete,
                    size: 20.0,
                  ),
                )),
          ],
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
                getRowInfo("Kotra No", widget.sale.kotraNo.toString()),
                [5, 6].contains(widget.sale.kurbanSubTip)
                    ? getRowInfo("Adet", widget.sale.adet.toString())
                    : Center(),
                [0, 3, 4, 6].contains(widget.sale.kurbanSubTip)
                    ? Center()
                    : getRowInfo("Kg", widget.sale.kg.toString() + " kg"),
                [0, 3, 4, 6].contains(widget.sale.kurbanSubTip)
                    ? Center()
                    : getRowInfo("Kg Birim Fiyatı",
                        widget.sale.kgAmount.toString() + " TL"),
                ![3, 4].contains(widget.sale.kurbanSubTip)
                    ? Center()
                    : getRowInfo(
                        "Birim Fiyatı", widget.sale.amount.toString() + " TL"),
                ![4].contains(widget.sale.kurbanSubTip)
                    ? Center()
                    : getRowInfo(
                        "Hisse Adedi", widget.sale.hisseNum.toString()),
                [0, 3].contains(widget.sale.kurbanSubTip)
                    ? Center()
                    : getRowInfo("Genel Toplam",
                        widget.sale.generalAmount.toString() + " TL"),
                getRowInfo(
                    "Toplam Ödenen", widget.sale.kaparo.toString() + " TL"),
                [0].contains(widget.sale.kurbanSubTip)
                    ? Center()
                    : getRowInfo("Kalan Tutar",
                        widget.sale.remainingAmount.toString() + " TL"),
                getRowInfo("Açıklama", widget.sale.aciklama!),
                _getPayments(),
                getRowInfo(
                    "Tahmini Kesim Saati", widget.sale.kesimSaati.toString()),
                getRowInfo("Vekaletli Satış Mı?",
                    widget.sale.isVekalet! ? "Evet" : "Hayır"),
                getRowInfo("Satış Tarihi", formattedDate),
                getRowInfo("Satışı Yapan", widget.sale.createUser!),
              ],
            ),
          ),
        ));
  }

  Future<int?> showPaymentDialog(BuildContext context) async {
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
                        CustomLoader.show();
                        int tutar = int.parse(_paymentController.text);
                        PaymentModel payment = new PaymentModel(
                            amount: tutar,
                            paymentType: "Nakit",
                            aciklama: _aciklamaController.text);
                        await _repositoryInstance.addNewPaymentWithReferenceId(
                            widget.sale.id, payment);
                        CustomLoader.close();

                        String whatsAppText =
                            "${getMoneyString(tutar)} tutarındaki ödeme işleminiz başarıyla gerçekleşmiştir.";
                        if (widget.sale.remainingAmount > tutar) {
                          whatsAppText +=
                              "\n Kalan ödeme tutarınız  ${getMoneyString(widget.sale.remainingAmount - tutar)}";
                        }
                        launchWhatsApp(
                            num: widget.sale.customer.phone,
                            text: whatsAppText);
                        Navigator.of(context).pop(tutar);
                      })
                ])
              ],
            );
          });
        });
  }

  Future<bool> showPaymentDetail(
      BuildContext context, PaymentModel paymentModel) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Ödeme Detayı',
                  style: TextStyle(fontSize: 15, color: Colors.blueGrey)),
              content: Container(
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tutar", style: TextStyle(fontSize: 12)),
                          Container(
                              child: Expanded(
                            child: Text(paymentModel.amount.toString() + " TL",
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.end,
                                style: TextStyle(fontSize: 12)),
                          ))
                        ],
                      ),
                    ),
                    Divider(height: 2.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("İşlemi Yapan", style: TextStyle(fontSize: 12)),
                          Container(
                              child: Text(paymentModel.createUser.toString(),
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: 11)))
                        ],
                      ),
                    ),
                    Divider(height: 2.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("İşlem Tarihi", style: TextStyle(fontSize: 12)),
                          Container(
                              child: Text(
                                  getFormattedDate(paymentModel.createTime),
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: 12)))
                        ],
                      ),
                    ),
                    Divider(height: 2.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Açıklama", style: TextStyle(fontSize: 12)),
                          Expanded(
                              child: Text(paymentModel.aciklama.toString(),
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: 12)))
                        ],
                      ),
                    ),
                    Divider(height: 2.0),
                  ],
                )),
              ),
              actions: [
                ButtonBar(alignment: MainAxisAlignment.spaceBetween, children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      child: Text(
                        "Ödemeyi Sil",
                        style: TextStyle(fontSize: 12),
                      ),
                      onPressed: () async {
                        var result = await askPrompt(context,
                            message:
                                "Ödemeyi silmek istediğinizden emin misiniz?",
                            title: "Ödeme Silme");

                        CustomLoader.show();
                        if (result) {
                          await _repositoryInstance.deletePayment(
                              widget.sale.id, paymentModel);
                        }
                        CustomLoader.close();
                        Navigator.of(context).pop(result);
                        // your code
                      }),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      child: Text("Kapat", style: TextStyle(fontSize: 12)),
                      onPressed: () async {
                        // int tutar = 0;
                        // PaymentModel payment = new PaymentModel(
                        //     amount: tutar,
                        //     paymentType: "Nakit",
                        //     aciklama: "_aciklamaController.text");
                        // await _repositoryInstance.addNewPaymentWithReferenceId(
                        //     widget.sale.id, payment);

                        Navigator.of(context).pop(false);
                      })
                ])
              ],
            );
          });
        });
  }
}
