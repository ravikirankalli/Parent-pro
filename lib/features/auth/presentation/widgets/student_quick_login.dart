import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

/// One child slot on the login screen.
///
/// A slot that has been used before shows the child's name and signs straight
/// in. An empty one shows "Add" and points the form at that slot.
class StudentQuickLogin extends StatelessWidget {
  const StudentQuickLogin({
    super.key,
    required this.label,
    required this.action,
    required this.color,
    required this.onTap,
    this.onLongPress,
    this.highlighted = false,
  });

  final String label;

  /// The small line under the name: "Log in", "Add" or "Entering...".
  final String action;
  final Color color;

  /// Null while a sign-in is already running, which disables the slot.
  final VoidCallback? onTap;

  /// Long press forgets a saved child.
  final VoidCallback? onLongPress;

  /// Marks the slot the login form is currently filling in.
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        decoration: highlighted
            ? BoxDecoration(
                color: color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.45)),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(
                action == 'Add' ? Icons.person_add_alt_1 : Icons.school,
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              action,
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
