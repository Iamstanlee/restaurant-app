import 'package:fgrestaurant/bloc/authbloc.dart';
import 'package:fgrestaurant/bloc/bloc.dart';
import 'package:fgrestaurant/bloc/mapbloc.dart';
import 'package:fgrestaurant/bloc/searchbloc.dart';
import 'package:fgrestaurant/screens/splash/splash.dart';
import 'package:fgrestaurant/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(FgRestaurant());
}

class FgRestaurant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthBloc()),
        ChangeNotifierProvider(create: (context) => MapBloc()),
        ChangeNotifierProvider(create: (context) => SearchBloc()),
        ChangeNotifierProvider(create: (context) => Bloc()),
      ],
      child: MaterialApp(
          theme: theme, debugShowCheckedModeBanner: false, home: Splash()),
    );
  }
}
