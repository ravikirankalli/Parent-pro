import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

/// One of the pale supporting slogans, with each word on its own line and a
/// short rule closing the block.
class StackedSlogan extends StatelessWidget {
  const StackedSlogan({
    super.key,
    required this.words,
    required this.alignment,
  });

  final List<String> words;
  final CrossAxisAlignment alignment;

  TextAlign get _textAlign => switch (alignment) {
        CrossAxisAlignment.end => TextAlign.right,
        CrossAxisAlignment.center => TextAlign.center,
        _ => TextAlign.left,
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignment,
      children: <Widget>[
        for (final String word in words)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              word,
              textAlign: _textAlign,
              style: GoogleFonts.montserrat(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.4,
                color: AppColors.sloganText,
              ),
            ),
          ),
        const SizedBox(height: 4),
        Container(width: 26, height: 2, color: AppColors.sloganDivider),
      ],
    );
  }
}
