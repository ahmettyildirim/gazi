import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/model/maliyet.dart';

class MaliyetDetay extends StatefulWidget {
  MaliyetDetay({Key? key, required this.maliyet}) : super(key: key);
  MaliyetModel maliyet;

  @override
  State<MaliyetDetay> createState() => _MaliyetDetayState();
}

class _MaliyetDetayState extends State<MaliyetDetay> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_MaliyetDetailFormState');
  var _toplamSayiController = TextEditingController();
  var _toplamAdetController = TextEditingController();
  var _toplamAdetTutariController = TextEditingController();
  var _toplamTutarController = TextEditingController();
  var _aciklamaController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _toplamSayiController.text = widget.maliyet.toplamSayi.toString();
    _toplamAdetController.text = widget.maliyet.adetSayisi.toString();
    _toplamAdetTutariController.text = widget.maliyet.adetTutari.toString();
    _toplamTutarController.text = widget.maliyet.toplamTutar.toString();
    _aciklamaController.text = widget.maliyet.aciklama.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getMaliyetDetayTitle(widget.maliyet.maliyetTip)),
        ),
        body: SafeArea(
            bottom: true,
            top: true,
            left: true,
            right: true,
            minimum: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: SingleChildScrollView(
              child: getForm(),
            )));
  }

  Widget getForm() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            [1, 2].contains(widget.maliyet.maliyetTip)
                ? TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _toplamSayiController,
                    decoration: InputDecoration(
                        labelText: getToplamSayiAdi(widget.maliyet.maliyetTip)),
                  )
                : Center(),
            [1, 2, 3, 4, 5, 6, 7, 8].contains(widget.maliyet.maliyetTip)
                ? TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _toplamAdetController,
                    onChanged: getToplamTutar,
                    decoration: InputDecoration(
                        labelText:
                            getAdetSayisiName(widget.maliyet.maliyetTip)),
                  )
                : Center(),
            [1, 2, 3, 4, 5, 6, 7, 8].contains(widget.maliyet.maliyetTip)
                ? TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _toplamAdetTutariController,
                    onChanged: getToplamTutar,
                    decoration: InputDecoration(
                        labelText: getAdetTutar(widget.maliyet.maliyetTip)),
                  )
                : Center(),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _toplamTutarController,
              enabled:
                  ![1, 2, 3, 4, 5, 6, 7, 8].contains(widget.maliyet.maliyetTip),
              decoration: InputDecoration(
                  labelText: getMaliyetName(widget.maliyet.maliyetTip)),
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              controller: _aciklamaController,
              maxLines: null,
              minLines: 2,
              decoration: InputDecoration(labelText: 'Açıklama (İsteğe bağlı)'),
            ),
            ButtonBar(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.arrow_back_ios_new),
                  label: Text("Geri"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton.icon(
                  icon: Icon(
                      widget.maliyet.id.isEmpty ? Icons.add : Icons.refresh),
                  label: Text(widget.maliyet.id.isEmpty ? "Ekle" : "Güncelle"),
                  onPressed: addOrUpdateMaliyet,
                ),
              ],
            )
          ],
        ));
  }

  Widget getStyledText(String value, double width) {
    return Text(value,
        style: TextStyle(
            color: Colors.blue,
            fontSize: width / 25,
            decoration: TextDecoration.underline));
  }

  void getToplamTutar(val) {
    int? adet = int.tryParse(_toplamAdetController.text);
    int? adetTutar = int.tryParse(_toplamAdetTutariController.text);
    if (adet != null && adetTutar != null) {
      var value = adet * adetTutar;
      setState(() {
        _toplamTutarController.text = value.toString();
      });
    } else {
      _toplamTutarController.text = "0";
    }
  }

  Future<void> addOrUpdateMaliyet() async {
    widget.maliyet.toplamSayi = [1, 2].contains(widget.maliyet.maliyetTip)
        ? int.parse(_toplamSayiController.text)
        : 0;
    widget.maliyet.adetSayisi =
        [1, 2, 3, 4, 5, 6, 7, 8].contains(widget.maliyet.maliyetTip)
            ? int.parse(_toplamAdetController.text)
            : 0;
    widget.maliyet.adetTutari =
        [1, 2, 3, 4, 5, 6, 7, 8].contains(widget.maliyet.maliyetTip)
            ? int.parse(_toplamAdetTutariController.text)
            : 0;
    widget.maliyet.toplamTutar = int.parse(_toplamTutarController.text);
    widget.maliyet.aciklama = _aciklamaController.text;
    if (widget.maliyet.id.isEmpty) {
      await DataRepository.instance.addNewItem(widget.maliyet);
    } else {
      await DataRepository.instance.updateItem(widget.maliyet);
    }
    Navigator.pop(context);
  }
}
