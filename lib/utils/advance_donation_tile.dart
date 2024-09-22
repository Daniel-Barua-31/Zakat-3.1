import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AdvanceDonationTile extends StatelessWidget {
  final String sessionYear;
  final double totalAmount;
  final String currency;
  final String date;
  final VoidCallback? onEdit;
  final Function(BuildContext)? onDelete;

  const AdvanceDonationTile({
    super.key,
    required this.sessionYear,
    required this.totalAmount,
    required this.currency,
    required this.date,
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
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Future Session: $sessionYear',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Amount: ${totalAmount.toStringAsFixed(2)} $currency',
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                'Date: $date',
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: onEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
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
