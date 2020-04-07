import 'package:after_layout/after_layout.dart';
import 'package:fgrestaurant/bloc/authbloc.dart';
import 'package:fgrestaurant/constants/fonts.dart';
import 'package:fgrestaurant/helpers/functions.dart';
import 'package:fgrestaurant/screens/authentication/authpage.dart';
import 'package:fgrestaurant/screens/mainapp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  @override
  void afterFirstLayout(BuildContext context) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    if (user != null) {
      // load user data from localStorage
      authBloc.getUser(user.uid);
      replace(context, MainApp());
    } else {
      replace(context, AuthPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Loading App..',
            style: TextStyle(
                fontFamily: primaryFont, color: Colors.black, fontSize: 12)),
      ),
    );
  }
}
