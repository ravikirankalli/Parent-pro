import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';

/// The "ParentPro" wordmark: a single baseline with "Parent" in blue and
/// "Pro" in red.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, required this.fontSize});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      letterSpacing: -fontSize * 0.02,
      height: 1.05,
    );

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: RichText(
        text: TextSpan(
          style: base,
          children: <TextSpan>[
            TextSpan(
              text: AppStrings.brandFirst,
              style: base.copyWith(color: AppColors.blue),
            ),
            TextSpan(
              text: AppStrings.brandSecond,
              style: base.copyWith(color: AppColors.red),
            ),
          ],
        ),
      ),
    );
  }
}
