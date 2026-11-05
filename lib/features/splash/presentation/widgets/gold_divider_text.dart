import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A centered label flanked by two short gold rules.
class GoldDividerText extends StatelessWidget {
  const GoldDividerText({
    super.key,
    required this.text,
    required this.style,
    this.lineWidth = 28,
    this.lineColor = AppColors.gold,
  });

  final String text;
  final TextStyle style;
  final double lineWidth;
  final Color lineColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _line(),
        const SizedBox(width: 10),
        Flexible(
          child: Text(text, style: style, textAlign: TextAlign.center),
        ),
        const SizedBox(width: 10),
        _line(),
      ],
    );
  }

  Widget _line() => Container(width: lineWidth, height: 2, color: lineColor);
}
