import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Firebase {
  CollectionReference reference;
  String path;
  Firestore firestore = Firestore.instance;
  Firebase({@required this.path}) {
    this.reference = firestore.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return reference.getDocuments();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return reference.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return reference.document(id).get();
  }

  Future<void> removeDocument(String id) {
    return reference.document(id).delete();
  }

  Future<DocumentReference> addDocument(Map data) {
    return reference.add(data);
  }

  Future<void> updateDocument(String id, Map<String, dynamic> document) {
    return reference.document(id).updateData(document);
  }

  Future<void> setDocument(String id, Map<String, dynamic> document) {
    return reference.document(id).setData(document);
  }
}
