import 'package:flutter/material.dart';
import 'package:gazi_app/common/helper.dart';
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
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Maliyetler"),
      ),
      body: SafeArea(
        bottom: true,
        top: true,
        left: true,
        right: true,
        minimum: EdgeInsets.only(top: 20, bottom: 20, left: 8, right: 8),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return index == 10
                  ? SizedBox(
                      height: height / 25,
                    )
                  : ListTile(
                      title: Container(
                          width: width / 4,
                          child: Text(getMaliyetName(index + 1),
                              style: TextStyle(
                                  fontSize:
                                      index == 9 ? width / 17 : width / 25))),
                      dense: true,
                      trailing: index == 9
                          ? Text(
                              getMoneyString((index + 1) * 120050),
                              style: TextStyle(fontSize: width / 17),
                            )
                          : TextButton(
                              onPressed: () {},
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    getMoneyString((index + 1) * 120050),
                                    style: TextStyle(fontSize: width / 25),
                                  ),
                                  SizedBox(
                                    width: width / 100,
                                  ), // <-- Text

                                  Icon(
                                    // <-- Icon
                                    Icons.arrow_forward_ios,
                                    size: width / 25,
                                  ),
                                ],
                              ),
                            ),

                      // onPressed: () {},
                      // icon: Icon(Icons.arrow_forward_ios,
                      //     textDirection: TextDirection.ltr),
                      // label: Text((index * 12500).toString() + " TL"))
                    );
            },
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (context, index) {
              return Divider(
                height: 15,
                thickness: 2,
              );
            },
            itemCount: 11),
      ),
    );
  }
}