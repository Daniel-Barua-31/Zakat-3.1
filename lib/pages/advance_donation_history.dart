import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zakat/pages/advance_donation_page.dart';
import 'package:zakat/utils/advance_donation_tile.dart';

class AdvanceDonationHistory extends StatelessWidget {
  final Function(int, Map<String, dynamic>) onUpdateAdvanceDonation;

  const AdvanceDonationHistory({
    super.key,
    required this.onUpdateAdvanceDonation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Advance Donation History',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[400],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('advanceDonation').listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text('No saved advance donations yet.'),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final data = _convertToStringDynamic(box.getAt(index));
              return AdvanceDonationTile(
                sessionYear: data['sessionYear'] ?? '',
                totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
                currency: data['currency'] ?? '',
                date: data['date'] ?? '',
                onEdit: () => _editAdvanceDonation(context, index, data),
                onDelete: (context) => _deleteAdvanceDonation(context, index),
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

  void _editAdvanceDonation(
    BuildContext context,
    int index,
    Map<String, dynamic> data,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdvanceDonationPage(
          initialData: data,
          editIndex: index,
          onSaveAdvanceDonation: (updatedData) {
            final box = Hive.box('advanceDonation');
            box.putAt(index, updatedData);
            onUpdateAdvanceDonation(index, updatedData);
          },
        ),
      ),
    );

    if (result != null) {
      // The update is handled by ValueListenableBuilder, so we don't need to do anything here
    }
  }

  void _deleteAdvanceDonation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
            'Are you sure you want to delete this advance donation?',
          ),
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
                final box = Hive.box('advanceDonation');
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
