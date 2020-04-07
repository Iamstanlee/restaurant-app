import 'package:dotted_border/dotted_border.dart';
import 'package:fgrestaurant/bloc/authbloc.dart';
import 'package:fgrestaurant/bloc/bloc.dart';
import 'package:fgrestaurant/constants/fonts.dart';
import 'package:fgrestaurant/constants/styles.dart';
import 'package:fgrestaurant/helpers/base_textfield.dart';
import 'package:fgrestaurant/helpers/functions.dart';
import 'package:fgrestaurant/screens/registerestaurant.dart/location.dart';
import 'package:fgrestaurant/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class RegisterRestaurant extends StatefulWidget {
  static String title = 'RegisterRestaurant';
  @override
  _RegisterRestaurantState createState() => _RegisterRestaurantState();
}

class _RegisterRestaurantState extends State<RegisterRestaurant> {
  var formKey = GlobalKey<FormState>();
  Map<String, dynamic> restaurantInfo = {
    'shopOpen': '8:00 AM',
    'shopClose': '10:00 PM'
  };

  void registerRestaurant() {
    Bloc bloc = Provider.of<Bloc>(context, listen: false);
    AuthBloc authBloc = Provider.of<AuthBloc>(context, listen: false);
    FormState formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();
      Toast.show('Please Wait...', context, isTimed: false);
      bloc.uploadRestaurant(
        restaurantInfo,
        authBloc.currentUser.uid,
        onError: (err) {
          Toast.show('Error : $err', context);
        },
        onDone: () {
          Toast.show('Restaurant registered successfully.', context,
              isTimed: false, backgroundColor: Colors.green[600]);
          Future.delayed(Duration(seconds: 4), () {
            Toast.dismiss();
            pop(context);
          });
        },
      );
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
                height: getHeight(context, height: 9),
              ),
              Padding(
                padding: const EdgeInsets.only(left: kHorizontalPadding),
                child: Text(
                  'Register Restaurant',
                  style: TextStyle(
                      fontSize: 27,
                      fontFamily: primaryFont,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: kHorizontalPadding),
                child: Text(
                  'Basic Details',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              SizedBox(height: 6),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: kHorizontalPadding + 8),
                  child: RegUnderlineField(
                    onSaved: (value) {
                      restaurantInfo['restaurantName'] = value;
                    },
                    labelText: 'Restaurant Name',
                    hintText: 'Enter Restaurant name',
                    suffix: Text(''),
                  )),
              SizedBox(height: 6),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: kHorizontalPadding + 8),
                child: RegUnderlineField(
                    onSaved: (value) {
                      restaurantInfo['postalCode'] = value;
                    },
                    labelText: 'Postal Code',
                    hintText: 'Enter Postal Code',
                    suffix: Text('')),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: kHorizontalPadding),
                child: Text(
                  'Location',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: Center(
                  child: InkWell(
                    onTap: () async {
                      final result = await push(context, Location());
                      if (result != null)
                        setState(() {
                          restaurantInfo['location'] = result['location'];
                          restaurantInfo['latitude'] =
                              result['coordinates'].latitude;
                          restaurantInfo['longitude'] =
                              result['coordinates'].longitude;
                        });
                    },
                    child: Text(
                      restaurantInfo['location'] == null
                          ? 'Tap to set Restaurant location, This enables us to help you get customers efficiently.'
                          : '${restaurantInfo['location']}',
                      style: TextStyle(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: kHorizontalPadding),
                child: Text(
                  'Working Hours',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: kHorizontalPadding),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                ImageIcon(AssetImage(getPng('shop-open')),
                                    color: Colors.black),
                                SizedBox(width: 8),
                                Text(
                                    restaurantInfo['shopOpen'] == null
                                        ? '08:00 AM'
                                        : '${restaurantInfo['shopOpen']}',
                                    style: TextStyle(color: Colors.black))
                              ],
                            ),
                            SizedBox(width: 12),
                            InkWell(
                              onTap: () async {
                                TimeOfDay selectedTime = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );
                                if (selectedTime != null)
                                  setState(() {
                                    restaurantInfo['shopOpen'] =
                                        selectedTime.format(context);
                                  });
                              },
                              child: Text('Edit',
                                  style: TextStyle(
                                      color: Colors.blue[600],
                                      decoration: TextDecoration.underline)),
                            )
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                ImageIcon(AssetImage(getPng('shop-close')),
                                    color: Colors.black),
                                SizedBox(width: 8),
                                Text(
                                    restaurantInfo['shopClose'] == null
                                        ? '10:00 PM'
                                        : '${restaurantInfo['shopClose']}',
                                    style: TextStyle(color: Colors.black))
                              ],
                            ),
                            SizedBox(width: 12),
                            InkWell(
                              onTap: () async {
                                TimeOfDay selectedTime = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );
                                if (selectedTime != null)
                                  setState(() {
                                    restaurantInfo['shopClose'] =
                                        selectedTime.format(context);
                                  });
                              },
                              child: Text('Edit',
                                  style: TextStyle(
                                      color: Colors.blue[600],
                                      decoration: TextDecoration.underline)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: kHorizontalPadding),
                child: Text(
                  'KYC',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              kPadding(InkWell(
                onTap: () async {
                  var kyc = await pickImage();
                  if (kyc != null)
                    setState(() {
                      restaurantInfo['kyc'] = kyc;
                    });
                },
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(0),
                  strokeWidth: 0.5,
                  color: Colors.grey[600],
                  dashPattern: [4, 4],
                  padding: EdgeInsets.all(6),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                        restaurantInfo['kyc'] == null
                            ? 'Upload identity document for verification (.png, .jpg)'
                            : '${restaurantInfo['kyc'].path.split('/').last}',
                        style: TextStyle(color: Colors.grey[600]),
                        textAlign: TextAlign.center),
                  ),
                ),
              )),
              kPadding(raisedButton(() {
                registerRestaurant();
              }, 'Register'))
            ],
          ),
        ),
      ),
    );
  }
}
