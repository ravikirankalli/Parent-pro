import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Glossy blue / red / gold swoosh sweeping from the top-left corner of the
/// dashboard header.
class HeaderRibbon extends StatelessWidget {
  const HeaderRibbon({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return IgnorePointer(
      child: SizedBox(
        width: width * 0.55,
        height: width * 0.22,
        child: CustomPaint(painter: _RibbonPainter(screenWidth: width)),
      ),
    );
  }
}

class _RibbonPainter extends CustomPainter {
  const _RibbonPainter({required this.screenWidth});

  final double screenWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final double s = screenWidth;

    // Back to front; each band is the region between the corner and a curve
    // running from the left edge (leftY) to the top edge (topX).
    _band(
      canvas,
      leftY: 0.195 * s,
      topX: 0.52 * s,
      colors: const <Color>[
        AppColors.gold,
        AppColors.paleGold,
        AppColors.gold,
      ],
    );
    _band(
      canvas,
      leftY: 0.158 * s,
      topX: 0.44 * s,
      colors: const <Color>[AppColors.deepRed, AppColors.red, Color(0xFFE8394F)],
    );
    _band(
      canvas,
      leftY: 0.105 * s,
      topX: 0.37 * s,
      colors: const <Color>[
        AppColors.navy,
        AppColors.blue,
        AppColors.brightBlue,
      ],
    );

    // Thin highlight along the blue edge for the glossy look.
    final Paint gloss = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.white.withValues(alpha: 0.55);
    canvas.drawPath(_edge(0.105 * s, 0.37 * s), gloss);
  }

  Path _edge(double leftY, double topX) {
    return Path()
      ..moveTo(0, leftY)
      ..quadraticBezierTo(topX * 0.42, leftY * 0.62, topX, 0);
  }

  void _band(
    Canvas canvas, {
    required double leftY,
    required double topX,
    required List<Color> colors,
  }) {
    final Path path = _edge(leftY, topX)
      ..lineTo(0, 0)
      ..close();
    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: colors,
      ).createShader(Rect.fromLTWH(0, 0, topX, leftY));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_RibbonPainter oldDelegate) =>
      oldDelegate.screenWidth != screenWidth;
}
