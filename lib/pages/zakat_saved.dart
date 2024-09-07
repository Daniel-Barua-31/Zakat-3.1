import 'package:flutter/material.dart';
import 'package:zakat/pages/process_page.dart';
import 'package:zakat/utils/zakat_tile.dart';

class ZakatSaved extends StatefulWidget {
  final List<Map<String, dynamic>> zakatDataList;
  final Function(int, Map<String, dynamic>) onUpdateZakat;

  const ZakatSaved({
    Key? key,
    required this.zakatDataList,
    required this.onUpdateZakat,
  }) : super(key: key);

  @override
  State<ZakatSaved> createState() => _ZakatSavedState();
}

class _ZakatSavedState extends State<ZakatSaved> {
  void _editZakat(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProcessPage(
          initialZakatData: widget.zakatDataList[index],
          onSaveZakatProcess: (updatedData) {
            widget.onUpdateZakat(index, updatedData);
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        // Update the list if needed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Zakat Saved',
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor: Colors.green[400],
      ),
      body: ListView.builder(
        itemCount: widget.zakatDataList.length,
        itemBuilder: (context, index) {
          final data = widget.zakatDataList[index];
          return ZakatTile(
            sessionYear: data['sessionYear'],
            zakat: data['zakat'],
            currency: data['currency'],
            remaining: data['remaining'],
            onEdit: data['remaining'] > 0 ? () => _editZakat(index) : null,
          );
        },
      ),
    );
  }
}
