import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zakat/pages/home_page.dart';
import 'package:zakat/utils/save_tile.dart';

class SavePage extends StatelessWidget {
  final Function(int, Map<String, dynamic>) onEdit;
  final Function(Map<String, dynamic>) onSaveZakat;

  const SavePage({
    super.key,
    required this.onEdit,
    required this.onSaveZakat,
    required List savedDataList,
  });

  @override
  Widget build(BuildContext context) {
    final boxZakat = Hive.box('boxZakat');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Calculations',
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor: Colors.green[400],
      ),
      body: ValueListenableBuilder(
        valueListenable: boxZakat.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No saved calculations yet.'));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final data = _convertToStringDynamic(box.getAt(index));
              return SaveTile(
                date: data['date'] ?? '',
                zakat: data['zakat'] ?? 0.0,
                currency: data['currency'] ?? '',
                onEdit: () => _editCalculation(context, index, data),
                deleteFunction: (context) => _deleteSave(context, index),
              );
            },
          );
        },
      ),
    );
  }

  Map<String, dynamic> _convertToStringDynamic(dynamic item) {
    if (item is Map) {
      return item.map((key, value) {
        if (key is! String) {
          key = key.toString();
        }
        return MapEntry(key, value);
      });
    }
    return {};
  }

  void _editCalculation(
      BuildContext context, int index, Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          selectedCurrency: data['currency'] ?? '',
          editMode: true,
          editData: {...data, 'editIndex': index},
          onSave: (updatedData) {
            final boxZakat = Hive.box('boxZakat');
            boxZakat.putAt(index, updatedData);
            onEdit(index, updatedData);
            onSaveZakat(updatedData);
          },
          availableCurrencies: const [],
          onSaveZakat: onSaveZakat,
          initialCurrency: data['currency'], // recently added,
        ),
      ),
    );
  }

  void _deleteSave(BuildContext context, int index) {
    final boxZakat = Hive.box('boxZakat');
    boxZakat.deleteAt(index);
  }
}
