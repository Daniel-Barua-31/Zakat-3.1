import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ZakatTile extends StatelessWidget {
  final String sessionYear;
  final double zakat;
  final String currency;
  final double remaining;
  final VoidCallback? onEdit;
  final Function(BuildContext)? onDelete;
  final double editThreshold;

  const ZakatTile({
    super.key,
    required this.currency,
    required this.zakat,
    required this.sessionYear,
    required this.remaining,
    this.onEdit,
    this.onDelete,
    this.editThreshold = 0.02,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: onDelete,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blueGrey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Session: $sessionYear',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Zakat: ${zakat.toStringAsFixed(2)} $currency',
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Remaining: ${remaining.toStringAsFixed(2)} $currency',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (remaining > editThreshold && onEdit != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: onEdit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[400],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
