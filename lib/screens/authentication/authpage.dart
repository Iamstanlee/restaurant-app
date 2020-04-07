import 'package:fgrestaurant/bloc/authbloc.dart';
import 'package:fgrestaurant/constants/fonts.dart';
import 'package:fgrestaurant/constants/styles.dart';
import 'package:fgrestaurant/helpers/functions.dart';
import 'package:fgrestaurant/screens/authentication/signin/signin.dart';
import 'package:fgrestaurant/screens/authentication/signup/signup.dart';
import 'package:fgrestaurant/screens/home/home.dart';
import 'package:fgrestaurant/screens/mainapp.dart';
import 'package:fgrestaurant/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(
          getPng('bg'),
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: getHeight(context, height: 36)),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kHorizontalPadding, vertical: 10),
                child: Text.rich(
                  TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: 'M',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w100)),
                    TextSpan(
                      text:
                          'anage your restaurant business from anywhere, anytime! Get started quickly.',
                      style: TextStyle(
                          fontFamily: primaryFont, color: Colors.white),
                    ),
                  ]),
                  style:
                      TextStyle(fontFamily: primaryFont, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: getWidth(context, width: 42),
                    child: flatButton(() {
                      push(context, SignIn());
                    }, 'Login'),
                  ),
                  SizedBox(
                      width: getWidth(context, width: 42),
                      child: outlineButton(() {
                        push(context, SignUp());
                      }, 'Signup')),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      child: Center(
                          child: Text('or connect with social media',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: primaryFont,
                                  fontWeight: FontWeight.w500))),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                child: raisedIconButton(() {
                  Toast.show('Please Wait...', context, isTimed: false);
                  authBloc.signInWithGoogle(onDone: (user) {
                    Toast.show('Login successful', context,
                        backgroundColor: Colors.green[300]);
                    Future.delayed(Duration(seconds: 1), () {
                      Toast.dismiss();
                      pushToDispose(context, MainApp());
                    });
                  }, onError: (error) {
                    Toast.dismiss();
                    Toast.show('$error', context);
                  });
                }, 'Login With Google',
                    icon: ImageIcon(
                      AssetImage(getPng('google')),
                      color: Colors.white,
                    ),
                    color: Color(0xffdd4b39)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                child: raisedIconButton(() {}, 'Login With Facebook',
                    icon: ImageIcon(
                      AssetImage(getPng('facebook')),
                      color: Colors.white,
                    ),
                    color: Color(0xff3B5998)),
              ),
            ],
          ),
        )
      ],
    );
  }
}
