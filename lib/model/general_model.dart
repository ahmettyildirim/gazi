import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class GenericModel {
  late final CollectionReference<Map<String, dynamic>> colRef;
  HashMap<String, dynamic> toMap();
}
