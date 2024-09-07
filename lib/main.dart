// ignore_for_file: prefer_const_constructors, avoid_types_as_parameter_names

import 'package:flutter/material.dart';
import 'package:zakat/pages/process_page.dart';
import 'package:zakat/pages/select_session.dart';
import 'package:zakat/pages/zakat_saved.dart';

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
        MyRoutes.HomeRoute: (context) => HomePage(
              selectedCurrency: '',
              availableCurrencies: [],
              onSaveZakat: null,
            ),
        MyRoutes.SaveRoute: (context) => SavePage(
              savedDataList: [],
              onEdit: (index, updatedData) {},
            ),
        MyRoutes.MainRoute: (context) => MainPage(),
        MyRoutes.SelectedRoute: (context) => SelectCurrency(),
        MyRoutes.ZakatSave: (context) => ZakatSaved(
              zakatDataList: [],
              onUpdateZakat: (int index, Map<String, dynamic> updatedData) {
                // Implement the update logic here if needed
                // For now, we'll leave it empty
              },
            ),
        MyRoutes.SelectedSession: (context) => SelectSession(),
        MyRoutes.Process: (context) => ProcessPage(),
      },
    );
  }
}
