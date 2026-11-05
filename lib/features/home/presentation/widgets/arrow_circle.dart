import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Small filled blue circle with a chevron.
class ArrowCircle extends StatelessWidget {
  const ArrowCircle({
    super.key,
    this.color = AppColors.tileBlue,
    this.size = 26,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color.lerp(color, AppColors.white, 0.25)!, color],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.chevron_right_rounded,
        color: AppColors.white,
        size: size * 0.8,
      ),
    );
  }
}
