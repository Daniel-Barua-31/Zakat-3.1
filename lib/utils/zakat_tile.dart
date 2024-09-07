import 'package:flutter/material.dart';

class ZakatTile extends StatelessWidget {
  final String sessionYear;
  final double zakat;
  final String currency;
  final double remaining;
  final VoidCallback? onEdit;
  final double editThreshold;

  const ZakatTile({
    Key? key,
    required this.currency,
    required this.zakat,
    required this.sessionYear,
    required this.remaining,
    this.onEdit,
    this.editThreshold = 0.02,
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
                  'Session: $sessionYear',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                    'Zakat: ${zakat.toStringAsFixed(2)} $currency, Ramaining: ${remaining.toStringAsFixed(2)} $currency'),
              ],
            ),
            if (remaining > editThreshold && onEdit != null)
              ElevatedButton(
                onPressed: onEdit,
                child: Text('Edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
    ;
  }
}
