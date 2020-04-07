import 'package:fgrestaurant/bloc/authbloc.dart';
import 'package:fgrestaurant/constants/styles.dart';
import 'package:fgrestaurant/helpers/functions.dart';
import 'package:fgrestaurant/screens/authentication/authpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  static String title = 'Profile';
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(Profile.title),
          raisedButton(() {
            Provider.of<AuthBloc>(context).signOut(onDone: () {
              pushToDispose(context, AuthPage());
            });
          }, 'Signout')
        ],
      )),
    );
  }
}
