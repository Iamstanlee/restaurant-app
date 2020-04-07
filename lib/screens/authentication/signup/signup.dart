import 'package:fgrestaurant/constants/fonts.dart';
import 'package:fgrestaurant/constants/styles.dart';
import 'package:fgrestaurant/helpers/base_textfield.dart';
import 'package:fgrestaurant/helpers/functions.dart';
import 'package:fgrestaurant/screens/authentication/phone/phone.dart';
import 'package:fgrestaurant/widgets/toast.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Map<String, dynamic> signUpInfo = {};
  var formKey = GlobalKey<FormState>();

  void signUp() {
    FormState formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();
      Toast.show('Validating...', context);
      Future.delayed(Duration(seconds: 1), () {
        Toast.dismiss();
        push(context, Phone(signUpInfo: signUpInfo));
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
                height: getHeight(context, height: 12),
              ),
              Padding(
                padding: const EdgeInsets.only(left: kHorizontalPadding),
                child: Text(
                  'Create Your \nAccount',
                  style: TextStyle(
                      fontSize: 27,
                      fontFamily: primaryFont,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: kHorizontalPadding),
                child: Text(
                  'Welcome onboard! \nReach more customers using the Fresh Genie App',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: primaryFont,
                  ),
                ),
              ),
              SizedBox(
                height: getHeight(context, height: 4),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                child: RegField(
                  labelText: 'FULL NAME',
                  suffix: ImageIcon(AssetImage(getPng('shop-assistant'))),
                  onSaved: (value) {
                    signUpInfo['name'] = value;
                  },
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
                    signUpInfo['email'] = value;
                  },
                ),
              ),
              SizedBox(
                height: getHeight(context, height: 4),
              ),
              // TODO add country code +91
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                child: PhoneField(
                  labelText: 'PHONE',
                  suffix: ImageIcon(AssetImage(getPng('phone'))),
                  onSaved: (value) {
                    signUpInfo['phone'] = value;
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
                    signUpInfo['password'] = value;
                  },
                ),
              ),
              SizedBox(
                height: getHeight(context, height: 2),
              ),
              kPadding(raisedButton(() {
                signUp();
              }, 'Signup')),
              Padding(
                padding: const EdgeInsets.only(
                    left: kHorizontalPadding,
                    right: kHorizontalPadding,
                    bottom: 20),
                child: Text(
                  'By clicking "signup", You\'re onboard with our privacy policy and terms of use.',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: primaryFont,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
