import 'package:flutter/material.dart';
import 'package:gazi_app/common/data_repository.dart';
import 'package:gazi_app/pages/hisseler.dart';
import 'package:gazi_app/pages/kotralist.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

var _repositoryInstance = DataRepository.instance;

class _AccountPageState extends State<AccountPage> {
  _AccountPageState() {}
  int hisseNums = 0;
  int kotraNums = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _repositoryInstance
        .getItemCount(CollectionKeys.kotra)
        .then((val) => setState(() {
              kotraNums = val;
            }));
    _repositoryInstance
        .getItemCount(CollectionKeys.hisse)
        .then((val) => setState(() {
              hisseNums = val;
            }));
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Kotarlar"),
                Text("Toplam kotar $kotraNums"),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => KotraList()));
                    },
                    child: Text("Detay"))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Hisseler"),
                Text("Toplam hisse tipi $hisseNums"),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HisseList()));
                    },
                    child: Text("Detay"))
              ],
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40), // if you need this
                side: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Container(
                color: Colors.white,
                width: 200,
                height: 200,
              ),
            )
          ],
        ),
      ),
    );
  }
}
