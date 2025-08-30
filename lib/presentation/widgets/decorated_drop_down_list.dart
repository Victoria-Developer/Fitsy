import 'package:flutter/material.dart';

class DecoratedDropDownList<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final void Function(T) onChanged;
  final String Function(T) itemToString;

  const DecoratedDropDownList({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemToString,
  });

  @override
  Widget build(BuildContext context) {
    final mediumBodyTextTheme = Theme.of(context).textTheme.bodyMedium;

    return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.horizontal,
        spacing: 15,
        children: <Widget>[
          Text(label),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<T>(
              style: mediumBodyTextTheme,
              value: value,
              items: items.map<DropdownMenuItem<T>>((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    itemToString(item),
                    style: mediumBodyTextTheme,
                  ),
                );
              }).toList(),
              onChanged: (T? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
              dropdownColor: Colors.white,
              underline: const SizedBox.shrink(),
              iconEnabledColor: Colors.black,
            ),
          )
        ]);
  }
}
