import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  Color? color;
  double? size;
  double? letterSpace;
  FontWeight? fontWeight;

  MyText({required this.text, this.color, this.size, this.letterSpace, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size ??= 20,
          letterSpacing: letterSpace ??= 1.2,
          fontFamily: 'AveriaSerifLibre',
          color: color ??= Colors.white,
          fontWeight: fontWeight ??= FontWeight.w400),
    );
  }
}
