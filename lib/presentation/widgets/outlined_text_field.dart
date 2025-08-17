import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OutlinedTextField extends StatelessWidget {
  const OutlinedTextField(
      {super.key,
      this.inputFormatters = const [],
      this.onEdit,
      this.controller});

  final List<TextInputFormatter> inputFormatters;

  final void Function(String)? onEdit;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
