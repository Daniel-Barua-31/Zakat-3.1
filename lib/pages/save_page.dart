import 'package:flutter/material.dart';
import 'package:zakat/pages/home_page.dart';
import 'package:zakat/utils/save_tile.dart';

class SavePage extends StatefulWidget {
  final List<Map<String, dynamic>> savedDataList;

  final Function(int, Map<String, dynamic>) onEdit;

  const SavePage({
    Key? key,
    required this.savedDataList,
    required this.onEdit,
  }) : super(key: key);

  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Calculations',
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor: Colors.green[400],
      ),
      body: ListView.builder(
        itemCount: widget.savedDataList.length,
        itemBuilder: (context, index) {
          final data = widget.savedDataList[index];
          return SaveTile(
            date: data['date'],
            zakat: data['zakat'],
            currency: data['currency'],
            onEdit: () => _editCalculation(context, index),
          );
        },
      ),
    );
  }

  void _editCalculation(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          selectedCurrency: widget.savedDataList[index]['currency'],
          editMode: true,
          editData: widget.savedDataList[index],
          onSave: (updatedData) {
            setState(() {
              widget.savedDataList[index] = updatedData;
            });
          },
          availableCurrencies: [], onSaveZakat: null,
        ),
      ),
    );
  }
}
