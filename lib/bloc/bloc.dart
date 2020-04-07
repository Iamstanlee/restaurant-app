import 'dart:io';

import 'package:fgrestaurant/api/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class Bloc with ChangeNotifier {
  Firebase firebase = Firebase(path: 'users');
  StorageReference firebaseStorage = FirebaseStorage.instance.ref();
  void uploadRestaurant(Map<String, dynamic> map, String uid,
      {Function onDone, Function(dynamic error) onError}) {
    String kycURL;
    File kyc = map['kyc'];
    firebaseStorage
        .child('restaurants/${kyc.path.split('/').last}')
        .putFile(kyc)
        .onComplete
        .then((StorageTaskSnapshot snapshot) {
      snapshot.ref.getDownloadURL().then((downloadURL) {
        kycURL = downloadURL;
      }).whenComplete(() {
        map['kyc'] = kycURL;
        map['restaurantRegistered'] = true;
        firebase.updateDocument(uid, map).then((res) {
          onDone();
        }).catchError((err) {
          onError(err);
        });
      });
    }).catchError((err) {
      onError(err);
    });
  }
}
