import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:zakat/pages/zakat_saved.dart';
import 'home_page.dart';
import 'save_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> savedDataList = [];
  List<Map<String, dynamic>> _zakatSavedDataList = [];

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
      _zakatSavedDataList[index] = updatedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(
        selectedCurrency: '',
        availableCurrencies: [],
        onSave: addSavedData,
        onSaveZakat: (zakatData) {
          setState(() {
            _zakatSavedDataList.add(zakatData);
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
      ),
      ZakatSaved(
        zakatDataList: _zakatSavedDataList,
        onUpdateZakat: _updateZakatData,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
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
            padding: EdgeInsets.all(16),
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.save,
                text: 'Save',
              ),
              GButton(
                icon: Icons.account_circle,
                text: 'Profile',
              )
            ],
          ),
        ),
      ),
    );
  }
}
