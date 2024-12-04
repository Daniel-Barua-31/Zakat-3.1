import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:zakat/pages/advance_donation_history.dart';
import 'package:zakat/pages/advance_donation_page.dart';
import 'package:zakat/pages/zakat_saved.dart';
import 'home_page.dart';
import 'save_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> savedDataList = [];
  final List<Map<String, dynamic>> _zakatSavedDataList = [];

  void addSavedData(Map<String, dynamic> data) {
    setState(() {
      savedDataList.add(data);
    });
  }

  void _saveZakatData(Map<String, dynamic> zakatData) {
    setState(() {
      _zakatSavedDataList.add(zakatData);
    });
  }

  void _updateZakatData(int index, Map<String, dynamic> updatedData) {
    setState(() {
      if (index >= 0 && index < _zakatSavedDataList.length) {
        _zakatSavedDataList[index] = updatedData;
      } else {
        _zakatSavedDataList.add(updatedData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        selectedCurrency: '',
        availableCurrencies: const [],
        onSave: addSavedData,
        onSaveZakat: (zakatData) {
          setState(() {
            if (zakatData['editIndex'] != null) {
              _updateZakatData(zakatData['editIndex'], zakatData);
            } else {
              _saveZakatData(zakatData);
            }
          });
        },
      ),
      SavePage(
        savedDataList: savedDataList,
        onEdit: (index, updatedData) {
          setState(() {
            savedDataList[index] = updatedData;
          });
        },
        onSaveZakat: _saveZakatData,
      ),
      ZakatSaved(
        zakatDataList: _zakatSavedDataList,
        onUpdateZakat: _updateZakatData,
      ),
      AdvanceDonationPage(
        initialData: const {},
        editIndex: 0,
        onSaveAdvanceDonation: (updatedData) {},
      ),
      AdvanceDonationHistory(
        onUpdateAdvanceDonation: (index, updatedData) {},
      ),
    ];

    Color backgroundColor = Colors.white;
    Color navBarColor = Colors.green.shade400;
    Color navBarBackgroundColor = Colors.green.shade400;

    if (_selectedIndex == 3 || _selectedIndex == 4) {
      backgroundColor = Colors.blue.shade100;
      navBarColor = Colors.blue.shade400;
      navBarBackgroundColor = Colors.blue.shade400;
    }

    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: Container(
        color: navBarColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: GNav(
            backgroundColor: navBarBackgroundColor,
            color: Colors.white,
            activeColor: _selectedIndex == 3 || _selectedIndex == 4
                ? Colors.blue.shade900
                : Colors.green.shade900,
            tabBackgroundColor: _selectedIndex == 3 || _selectedIndex == 4
                ? Colors.blue.shade300
                : Colors.green.shade300,
            tabBorderRadius: 10.0,
            gap: 10,
            padding: const EdgeInsets.all(8),
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              GButton(
                icon: Icons.calculate,
                text: 'Calculate',
                textStyle: TextStyle(fontSize: 8),
              ),
              GButton(
                icon: Icons.save,
                text: 'Save',
                textStyle: TextStyle(fontSize: 8),
              ),
              GButton(
                icon: Icons.volunteer_activism,
                text: 'Donation',
                textStyle: TextStyle(fontSize: 8),
              ),
              GButton(
                icon: Icons.request_page,
                text: 'Advance',
                textStyle: TextStyle(fontSize: 8),
              ),
              GButton(
                icon: Icons.history_edu,
                text: 'History',
                textStyle: TextStyle(fontSize: 8),
              )
            ],
          ),
        ),
      ),
    );
  }
}
