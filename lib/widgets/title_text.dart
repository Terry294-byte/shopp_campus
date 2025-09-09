import 'package:flutter/material.dart';

class TitleTextWidget extends StatelessWidget {
  final String label;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextDecoration? textDecoration;

  const TitleTextWidget({
    Key? key,
    required this.label,
    this.fontSize = 24,
    this.fontWeight = FontWeight.bold,
    this.color = Colors.black,
    this.textDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: textDecoration,
      ),
    );
  }
}
