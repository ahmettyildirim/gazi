import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazi_app/model/customer.dart';
import 'package:gazi_app/model/general_model.dart';

class CollectionKeys {
  static final users = "users";
  static final customers = "customers";
  static final hisseKurban = "hisse_kurban";
  static final sales = "sales";
  static final kotra = "kotra";
  static final hisse = "hisse";
}

class FieldKeys {
  static final customerName = "name";
  static final customerPhone = "phone_number";
  static final customerMail = "email";
  static final hisseKurbanKurbanNo = "kurban_no";
  static final hisseKurbanKotraNo = "kotra_no";
  static final hisseKurbanHisseNum = "hisse_no";
  static final hisseKurbanHisseAmount = "hisse_amount";
  static final hisseKurbanRemainingHisse = "remainingHisse";
  late String customerRef;
  late int kurbanTip = 0;
  late int buyukKurbanTip = 0;
  late int kurbanSubTip = 0;
  late int kurbanNo;
  late int kg;
  late int kgAmount;
  late int generalAmount;
  late int kaparo;
  late int remainingAmount;
  late String hisseRef;
  late int hisseNum;
  static final saleCustomerRef = "customer_ref";
  static final saleKurbanTip = "kurban_tip";
  static final saleBuyukKurbanTip = "buyuk_kurban_tip";
  static final saleKurbanSubTip = "kurban_sub_tip";
  static final saleKurbanNo = "kurban_no";
  static final saleKg = "kg";
  static final saleKgAmount = "kg_amount";
  static final saleGeneralAmount = "general_amount";
  static final saleKaparo = "kaparo";
  static final saleRemainingAmount = "remaining_amount";
  static final saleHisseRef = "hisse_ref";
  static final saleHisseNum = "hisse_num";
  static final kotraNo = "no";
  static final kotraCapacity = "capacity";
  static final kotraNumOfItems = "numOfItems";
  static final hisseAmount = "amount";
  static final hisseCount = "count";
}

var refKotra =
    FirebaseDatabase.instance.reference().child(CollectionKeys.kotra);

class DataRepository {
  static final DataRepository instance = DataRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> getCollectionReference(
          String collectionName) =>
      _firestore.collection(collectionName);

  DocumentReference<Map<String, dynamic>> _getNewDocumentReference(
          String collectionName) =>
      _firestore.collection(collectionName).doc();

  DocumentReference<Map<String, dynamic>> _getCurrentDocumentReference(
          String collectionName, String documentId) =>
      _firestore.collection(collectionName).doc(documentId);

//generic function
  Future<void> _addNewDocument(
      DocumentReference<Map<String, dynamic>> documentReference,
      Map<String, dynamic> data) async {
    _firestore.runTransaction((transaction) async {
      transaction.set(documentReference, data);
    });
  }

//generic functions
  Future<void> addItem(GenericModel genericModel) async {
    return await _addNewDocument(
        genericModel.colRef.doc(), genericModel.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllItems(String collectionName,
      {String? orderBy}) {
    return orderBy == null
        ? getCollectionReference(collectionName).snapshots()
        : getCollectionReference(collectionName).orderBy(orderBy).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllItemsByFilter(String collectionName, 
      {String? filterName, String? filterValue}) {
    return getCollectionReference(collectionName).where(filterName!, isEqualTo: filterValue).snapshots().first;
        
  }

//generic functions
  Future<int> getItemCount(String collectionName) async {
    var snapShot =
        await FirebaseFirestore.instance.collection(collectionName).get();
    return snapShot.size;
  }

//////////////////////////////////////////////////////////////////////////////////
//customer document references

  CollectionReference<Map<String, dynamic>> _customerCollRef() =>
      getCollectionReference(CollectionKeys.customers);

  DocumentReference<Map<String, dynamic>> _customerDocRef() =>
      _getNewDocumentReference(CollectionKeys.customers);

  DocumentReference<Map<String, dynamic>> _customerDocRefWithId(
          String documentId) =>
      _getCurrentDocumentReference(CollectionKeys.customers, documentId);

//kotra document references

  CollectionReference<Map<String, dynamic>> _kotraCollRef() =>
      getCollectionReference(CollectionKeys.kotra);

  DocumentReference<Map<String, dynamic>> _kotraDocRef() =>
      _getNewDocumentReference(CollectionKeys.kotra);

  DocumentReference<Map<String, dynamic>> _kotraDocRefWithId(
          String documentId) =>
      _getCurrentDocumentReference(CollectionKeys.kotra, documentId);

  //customer operations
  Future<void> addCustomer(CustomerModel customerModel) async {
    return await _addNewDocument(_customerDocRef(), customerModel.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllCustomers() {
    return _customerCollRef().orderBy(FieldKeys.customerName).snapshots();
  }

  //kotra operations
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllKotra() {
    return _kotraCollRef().orderBy(FieldKeys.customerName).snapshots();
  }

//hisse operations
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllHisse() {
    return _customerCollRef().orderBy(FieldKeys.customerName).snapshots();
  }
}

Future<void> addNewKotra(int kotraNo, int capacity) async {
  var customer = HashMap<String, dynamic>();
  customer["no"] = kotraNo;
  customer["capacity"] = capacity;
  customer["numOfItems"] = 0;
  await refKotra.push().set(customer);
}

Future<int?> getKotraNums() async {
  DataSnapshot snapshot = await refKotra.once();
  int count = 0;
  var comingValues = snapshot.value;
  if (comingValues != null) {
    comingValues.forEach((key, value) {
      count++;
    });
    return count;
  }
}

var refHisse =
    FirebaseDatabase.instance.reference().child(CollectionKeys.hisse);

Future<void> addNewHisse(int amount, int count) async {
  var hisse = HashMap<String, dynamic>();
  hisse["amount"] = amount;
  hisse["count"] = count;
  await refHisse.push().set(hisse);
}

Future<int?> getHisseNums() async {
  DataSnapshot snapshot = await refHisse.once();
  int count = 0;
  var comingValues = snapshot.value;
  if (comingValues != null) {
    comingValues.forEach((key, value) {
      count++;
    });
    return count;
  }
}
