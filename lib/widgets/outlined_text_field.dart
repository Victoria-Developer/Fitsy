import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OutlinedTextField extends StatelessWidget {
  const OutlinedTextField({
    super.key,
    this.hintText = 'Hint',
    this.labelText = 'Label',
    this.inputFormatters = const [],
    this.onEdit,
  });

  final String hintText;
  final String labelText;
  final List<TextInputFormatter> inputFormatters;

  final void Function(String)? onEdit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) {
        onEdit!(text);
      },
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          hintText: hintText,
          hintStyle:
              TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold)),
    );
  }
}
