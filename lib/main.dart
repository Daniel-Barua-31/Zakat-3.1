
import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/intro_page.dart';
import 'pages/main_page.dart';
import 'pages/save_page.dart';
import 'pages/select_currency.dart';
import 'utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: IntroPage(),
      initialRoute: '/',
      routes: {
        MyRoutes.IntroRoute: (context) => IntroPage(),
        MyRoutes.HomeRoute: (context) => HomePage(selectedCurrency: '',),
        MyRoutes.SaveRoute: (context) => SavePage(savedDataList: [],),
        MyRoutes.MainRoute : (context) => MainPage(),
        MyRoutes.SelectedRoute: (context) => SelectCurrency(),
      },
    );
  }
}
