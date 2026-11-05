import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Shared surface styles: every dashboard card is plain white with a soft
/// navy-tinted shadow.
class AppDecorations {
  const AppDecorations._();

  static const double cardRadius = 18;

  static List<BoxShadow> get cardShadow => <BoxShadow>[
        BoxShadow(
          color: AppColors.navy.withValues(alpha: 0.08),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: AppColors.navy.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  static BoxDecoration card({double radius = cardRadius}) => BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: cardShadow,
      );
}
