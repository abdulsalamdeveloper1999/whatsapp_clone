import 'package:flutter/material.dart';

import '../../colors.dart';

class MyButton extends StatelessWidget {
  Function()? onTap;
  String text;
  double fontSize;
  Color textColor;
  MyButton({
    required this.onTap,
    required this.text,
    this.fontSize = 16.0,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14),
        width: double.infinity,
        decoration: BoxDecoration(
          color: tabColor,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
