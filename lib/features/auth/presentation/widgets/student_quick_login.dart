import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

/// A single student quick-login shortcut (avatar + label + "Log in" action).
class StudentQuickLogin extends StatelessWidget {
  const StudentQuickLogin({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(Icons.school, color: color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              'Log in',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color,
                decoration: TextDecoration.underline,
                decorationColor: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
