import 'package:fitsy/presentation/themes/material_theme.dart';
import 'package:flutter/material.dart';

class WarningWidget extends StatelessWidget {
  final String message;
  final bool isShown;

  const WarningWidget({
    super.key,
    required this.message,
    required this.isShown,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: SizedBox(
          height: 60, // fixed height
          child: isShown
              ? Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.olive,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : null,
        ));
  }
}
