import 'package:flutter/material.dart';
import 'package:gazi_app/model/maliyet.dart';

class MaliyetPage extends StatefulWidget {
  MaliyetPage({Key? key}) : super(key: key);

  @override
  State<MaliyetPage> createState() => _MaliyetPageState();
}

class _MaliyetPageState extends State<MaliyetPage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Maliyet Detayı"),
      ),
      body: SafeArea(
        bottom: true,
        top: true,
        left: true,
        right: true,
        minimum: EdgeInsets.all(10.0),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                title: Container(
                    width: width / 4, child: Text(getMaliyetName(index + 1))),
                dense: true,
                trailing: Container(child: Text("10.000 TL")),
              );
            },
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (context, index) {
              return Divider(
                height: 15,
                thickness: 2,
              );
            },
            itemCount: 10),
      ),
    );
  }
}
