import 'package:flutter/material.dart';

class SymptomTile extends StatelessWidget {
  final String symptom;
  final VoidCallback? onDelete;

  const SymptomTile({super.key, required this.symptom, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(symptom),
      deleteIcon: Icon(Icons.close),
      onDeleted: onDelete,
      backgroundColor: Colors.green.shade100,
    );
  }
}
