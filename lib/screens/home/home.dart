import 'package:after_layout/after_layout.dart';
import 'package:fgrestaurant/bloc/authbloc.dart';
import 'package:fgrestaurant/constants/styles.dart';
import 'package:fgrestaurant/data/user.dart';
import 'package:fgrestaurant/helpers/functions.dart';
import 'package:fgrestaurant/screens/registerestaurant.dart/registerestaurant.dart';
import 'package:fgrestaurant/widgets/piechart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

// TODO listen user stream
class Home extends StatefulWidget {
  static String title = 'Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AfterLayoutMixin<Home> {
  double headerHeight = 36;
  @override
  void afterFirstLayout(BuildContext context) async {
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    authBloc.getUserStream(authBloc.currentUser.uid).listen((snapshot) {
      bool isRegistered = User.fromMap(snapshot.data).restaurantRegistered;
      if (isRegistered == false) {
        push(context, RegisterRestaurant());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    String firstname = authBloc.currentUser.name?.split(' ')?.first;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: getHeight(context, height: headerHeight),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [primaryColor, Colors.teal[400]])),
                child: Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Good Morning, ${firstname ?? ''}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600)),
                      Text('Restaurant open',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: getHeight(context, height: headerHeight) -
                getHeight(context, height: 12),
            child: Column(
              children: <Widget>[
                Container(
                  height: getHeight(context, height: 32),
                  width: getWidth(context),
                  child: ListView.separated(
                    padding:
                        EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                    itemBuilder: (context, index) {
                      var item = <Widget>[
                        buildListItem(context,
                            child: Text.rich(TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: 'Balance',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              TextSpan(text: '   34,540 INR'),
                            ])),
                            icon: ImageIcon(AssetImage(getPng('wallet')))),
                        buildListItem(context,
                            child: Text.rich(TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: 'Orders',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              TextSpan(text: '   210 '),
                              TextSpan(
                                  text: 'new',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 12,
                                      backgroundColor: Colors.redAccent)),
                            ])),
                            icon: ImageIcon(AssetImage(getPng('order-book')))),
                        buildListItem(context,
                            child: Text.rich(TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: 'Products',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              TextSpan(text: '   98'),
                            ])),
                            icon:
                                ImageIcon(AssetImage(getPng('shopping-bag')))),
                      ];
                      return Column(children: item);
                    },
                    itemCount: 1,
                    separatorBuilder: (context, index) => Divider(
                      height: 0.0,
                    ),
                  ),
                ),
                Container(
                  height: getHeight(context, height: 34),
                  width: getWidth(context),
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                  child: Pie(),
                )
              ],
            ),
          ),
          Positioned(
            top: getHeight(context, height: 6),
            right: 16,
            child: ImageIcon(
              AssetImage(getPng('notification')),
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

Widget buildListItem(BuildContext context,
    {Function onPressed, Widget icon, Widget child}) {
  return Card(
    elevation: 2,
    margin: EdgeInsets.symmetric(vertical: 0.0),
    child: Container(
      height: getHeight(context, height: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            icon: icon,
            onPressed: () {},
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: child,
            ),
          )
        ],
      ),
    ),
  );
}
