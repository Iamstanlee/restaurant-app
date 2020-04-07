import 'package:fgrestaurant/bloc/authbloc.dart';
import 'package:fgrestaurant/constants/fonts.dart';
import 'package:fgrestaurant/helpers/functions.dart';
import 'package:fgrestaurant/screens/home/home.dart';
import 'package:fgrestaurant/screens/menu/menu.dart';
import 'package:fgrestaurant/screens/orders/order.dart';
import 'package:fgrestaurant/screens/profile/profile.dart';
import 'package:fgrestaurant/screens/store/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int selectedIndex = 0;
  List<Widget> _widgets = [Home(), Menu(), Orders(), Store(), Profile()];
  @override
  Widget build(BuildContext context) {
    // AuthBloc authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      body: _widgets[selectedIndex],
      bottomNavigationBar: bottomNavbar(
          onTap: (newIndex) {
            setState(() {
              selectedIndex = newIndex;
            });
          },
          currentIndex: selectedIndex),
    );
  }
}

Widget bottomNavbar({@required onTap, @required currentIndex}) {
  return BottomNavigationBar(
    onTap: onTap,
    currentIndex: currentIndex,
    unselectedLabelStyle: TextStyle(fontFamily: primaryFont),
    selectedLabelStyle: TextStyle(fontFamily: primaryFont),
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.black38,
    type: BottomNavigationBarType.fixed,
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage(getPng('home'))),
        title: Text('Home'),
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage(getPng('res-fork'))),
        title: Text('Manage'),
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage(getPng('order-book'))),
        title: Text('Orders'),
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage(getPng('shop'))),
        title: Text('Store'),
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage(getPng('user'))),
        title: Text('Me'),
      ),
    ],
  );
}
