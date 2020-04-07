import 'dart:async';

import 'package:fgrestaurant/bloc/authbloc.dart';
import 'package:fgrestaurant/constants/fonts.dart';
import 'package:fgrestaurant/constants/styles.dart';
import 'package:fgrestaurant/helpers/functions.dart';
import 'package:fgrestaurant/screens/home/home.dart';
import 'package:fgrestaurant/screens/mainapp.dart';
import 'package:fgrestaurant/screens/registerestaurant.dart/registerestaurant.dart';
import 'package:fgrestaurant/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';

class Phone extends StatefulWidget {
  final Map signUpInfo;
  Phone({this.signUpInfo});
  @override
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  Timer timer;
  int timeOut = 60;
  @override
  void initState() {
    super.initState();
    AuthBloc authBloc = Provider.of<AuthBloc>(context, listen: false);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeOut == 0) {
          timer.cancel();
        } else {
          timeOut--;
        }
      });
    });
    authBloc.verifyPhone(
        number: widget.signUpInfo['phone'],
        signUpInfo: widget.signUpInfo,
        onDone: () {
          Toast.show('Phone verified successfully', context,
              backgroundColor: Colors.green[300]);
          Future.delayed(Duration(seconds: 1), () {
            Toast.dismiss();
            pushToDispose(context, MainApp());
          });
        },
        onError: (err) {
          timer.cancel();
          print(err);
          Future.delayed(Duration(seconds: 1), () {
            var error = err is String ? err : err.message;
            Toast.show('Error: $error', context,
                duration: 4, backgroundColor: Colors.redAccent);
          });
        });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  void verifyManually(String smsCode) {
    AuthBloc authBloc = Provider.of<AuthBloc>(context, listen: false);
    authBloc.signInWithPhoneNumber(smsCode, widget.signUpInfo, onDone: () {
      Toast.show('Phone verified successfully', context,
          backgroundColor: Colors.green[300]);
      Future.delayed(Duration(seconds: 1), () {
        Toast.dismiss();
        pushToDispose(context, RegisterRestaurant());
      });
    }, onError: (err) {
      Toast.show('Error: ${err.message ?? err}', context,
          backgroundColor: Colors.redAccent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: getHeight(context, height: 24),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text('Verify Phone',
                  style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.w800,
                    fontFamily: primaryFont,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Enter the verification code sent to',
                    style: textStyle.copyWith(fontWeight: FontWeight.w800),
                  ),
                  Text('${widget.signUpInfo['phone']}',
                      style: textStyle.copyWith(
                          color: primaryColor,
                          fontFamily: primaryFont,
                          fontWeight: FontWeight.w800))
                ],
              ),
            ),
            SizedBox(
              height: getHeight(context, height: 4),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Center(
                  child: PinPut(
                    fieldsCount: 6,
                    autoFocus: false,
                    actionButtonsEnabled: false,
                    textStyle: textStyle.copyWith(fontSize: 18),
                    onSubmit: (String smsCode) => verifyManually(smsCode),
                  ),
                )),
            SizedBox(
              height: getHeight(context, height: 4),
            ),
            Center(
                child: Text(
              timeOut == 0 ? '00:00' : '00:$timeOut',
              style: heading18Black.copyWith(
                  fontFamily: primaryFont,
                  fontWeight: FontWeight.w800,
                  fontSize: 27),
            ))
          ],
        ),
      ),
    );
  }
}
