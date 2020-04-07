import 'package:fgrestaurant/bloc/authbloc.dart';
import 'package:fgrestaurant/constants/fonts.dart';
import 'package:fgrestaurant/constants/styles.dart';
import 'package:fgrestaurant/helpers/base_textfield.dart';
import 'package:fgrestaurant/helpers/functions.dart';
import 'package:fgrestaurant/screens/authentication/signup/signup.dart';
import 'package:fgrestaurant/screens/home/home.dart';
import 'package:fgrestaurant/screens/mainapp.dart';
import 'package:fgrestaurant/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var formKey = GlobalKey<FormState>();
  Map<String, dynamic> signInInfo = {};
  bool loadingState = false;
  void updateLoadingState(bool state) => setState(() => loadingState = state);
  void login() {
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    FormState formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();
      updateLoadingState(true);
      authBloc.signInWithPassword(signInInfo, onDone: () {
        updateLoadingState(false);
        Toast.show('Login Successful', context,
            backgroundColor: Colors.green[300]);
        Future.delayed(Duration(seconds: 1), () {
          Toast.dismiss();
          pushToDispose(context, MainApp());
        });
      }, onError: (error) {
        updateLoadingState(false);
        Toast.show('Error : ${error.message ?? error}', context,
            backgroundColor: Colors.red);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: getHeight(context, height: 8),
              ),
              SizedBox(
                height: getHeight(context, height: 32),
                width: 200,
                child: Image.asset(
                  'assets/pngs/logo.png',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: kHorizontalPadding),
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 27,
                      fontFamily: primaryFont,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: getHeight(context, height: 4),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                child: RegField(
                  labelText: 'EMAIL ADDRESS',
                  suffix: Icon(Icons.alternate_email),
                  onSaved: (value) {
                    signInInfo['email'] = value;
                  },
                ),
              ),
              SizedBox(
                height: getHeight(context, height: 4),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                child: PasswordField(
                  labelText: 'PASSWORD',
                  suffix: ImageIcon(AssetImage(getPng('lock'))),
                  onSaved: (value) {
                    signInInfo['password'] = value;
                  },
                ),
              ),
              SizedBox(
                height: getHeight(context, height: 2),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('Forgot Password?',
                      style: TextStyle(
                        fontFamily: primaryFont,
                      )),
                ),
              ),
              SizedBox(
                height: getHeight(context, height: 2),
              ),
              kPadding(raisedButton(() {
                if (!loadingState) login();
              }, loadingState ? 'Please wait...' : 'Login')),
              InkWell(
                onTap: () {
                  push(context, SignUp());
                },
                child: Text.rich(
                  TextSpan(children: <TextSpan>[
                    TextSpan(text: 'Don\'t have an account? \n'),
                    TextSpan(
                        text: 'Create new account',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.blue))
                  ]),
                  style: TextStyle(
                    fontFamily: primaryFont,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
