import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'outlined_text_field.dart';

class NumericTextField extends StatefulWidget {
  final String label;
  final ValueChanged<int> onChanged;
  final String initialValue;

  const NumericTextField({
    super.key,
    required this.label,
    required this.onChanged,
    required this.initialValue,
  });

  @override
  State<NumericTextField> createState() => _NumericTextFieldState();
}

class _NumericTextFieldState extends State<NumericTextField> {
  late final TextEditingController controller;
  late final List<TextInputFormatter> inputFormatters;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
    inputFormatters = [FilteringTextInputFormatter.digitsOnly];
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Text(widget.label),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 80,
          child: OutlinedTextField(
            controller: controller,
            inputFormatters: inputFormatters,
            onEdit: (value) {
              if (value.isNotEmpty) {
                widget.onChanged(int.parse(value));
              }
            },
          ),
        ),
      ],
    );
  }
}