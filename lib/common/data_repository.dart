import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazi_app/common/helper.dart';
import 'package:gazi_app/model/customer.dart';
import 'package:gazi_app/model/general_model.dart';
import 'package:gazi_app/model/payment.dart';
import 'package:gazi_app/model/sale.dart';

class CollectionKeys {
  static final users = "users";
  static final customers = "customers";
  static final hisseKurban = "hisse_kurban";
  static final sales = "sales";
  static final salesDeleted = "sales_deleted";
  static final kotra = "kotra";
  static final hisse = "hisse";
  static final payment = "payment";
  static final maliyet = "maliyet";
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
  late int amount;
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
  static final saleAmount = "amount";
  static final saleGeneralAmount = "general_amount";
  static final saleKaparo = "kaparo";
  static final saleRemainingAmount = "remaining_amount";
  static final saleHisseRef = "hisse_ref";
  static final saleHisseNum = "hisse_num";
  static final saleKotraNo = "kotra_no";
  static final saleAdet = "adet";
  static final aciklama = "aciklama";
  static final kotraNo = "no";
  static final kotraCapacity = "capacity";
  static final kotraNumOfItems = "numOfItems";
  static final hisseAmount = "amount";
  static final hisseCount = "count";
  static final createUser = "create_user";
  static final createTime = "create_time";
  static final updateUser = "update_user";
  static final updateTime = "update_time";
  static final paymentAmount = "amount";
  static final paymentType = "type";
  static final customer = "customer";
  static final isVekalet = "is_vekalet";
  static final maliyetTip = "tip";
  static final maliyetAltTip = "alt_tip";
  static final maliyetToplamTutar = "toplam_tutar";
  static final maliyetToplamSayi = "toplam_sayi";
  static final maliyetAdetSayisi = "adet_sayisi";
  static final maliyetAdetTutari = "adet_tutari";
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
    var map = genericModel.toMap();
    map[FieldKeys.createUser] = getUsername();
    map[FieldKeys.createTime] = DateTime.now();
    return await _addNewDocument(genericModel.colRef.doc(), map);
  }

  Future<DocumentReference> addNewItem(GenericModel genericModel) async {
    var map = genericModel.toMap();
    map[FieldKeys.createUser] = getUsername();
    map[FieldKeys.createTime] = DateTime.now();
    // _firestore.collection(genericModel.colRef.doc().set(genericModel.toMap());
    return _firestore.collection(genericModel.collectionReferenceName).add(map);
    // return await _addNewDocument(
    //     genericModel.colRef.doc(), genericModel.toMap());
  }

  Future<bool> deleteSale(SaleModel sale) async {
    sale.collectionReferenceName = CollectionKeys.salesDeleted;
    await addNewItem(sale);
    await _firestore.collection(CollectionKeys.sales).doc(sale.id).delete();
    return true;
  }
  Future<bool> deletePayment(String saleId, PaymentModel payment) async {

    var colReference =
        _getCurrentDocumentReference(CollectionKeys.sales, saleId);

  var values = await colReference.get();
    var data = values.data() as Map<String, dynamic>;
    int kaparo = data[FieldKeys.saleKaparo];
    int newKaparo = kaparo - payment.amount;
    int remainingAmount = 0;
    if (data[FieldKeys.saleKurbanSubTip].toString() == "3") {
      remainingAmount = (data[FieldKeys.saleAmount] as int) - newKaparo;
    } else {
      remainingAmount = (data[FieldKeys.saleGeneralAmount] as int) - newKaparo;
    }
    if (remainingAmount < 0) {
      remainingAmount = 0;
    }
    await colReference.update({
      FieldKeys.saleKaparo: newKaparo,
      FieldKeys.saleRemainingAmount: remainingAmount
    });
    await _firestore.collection(CollectionKeys.sales).doc(saleId).collection(CollectionKeys.payment).doc(payment.id).delete();
    return true;
  }

  Future<DocumentReference> addNewItemToCollection(
      CollectionReference<Map<String, dynamic>> collection,
      GenericModel genericModel) async {
    var map = genericModel.toMap();
    map[FieldKeys.createUser] = getUsername();
    map[FieldKeys.createTime] = DateTime.now();
    return collection.add(map);
  }

  Future<void> updateItem(GenericModel genericModel) async {
    var map = genericModel.toMap();
    map[FieldKeys.updateUser] = getUsername();
    map[FieldKeys.updateTime] = DateTime.now();
    // _firestore.collection(genericModel.colRef.doc().set(genericModel.toMap());
    return _firestore
        .collection(genericModel.collectionReferenceName)
        .doc(genericModel.id)
        .update(map);
    // return await _addNewDocument(
    //     genericModel.colRef.doc(), genericModel.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllItems(String collectionName,
      {String? orderBy, bool descending = false}) {
    return orderBy == null
        ? getCollectionReference(collectionName).snapshots()
        : getCollectionReference(collectionName)
            .orderBy(orderBy, descending: descending)
            .snapshots();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getAllItemsFuture(
      String collectionName,
      {String? orderBy}) async {
    return orderBy == null
        ? getCollectionReference(collectionName).snapshots()
        : getCollectionReference(collectionName).orderBy(orderBy).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllItemsByFilter(
      String collectionName,
      {String? filterName,
      Object? filterValue}) {
    return getCollectionReference(collectionName)
        .where(filterName!, isEqualTo: filterValue)
        .snapshots()
        .first;
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

//kotra document references

  CollectionReference<Map<String, dynamic>> _kotraCollRef() =>
      getCollectionReference(CollectionKeys.kotra);

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

  // sale operations
  Future<DocumentReference> addNewPayment(
      DocumentReference reference, PaymentModel payment) async {
    var values = await reference.get();
    var data = values.data() as Map<String, dynamic>;
    int kaparo = data[FieldKeys.saleKaparo];
    int newKaparo = kaparo + payment.amount;
    int remainingAmount = 0;
    if (data[FieldKeys.saleKurbanSubTip].toString() == "3") {
      remainingAmount = (data[FieldKeys.saleAmount] as int) - newKaparo;
    } else {
      remainingAmount = (data[FieldKeys.saleGeneralAmount] as int) - newKaparo;
    }
    if (remainingAmount < 0) {
      remainingAmount = 0;
    }
    await reference.update({
      FieldKeys.saleKaparo: newKaparo,
      FieldKeys.saleRemainingAmount: remainingAmount
    });
    return await addNewItemToCollection(
        reference.collection(CollectionKeys.payment), payment);
  }

  Future<DocumentReference> addNewPaymentWithReferenceId(
      String referenceId, PaymentModel payment) async {
    var colReference =
        _getCurrentDocumentReference(CollectionKeys.sales, referenceId);
    return await addNewPayment(colReference, payment);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSalePaymentList(
      String referenceId) {
    return getCollectionReference(CollectionKeys.sales)
        .doc(referenceId)
        .collection(CollectionKeys.payment)
        .orderBy(FieldKeys.createTime)
        .snapshots();
  }

  Future<bool> isSaleNumAlreadyGiven(int saleNo, int typeNo) async {
    var _snapShot = await getCollectionReference(CollectionKeys.sales)
        .where(FieldKeys.saleKurbanNo, isEqualTo: saleNo)
        .where(FieldKeys.saleKurbanTip, isEqualTo: typeNo)
        .snapshots()
        .first;
    return _snapShot.docs.isNotEmpty;
  }
}

Future<void> addNewKotra(int kotraNo, int capacity) async {
  var customer = HashMap<String, dynamic>();
  customer["no"] = kotraNo;
  customer["capacity"] = capacity;
  customer["numOfItems"] = 0;
  await refKotra.push().set(customer);
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
  return 0;
}
