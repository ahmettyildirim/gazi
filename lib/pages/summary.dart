import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/sale.dart';

class SummaryPage extends StatefulWidget {
  @override
  _SummaryPageState createState() => _SummaryPageState();
}

var _repositoryInstance = DataRepository.instance;
List<String> images = [
  "images/dana.png",
  "images/sheep.png",
  "images/sheep.png",
  "images/dana.png",
  "images/sheep.png",
  "images/dana.png",
  "images/sheep.png",
];
String getTitle(int index) {
  switch (index) {
    case 1:
      return "Ayaktan Kilo";
    case 2:
      return "Karkas";
    case 3:
      return "Ayaktan";
    case 4:
      return "Hisse";
    case 5:
      return "Ayaktan Kilo";
    case 6:
      return "Ayaktan";
    default:
      return "";
  }
}

String getImagePath(int index) {
  if (index < 5) {
    return "images/dana.png";
  } else {
    return "images/sheep.png";
  }
}

String getMainText(List<SaleModel> values, int index) {
  String totalSaleAmount = index != 6
      ? values.length.toString()
      : getKucukKurbanAdet(values).toString();
  String totalPaidAmount = values
      .toList()
      .fold(
          0,
          (previousValue, element) =>
              int.parse(previousValue.toString()) + element.kaparo)
      .toString();
  String totalRemainingAmount = values
      .toList()
      .fold(
          0,
          (previousValue, element) =>
              int.parse(previousValue.toString()) + element.remainingAmount)
      .toString();
  return "Satış Adeti :" +
      totalSaleAmount +
      "\nÖdenen Tutar: " +
      totalPaidAmount +
      "\nKalan Tutar:" +
      totalRemainingAmount;
}

class _SummaryPageState extends State<SummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40, left: 20, right: 10, bottom: 10),
      child: Expanded(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _repositoryInstance.getAllItems(CollectionKeys.sales),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var saleValues = snapshot.data!.docs;
              var length = saleValues.length;
              List<SaleModel> salelist = List.empty(growable: true);
              for (int i = 0; i < length; i++) {
                salelist.add(SaleModel.fromJson(saleValues[i].data()));
              }

              return ListView.separated(
                  itemBuilder: (context, index) {
                    var currentList = salelist
                        .where((element) => element.kurbanSubTip == index + 1)
                        .toList();
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(getImagePath(index + 1)),
                      ),
                      title: Text(getTitle(index + 1)),
                      subtitle: Text(getMainText(currentList, index + 1)),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(height: 15);
                  },
                  itemCount: 6,
                  padding: EdgeInsets.all(5),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical);

              // Column(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     SizedBox(
              //       height: 20,
              //     ),
              //     myList(context),
              //     buildCard(
              //         salelist.where((element) => element.kurbanSubTip == 1)),
              //     buildCard(
              //         salelist.where((element) => element.kurbanSubTip == 1)),
              //     buildCard(
              //         salelist.where((element) => element.kurbanSubTip == 1)),
              //     buildCard(
              //         salelist.where((element) => element.kurbanSubTip == 1)),
              //     Text(
              //       "Büyükbaş",
              //       style: TextStyle(fontSize: 30),
              //     ),
              //     Text(
              //       "Ayaktan Kilo",
              //       style: TextStyle(fontSize: 20),
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text("Toplam Satış Adeti: "),
              //         Text(salelist
              //             .where((element) => element.kurbanSubTip == 1)
              //             .length
              //             .toString())
              //       ],
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text("Ödenen Kaparo : "),
              //         Text(salelist
              //             .where((element) => element.kurbanSubTip == 1)
              //             .toList()
              //             .fold(
              //                 0,
              //                 (previousValue, element) =>
              //                     int.parse(previousValue.toString()) +
              //                     element.kaparo)
              //             .toString())
              //       ],
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text("Kalan Para : "),
              //         Text(salelist
              //             .where((element) => element.kurbanSubTip == 1)
              //             .toList()
              //             .fold(
              //                 0,
              //                 (previousValue, element) =>
              //                     int.parse(previousValue.toString()) +
              //                     element.remainingAmount)
              //             .toString())
              //       ],
              //     ),
              //     Text(
              //       "Karkas",
              //       style: TextStyle(fontSize: 20),
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text("Toplam Satış Adeti: "),
              //         Text(salelist
              //             .where((element) => element.kurbanSubTip == 2)
              //             .length
              //             .toString())
              //       ],
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text("Ödenen Kaparo : "),
              //         Text(salelist
              //             .where((element) => element.kurbanSubTip == 2)
              //             .toList()
              //             .fold(
              //                 0,
              //                 (previousValue, element) =>
              //                     int.parse(previousValue.toString()) +
              //                     element.kaparo)
              //             .toString())
              //       ],
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text("Kalan Para : "),
              //         Text(salelist
              //             .where((element) => element.kurbanSubTip == 2)
              //             .toList()
              //             .fold(
              //                 0,
              //                 (previousValue, element) =>
              //                     int.parse(previousValue.toString()) +
              //                     element.remainingAmount)
              //             .toString())
              //       ],
              //     ),
              //     Text(
              //       "Ayaktan",
              //       style: TextStyle(fontSize: 20),
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text("Toplam Satış Adeti: "),
              //         Text(salelist
              //             .where((element) => element.kurbanSubTip == 3)
              //             .length
              //             .toString())
              //       ],
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text("Ödenen Kaparo : "),
              //         Text(salelist
              //             .where((element) => element.kurbanSubTip == 3)
              //             .toList()
              //             .fold(
              //                 0,
              //                 (previousValue, element) =>
              //                     int.parse(previousValue.toString()) +
              //                     element.kaparo)
              //             .toString())
              //       ],
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text("Kalan Para : "),
              //         Text(salelist
              //             .where((element) => element.kurbanSubTip == 3)
              //             .toList()
              //             .fold(
              //                 0,
              //                 (previousValue, element) =>
              //                     int.parse(previousValue.toString()) +
              //                     element.remainingAmount)
              //             .toString())
              //       ],
              //     ),
              //     Text(
              //       "Hisse",
              //       style: TextStyle(fontSize: 20),
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text("Toplam Satış Adeti: "),
              //         Text(salelist
              //             .where((element) => element.kurbanSubTip == 4)
              //             .toList()
              //             .fold(
              //                 0,
              //                 (previousValue, element) =>
              //                     int.parse(previousValue.toString()) +
              //                     element.hisseNum)
              //             .toString())
              //       ],
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text("Ödenen Kaparo : "),
              //         Text(salelist
              //             .where((element) => element.kurbanSubTip == 4)
              //             .toList()
              //             .fold(
              //                 0,
              //                 (previousValue, element) =>
              //                     int.parse(previousValue.toString()) +
              //                     element.kaparo)
              //             .toString())
              //       ],
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text("Kalan Para : "),
              //         Text(salelist
              //             .where((element) => element.kurbanSubTip == 4)
              //             .toList()
              //             .fold(
              //                 0,
              //                 (previousValue, element) =>
              //                     int.parse(previousValue.toString()) +
              //                     element.remainingAmount)
              //             .toString())
              //       ],
              //     ),
              //     Text(
              //       "Küçükbaş",
              //       style: TextStyle(fontSize: 30),
              //     ),
              //     Text(
              //       "Ayaktan Kilo",
              //       style: TextStyle(fontSize: 20),
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text("Toplam Satış Adeti: "),
              //         Text(salelist
              //             .where((element) => element.kurbanSubTip == 5)
              //             .length
              //             .toString())
              //       ],
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text("Ödenen Kaparo : "),
              //         Text(salelist
              //             .where((element) => element.kurbanSubTip == 5)
              //             .toList()
              //             .fold(
              //                 0,
              //                 (previousValue, element) =>
              //                     int.parse(previousValue.toString()) +
              //                     element.kaparo)
              //             .toString())
              //       ],
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text("Kalan Para : "),
              //         Text(salelist
              //             .where((element) => element.kurbanSubTip == 5)
              //             .toList()
              //             .fold(
              //                 0,
              //                 (previousValue, element) =>
              //                     int.parse(previousValue.toString()) +
              //                     element.remainingAmount)
              //             .toString())
              //       ],
              //     ),
              //     Text(
              //       "Ayaktan",
              //       style: TextStyle(fontSize: 20),
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text("Toplam Satış Adeti: "),
              //         Text(getKucukKurbanAdet(salelist).toString())
              //       ],
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text("Ödenen Kaparo : "),
              //         Text(salelist
              //             .where((element) => element.kurbanSubTip == 6)
              //             .toList()
              //             .fold(
              //                 0,
              //                 (previousValue, element) =>
              //                     int.parse(previousValue.toString()) +
              //                     element.kaparo)
              //             .toString())
              //       ],
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text("Kalan Para : "),
              //         Text(salelist
              //             .where((element) => element.kurbanSubTip == 6)
              //             .toList()
              //             .fold(
              //                 0,
              //                 (previousValue, element) =>
              //                     int.parse(previousValue.toString()) +
              //                     element.remainingAmount)
              //             .toString())
              //       ],
              //     ),
              //     Text(salelist
              //         .where((element) => element.buyukKurbanTip == 2)
              //         .length
              //         .toString())
              //   ],
              // );
            } else {
              return Center();
            }
          },
        ),
      ),
    );
  }
}

Widget myList(BuildContext context) {
  return ListView.separated(
    itemBuilder: (context, index) {
      return ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(images[index]),
        ),
        title: Text("Karkas"),
        subtitle: Text("Satış Adeti :50\nÖdenen Tutar: 100\nKalan Tutar:500"),
      );
    },
    separatorBuilder: (context, index) {
      return Divider(height: 20);
    },
    itemCount: images.length,
    padding: EdgeInsets.all(5),
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
  );
}

Widget buildCard(Iterable saleModel) {
  var heading = 'Büyükbaş';
  var subheading = "Ayaktan Kilo";
  var supportingText =
      '\n\nBeautiful home to rent,\n recently r\nefurbished \nwith modern appliances...';
  return Container(
    child: Card(
        elevation: 3.0,
        child: Container(
          child: Column(
            children: [
              ListTile(
                title: Text(heading),
                subtitle: Text(subheading),
              ),
              ButtonBar(
                children: [
                  TextButton(
                    child: const Text('CONTACT AGENT'),
                    onPressed: () {/* ... */},
                  ),
                  TextButton(
                    child: const Text('LEARN MORE'),
                    onPressed: () {/* ... */},
                  )
                ],
              )
            ],
          ),
        )),
  );
}

int getKucukKurbanAdet(List<SaleModel> list) {
  return list.where((element) => element.kurbanSubTip == 6).toList().fold(
      0,
      (previousValue, element) =>
          int.parse(previousValue.toString()) + element.adet);
}
