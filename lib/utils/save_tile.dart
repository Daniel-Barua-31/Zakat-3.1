import 'package:flutter/material.dart';

class SaveTile extends StatelessWidget {
  final String date;
  final double zakat;
  final String currency;
  final VoidCallback onEdit;

  const SaveTile({
    Key? key,
    required this.date,
    required this.zakat,
    required this.currency,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.green.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date: $date',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text('Zakat: ${zakat.toStringAsFixed(2)} $currency'),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}
