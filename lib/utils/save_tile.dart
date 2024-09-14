// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SaveTile extends StatelessWidget {
  final String date;
  final double zakat;
  final String currency;
  final VoidCallback onEdit;
  final Function(BuildContext)? deleteFunction;

  const SaveTile({
    super.key,
    required this.date,
    required this.zakat,
    required this.currency,
    required this.onEdit,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.blueGrey[100],
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
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text('Zakat: ${zakat.toStringAsFixed(2)} $currency'),
                ],
              ),
              ElevatedButton(
                onPressed: onEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[200],
                ),
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.black,
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
