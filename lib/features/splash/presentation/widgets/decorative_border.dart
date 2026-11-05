import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Curved blue / red / gold bands that frame the splash screen.
///
/// Drawn with vector paths so they stay sharp on every screen density.
class DecorativeBorder extends StatelessWidget {
  const DecorativeBorder({super.key, required this.alignment});

  /// Use [Alignment.topLeft] for the header band and [Alignment.bottomRight]
  /// for the footer band.
  final Alignment alignment;

  bool get _isTop => alignment.y < 0;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return IgnorePointer(
      child: SizedBox(
        width: width,
        height: width * 0.42,
        child: CustomPaint(painter: _BorderPainter(isTop: _isTop)),
      ),
    );
  }
}

class _BorderPainter extends CustomPainter {
  const _BorderPainter({required this.isTop});

  final bool isTop;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    if (!isTop) {
      canvas
        ..translate(size.width / 2, size.height / 2)
        ..rotate(3.14159265359)
        ..translate(-size.width / 2, -size.height / 2);
    }

    _drawBand(canvas, size, AppColors.blue, 0.72, 0.30);
    _drawBand(canvas, size, AppColors.red, 0.56, 0.22);
    _drawBand(canvas, size, AppColors.gold, 0.46, 0.165);

    canvas.restore();
  }

  /// Sweeps a band from the left edge toward the top-right corner.
  ///
  /// [endX] is the fraction of the width where the band meets the top edge and
  /// [startY] the fraction of the height where it leaves the left edge.
  void _drawBand(
    Canvas canvas,
    Size size,
    Color color,
    double endX,
    double startY,
  ) {
    final Path path = Path()
      ..moveTo(0, size.height * startY)
      ..quadraticBezierTo(
        size.width * endX * 0.42,
        size.height * startY * 0.72,
        size.width * endX,
        0,
      )
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_BorderPainter oldDelegate) => oldDelegate.isTop != isTop;
}
