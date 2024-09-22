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

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        color: Colors.green.shade400,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: GNav(
            backgroundColor: Colors.green.shade400,
            color: Colors.white,
            activeColor: Colors.green.shade900,
            tabBackgroundColor: Colors.green.shade300,
            tabBorderRadius: 18.0,
            gap: 18,
            padding: const EdgeInsets.all(16),
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
              ),
              GButton(
                icon: Icons.save,
                text: 'Save',
              ),
              GButton(
                icon: Icons.volunteer_activism,
                text: 'Donation',
              ),
              GButton(
                icon: Icons.request_page,
                text: 'Advance',
              ),
              GButton(
                icon: Icons.history_edu,
                text: 'History',
              )
            ],
          ),
        ),
      ),
    );
  }
}
