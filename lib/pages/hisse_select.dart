import 'package:flutter/material.dart';

import 'package:gazi_app/model/hisse_kurban.dart';

import 'kurbanlar.dart';

class HisseKurbanSelect extends StatefulWidget {
  late Function(HisseKurbanModel)? onHisseSelected;
  HisseKurbanSelect({Key? key, this.onHisseSelected}) : super(key: key);

  @override
  _HisseKurbanSelectState createState() => _HisseKurbanSelectState();
  _onHisseSelected(HisseKurbanModel model) {
    print(model.kurbanNo);
    this.onHisseSelected!(model);
  }
}

class _HisseKurbanSelectState extends State<HisseKurbanSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kurban Seçim Ekranı"),
      ),
      body: KurbanPage(
        selectable: true,
        onHisseSelected: widget._onHisseSelected,
      ),
    );
  }
}
