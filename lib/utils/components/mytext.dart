import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final FontWeight? weight;
  final Color? color;
  var overflow;
  final size;
  var fontFamily;
  var align;

  MyText({
    this.fontFamily,
    super.key,
    this.overflow,
    this.align,
    required this.text,
    this.weight,
    this.color,
    this.size = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontWeight: weight,
        fontSize: size,
        fontFamily: fontFamily,
      ),
    );
  }
}
