import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gazi_app/common/custom_animation.dart';
import 'package:gazi_app/model/settings.dart';

import '../common/data_repository.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

var _repositoryInstance = DataRepository.instance;

class _SettingsPageState extends State<SettingsPage> {
  var _formKey = GlobalKey<FormState>(debugLabel: '_AddUserFormState');
  var _startHourController = TextEditingController();
  var _startMinuteController = TextEditingController();
  var _danaFinishHourController = TextEditingController();
  var _danaFinishMinuteController = TextEditingController();
  var _kuzuFinishHourController = TextEditingController();
  var _kuzuFinishMinuteController = TextEditingController();
  var _danaNumber = TextEditingController();
  var _kuzuNumber = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSettings();
  }

  @override
  Widget build(BuildContext context) {
    var screenInfo = MediaQuery.of(context);
    final screenWidth = screenInfo.size.width;
    final screenHeight = screenInfo.size.height;
    return Scaffold(
      appBar: AppBar(title: Text("Ayarlar")),
      body: SingleChildScrollView(
        child: Align(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 10, left: screenWidth / 8, right: screenWidth / 8),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _startHourController,
                    decoration:
                        InputDecoration(labelText: "Kesim Başlangıç (Saat)"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10, left: screenWidth / 8, right: screenWidth / 8),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _startMinuteController,
                    decoration:
                        InputDecoration(labelText: "Kesim Başlangıç (Dakika)"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Değer Giriniz';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10, left: screenWidth / 8, right: screenWidth / 8),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _danaFinishHourController,
                    decoration:
                        InputDecoration(labelText: "Büyükbaş Bitiş (Saat)"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Değer Giriniz';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10, left: screenWidth / 8, right: screenWidth / 8),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _danaFinishMinuteController,
                    decoration:
                        InputDecoration(labelText: "Büyükbaş Bitiş (Dakika)"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Değer Giriniz';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10, left: screenWidth / 8, right: screenWidth / 8),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _danaNumber,
                    decoration: InputDecoration(labelText: "Büyükbaş Sayısı"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Değer Giriniz';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10, left: screenWidth / 8, right: screenWidth / 8),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _kuzuFinishHourController,
                    decoration:
                        InputDecoration(labelText: "Küçükbaş Başlangıç (Saat)"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Değer Giriniz';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10, left: screenWidth / 8, right: screenWidth / 8),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _kuzuFinishMinuteController,
                    decoration: InputDecoration(
                        labelText: "Küçükbaş Başlangıç (Dakika)"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Değer Giriniz';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10, left: screenWidth / 8, right: screenWidth / 8),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _kuzuNumber,
                    decoration: InputDecoration(labelText: "Küçükbaş Sayısı"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Değer Giriniz';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            top: 10,
                            left: screenWidth / 8,
                            right: screenWidth / 8),
                        child: ElevatedButton(
                            onPressed: _addSetting, child: Text("Kaydet"))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getSettings() async {
    if (_startHourController.text != '') {
      return;
    }
    var sales = await _repositoryInstance
        .getCollectionReference(CollectionKeys.settings)
        .get();
    var setting = sales.docs[0].data();
    var settings = SettingsModel.fromJson(setting);
    setState(() {
      _startHourController.text = settings.startHour.toString();
      _startMinuteController.text = settings.startMinute.toString();
      _danaFinishHourController.text = settings.buyukbasEndHour.toString();
      _danaFinishMinuteController.text = settings.buyukbasEndMinute.toString();
      _danaNumber.text = settings.buyukbasNumber.toString();
      _kuzuFinishHourController.text = settings.kucukbasEndHour.toString();
      _kuzuFinishMinuteController.text = settings.kucukbasEndMinute.toString();
      _kuzuNumber.text = settings.kucukbasNumber.toString();
    });
  }

  Future<void> _addSetting() async {
    var sales = await _repositoryInstance
        .getCollectionReference(CollectionKeys.settings)
        .get();
    var setting = sales.docs[0].data();
    var settings = SettingsModel.fromJson(setting, id: sales.docs[0].id);

    settings.buyukbasEndHour = int.parse(this._danaFinishHourController.text);
    settings.buyukbasEndMinute =
        int.parse(this._danaFinishMinuteController.text);
    settings.buyukbasNumber = int.parse(this._danaNumber.text);
    settings.kucukbasEndHour = int.parse(this._kuzuFinishHourController.text);
    settings.kucukbasEndMinute =
        int.parse(this._kuzuFinishMinuteController.text);
    settings.kucukbasNumber = int.parse(this._kuzuNumber.text);
    settings.startHour = int.parse(this._startHourController.text);
    settings.startMinute = int.parse(this._startMinuteController.text);
    await _repositoryInstance.updateItem(settings);
    CustomLoader.close();
    EasyLoading.showSuccess("Ayarlar Güncellendi",
        maskType: EasyLoadingMaskType.black);
  }
}
