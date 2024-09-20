import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zakat/pages/process_page.dart';
import 'package:zakat/utils/zakat_tile.dart';

class ZakatSaved extends StatelessWidget {
  final Function(int, Map<String, dynamic>) onUpdateZakat;

  const ZakatSaved({
    super.key,
    required this.onUpdateZakat,
    required List zakatDataList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Donation History',
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor: Colors.green[400],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('zakatDistribution').listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(
                child: Text('No saved Zakat distributions yet.'));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final data = _convertToStringDynamic(box.getAt(index));
              return ZakatTile(
                sessionYear: data['sessionYear'] ?? '',
                zakat: (data['zakat'] as num?)?.toDouble() ?? 0.0,
                currency: data['currency'] ?? '',
                remaining: (data['remaining'] as num?)?.toDouble() ?? 0.0,
                advance: (data['advance'] as num?)?.toDouble() ?? 0.0,
                // onEdit: (data['remaining'] as num? ?? 0) > 0
                //     ? () => _editZakat(context, index, data)
                //     : null,
                onEdit: () => _editZakat(context, index, data),
                onDelete: (context) => _deleteZakat(context, index),
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
        if (value is Map) {
          value = _convertToStringDynamic(value);
        } else if (value is List) {
          value = value
              .map((e) => e is Map ? _convertToStringDynamic(e) : e)
              .toList();
        }
        return MapEntry(key.toString(), value);
      });
    }
    return {};
  }

  void _editZakat(
      BuildContext context, int index, Map<String, dynamic> data) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProcessPage(
          initialZakatData: data,
          editIndex: index, // Add this line
          onSaveZakatProcess: (updatedData) {
            final box = Hive.box('zakatDistribution');
            box.putAt(index, updatedData);
            onUpdateZakat(index, updatedData);
          },
        ),
      ),
    );

    if (result != null) {
      // The update is handled by ValueListenableBuilder, so we don't need to do anything here
    }
  }

  void _deleteZakat(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
              'Are you sure you want to delete this Zakat distribution?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                final box = Hive.box('zakatDistribution');
                box.deleteAt(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
