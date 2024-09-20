import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ZakatTile extends StatelessWidget {
  final String sessionYear;
  final double zakat;
  final String currency;
  final double remaining;
  final double advance;
  final VoidCallback? onEdit;
  final Function(BuildContext)? onDelete;

  const ZakatTile({
    super.key,
    required this.currency,
    required this.zakat,
    required this.sessionYear,
    required this.remaining,
    required this.advance,
    this.onEdit,
    this.onDelete,
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
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // 'Remaining: ${remaining.toStringAsFixed(2)} $currency',
                    'Remaining: ${remaining > 0 ? remaining.toStringAsFixed(2) : '0.00'} $currency',
                    style: const TextStyle(color: Colors.black),
                  ),
                  Text(
                    'Advance: ${advance.toStringAsFixed(2)} $currency',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // if (onEdit != null)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: onEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[400],
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
