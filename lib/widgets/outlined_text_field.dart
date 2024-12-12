import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OutlinedTextField extends StatelessWidget {
  const OutlinedTextField({
    super.key,
    this.initialValue = "",
    this.hintText = "",
    this.inputFormatters = const [],
    this.onEdit,
  });

  final String initialValue;
  final String hintText;
  final List<TextInputFormatter> inputFormatters;

  final void Function(String)? onEdit;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: (text) {
        onEdit!(text);
      },
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
          hintStyle:
              TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold)),
    );
  }
}


