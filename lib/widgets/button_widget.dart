import 'package:flutter/material.dart';

import '../colors.dart';

class ButtonWidget extends StatelessWidget {
  final String label;
  final Color? bgcolor;
  final Color? textColor;
  final Color? borderColor;
  const ButtonWidget(
      {super.key,
      required this.label,
      this.bgcolor,
      this.textColor,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.00,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? Colors.transparent),
        color: bgcolor ?? primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: textColor ?? whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
