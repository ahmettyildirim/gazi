import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/custom_animation.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/common/helper.dart';
import 'package:gazi_app/model/hisse_kurban.dart';
import 'package:gazi_app/model/sale.dart';
import 'package:gazi_app/pages/add_kurban.dart';
import 'package:gazi_app/pages/sales_detail.dart';

class HisseDetail extends StatefulWidget {
  HisseDetail({Key? key, required this.hisse}) : super(key: key);
  HisseKurbanModel hisse;

  @override
  _HisseDetailState createState() => _HisseDetailState();
}

var _repositoryInstance = DataRepository.instance;

class _HisseDetailState extends State<HisseDetail> {
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

  Widget _getSales() {
    return Column(children: [
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
                    stream:
                        _repositoryInstance.getAllItems(CollectionKeys.sales),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var saleValues = snapshot.data!.docs
                            .where((element) =>
                                element
                                    .data()[FieldKeys.saleHisseRef]
                                    .toString() ==
                                widget.hisse.id)
                            .toList();
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: saleValues.length,
                          itemBuilder: (context, index) {
                            var sale = SaleModel.fromJson(
                                saleValues[index].data(),
                                id: saleValues[index].id);
                            return TextButton(
                              style:
                                  ButtonStyle(alignment: Alignment.centerRight),
                              child: Text(
                                sale.customer.name.toString(),
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

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    String formattedDate = getFormattedDate(widget.hisse.createTime);
    return Scaffold(
        appBar: AppBar(
          title: Text("Hisse Detayı"),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    HisseKurbanModel result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                // BubbleScreen()
                                AddKurban(
                                  hisseKurbanModel: widget.hisse,
                                )));
                    setState(() {
                      widget.hisse = result;
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
                    var list = await _repositoryInstance.getAllItemsByFilter(
                        CollectionKeys.sales,
                        filterName: FieldKeys.saleHisseRef,
                        filterValue: widget.hisse.id);
                    if (list.docs.isNotEmpty) {
                      CustomLoader.showError(
                          "Bu hisse üzerine yapılan satışlar var. Hisseyi silmek için  önce ${widget.hisse.hisseNo} numaralı tüm satışları silmelisiniz.");
                      return;
                    }
                    var success = await askPrompt(context,
                        message:
                            "Bu hisse tanımını sistemden silmek üzeresiniz. Emin misiniz?",
                        title: "!!!Dikkat!!!");
                    if (success) {
                      _repositoryInstance.deleteHisse(widget.hisse);
                      Navigator.pop(context, widget.hisse);
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
                child: Column(children: [
                  getRowInfo("Kurban No", widget.hisse.kurbanNo.toString()),
                  getRowInfo("Cins",
                      widget.hisse.buyukKurbanTip == 1 ? "Dana" : "Düve"),
                  getRowInfo("Hisse Sayısı", widget.hisse.hisseNo.toString()),
                  getRowInfo("Kalan Hisse Sayısı",
                      widget.hisse.remainingHisse.toString()),
                  getRowInfo("Hisse Tutarı",
                      widget.hisse.hisseAmount.toString() + "TL"),
                  getRowInfo("Vekalet Var mı?",
                      widget.hisse.isVekalet == true ? "Evet" : "Hayır"),
                  getRowInfo("Kotra No", widget.hisse.kotraNo.toString()),
                  getRowInfo("Açıklama", widget.hisse.aciklama!),
                  getRowInfo("Satış Tarihi", formattedDate),
                  getRowInfo("Satışı Yapan", widget.hisse.createUser!),
                  _getSales()
                ]))));
  }
}
