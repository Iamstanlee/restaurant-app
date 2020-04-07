import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Store extends StatefulWidget {
  static String title = 'Store';
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(Store.title)),
    );
  }
}
