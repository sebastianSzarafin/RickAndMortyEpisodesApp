import 'package:flutter/material.dart';

Widget getParameter(
    {required Map<String, dynamic>? character,
    required String p,
    String? def,
    double fontSize = 11}) {
  TextStyle parameterStyle = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontSize: fontSize,
  );

  def ??= p[0].toUpperCase() + p.substring(1);

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            '$def:',
            style: parameterStyle,
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(character?[p],
              textAlign: TextAlign.right, style: parameterStyle),
        )
      ],
    ),
  );
}
