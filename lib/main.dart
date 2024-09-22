// ignore_for_file: prefer_const_constructors, avoid_types_as_parameter_names

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zakat/pages/advance_donation_history.dart';
import 'package:zakat/pages/advance_donation_page.dart';
import 'package:zakat/pages/process_page.dart';
import 'package:zakat/pages/select_session.dart';
import 'package:zakat/pages/zakat_saved.dart';
import 'package:zakat/providers/zakat_provider.dart';

import 'pages/home_page.dart';
import 'pages/intro_page.dart';
import 'pages/main_page.dart';
import 'pages/save_page.dart';
import 'pages/select_currency.dart';
import 'utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  var boxZakat = await Hive.openBox('boxZakat');
  await Hive.openBox('zakatDistribution');
  await Hive.openBox('advanceDonation');

  // runApp(const MyApp());
  runApp(
    ChangeNotifierProvider(
      create: (context) => ZakatProvider(),
      child: const MyApp(),
    ),
  );
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
              availableCurrencies: const [],
              onSaveZakat: (Map<String, dynamic> onSaveZakat) {},
            ),
        MyRoutes.SaveRoute: (context) => SavePage(
              savedDataList: const [],
              onEdit: (index, updatedData) {},
              onSaveZakat: (Map<String, dynamic> onSaveZakat) {},
            ),
        MyRoutes.MainRoute: (context) => MainPage(),
        MyRoutes.SelectedRoute: (context) => SelectCurrency(),
        MyRoutes.ZakatSave: (context) => ZakatSaved(
              zakatDataList: const [],
              onUpdateZakat: (int index, Map<String, dynamic> updatedData) {},
            ),
        MyRoutes.SelectedSession: (context) => SelectSession(),
        MyRoutes.Process: (context) => ProcessPage(
              onSaveZakatProcess: (Map<String, dynamic> onSaveZakatProcess) {},
              initialZakatData: const {},
            ),
        MyRoutes.Advance: (context) => AdvanceDonationPage(
              initialData: const {},
              editIndex: 0,
              onSaveAdvanceDonation: (updatedData) {},
            ),
        MyRoutes.AdvanceHistory: (context) => AdvanceDonationHistory(
              onUpdateAdvanceDonation: (index, updatedData) {},
            ),
      },
    );
  }
}
