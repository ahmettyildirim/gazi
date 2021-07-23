import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class GenericModel {
  late final String id;
  late final CollectionReference<Map<String, dynamic>> colRef;
  late final String collectionReferenceName;
  HashMap<String, dynamic> toMap();
}
