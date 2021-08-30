import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget makeWidgetGradient({required Widget child}) {
  return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) => LinearGradient(
              colors: [Colors.green, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.topRight)
          .createShader(bounds),
      child: child);
}
