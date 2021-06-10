import 'dart:collection';

import 'package:gazi_app/model/general_model.dart';

class Hisse {
  int amount;
  int count;

  Hisse(this.amount, this.count);

  factory Hisse.fromJson(Map<dynamic, dynamic> json) {
    return Hisse(
      json["amount"] as int,
      json["count"] as int,
    );
  }

  @override
  HashMap<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
