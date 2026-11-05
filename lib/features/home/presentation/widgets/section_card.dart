import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';

/// White, shadowed container that groups a titled dashboard section.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.header,
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  final Widget header;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: AppDecorations.card(radius: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          header,
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

/// Section heading: an icon, a navy lead and a blue highlighted word, plus an
/// optional trailing widget (tagline or action).
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.lead,
    required this.highlight,
    this.trailing,
  });

  final IconData icon;
  final Color iconColor;
  final String lead;
  final String highlight;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = GoogleFonts.poppins(
      fontSize: 19,
      fontWeight: FontWeight.w700,
      color: AppColors.navy,
    );
    return Row(
      children: <Widget>[
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(width: 8),
        Flexible(
          flex: 3,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                style: base,
                children: <TextSpan>[
                  TextSpan(text: lead),
                  TextSpan(
                    text: highlight,
                    style: base.copyWith(color: AppColors.blue),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (trailing != null) ...<Widget>[
          const SizedBox(width: 8),
          Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(fit: BoxFit.scaleDown, child: trailing),
            ),
          ),
        ],
      ],
    );
  }
}

/// Handwritten-style tagline with gold separators and a gold underline,
/// e.g. "Stay Informed ✦ Stay Connected".
class SectionTagline extends StatelessWidget {
  const SectionTagline({super.key, required this.words});

  final List<String> words;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = GoogleFonts.caveat(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: AppColors.navy,
    );
    final List<Widget> parts = <Widget>[];
    for (int i = 0; i < words.length; i++) {
      if (i > 0) {
        parts.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text('✦', style: style.copyWith(color: AppColors.gold)),
        ));
      }
      parts.add(Text(words[i], style: style));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(mainAxisSize: MainAxisSize.min, children: parts),
        Container(
          width: 110,
          height: 1.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                AppColors.gold.withValues(alpha: 0),
                AppColors.gold,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
