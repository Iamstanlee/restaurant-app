import 'dart:convert';

import 'package:localstorage/localstorage.dart';

class User {
  static LocalStorage storage = LocalStorage('store');
  String name, email, phone, address, location, uid, kyc;
  bool verified;
  bool restaurantRegistered;
  double latitude, longitude;
  User(
      {this.name,
      this.email,
      this.phone,
      this.verified,
      this.restaurantRegistered,
      this.kyc,
      this.address,
      this.latitude,
      this.location,
      this.longitude,
      this.uid});
  User.fromMap(Map map) {
    this.name = map['name'];
    this.email = map['email'];
    this.phone = map['phone'];
    this.uid = map['uid'];
    this.verified = map['verified'];
    this.kyc = map['kyc'];
    this.restaurantRegistered = map['restaurantRegistered'];
    this.location = map['location'];
    this.latitude = map['latitude'];
    this.longitude = map['longitude'];
  }
  static toMap(User user) {
    return {
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'uid': user.uid,
      'kyc': user.kyc,
      'restaurantRegistered': user.restaurantRegistered,
      'verified': user.verified,
      'location': user.location,
      'latitude': user.latitude,
      'longitude': user.longitude
    };
  }

  User.fromLocalStorage() {
    // print(json.decode(storage.getItem('user')));
    // User.fromMap(storage.getItem('user'));
  }
  static toLocalStorage(User user) {
    storage.setItem('user', User.toMap(user));
  }

  @override
  String toString() {
    return 'name => $name, email => $email, verified => $verified';
  }
}
