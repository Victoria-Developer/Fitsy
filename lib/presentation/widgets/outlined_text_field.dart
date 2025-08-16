import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OutlinedTextField extends StatelessWidget {
  const OutlinedTextField({
    super.key,
    this.initialValue = "",
    this.inputFormatters = const [],
    this.onEdit,
  });

  final String initialValue;
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
        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.white), // or any color
        ),
      ),
    );
  }
}
