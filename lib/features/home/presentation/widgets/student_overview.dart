import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../data/home_content.dart';

/// Student identity card: avatar, name, class and roll number.
class StudentCard extends StatelessWidget {
  const StudentCard({super.key, required this.student, required this.onTap});

  final StudentProfile student;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextStyle meta = GoogleFonts.poppins(
      fontSize: 12.5,
      fontWeight: FontWeight.w500,
      color: AppColors.navy,
    );
    return Container(
      decoration: AppDecorations.card(radius: 20),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: <Widget>[
                _Avatar(asset: student.avatar),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        student.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.school_rounded,
                              size: 17, color: AppColors.navy),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${AppStrings.classLabel} : ${student.className}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: meta,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 16,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            color: AppColors.lightGrayBlue,
                          ),
                          const Icon(Icons.badge_rounded,
                              size: 17, color: AppColors.navy),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${AppStrings.rollNoLabel} : ${student.rollNo}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: meta,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.navy, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.navy,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      padding: const EdgeInsets.all(2.5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.paleGold, AppColors.gold],
        ),
      ),
      child: ClipOval(
        child: ColoredBox(
          color: AppColors.scaffold,
          child: Image.asset(asset, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

/// Today's running period: subject, activity, lesson and live progress.
class TimetableCard extends StatelessWidget {
  const TimetableCard({super.key, required this.slot, required this.onTap});

  final TimetableSlot slot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.card(radius: 20),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildHeader(),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(flex: 11, child: _buildDetails()),
                Container(
                  width: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: AppColors.divider,
                ),
                Expanded(
                  flex: 9,
                  child: _StatusPanel(progress: slot.progress, onTap: onTap),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: <Widget>[
        const Icon(Icons.calendar_month_rounded,
            color: AppColors.blue, size: 26),
        const SizedBox(width: 8),
        Text(
          AppStrings.today,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.navy,
          ),
        ),
        Container(
          width: 1,
          height: 20,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          color: AppColors.lightGrayBlue,
        ),
        Expanded(
          child: Text(
            AppStrings.classTimetable,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.blue.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.blue.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.schedule_rounded,
                      size: 15, color: AppColors.navy),
                  const SizedBox(width: 4),
                  Text(
                    slot.timeRange,
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _InfoRow(
          icon: Icons.menu_book_rounded,
          color: AppColors.tilePurple,
          label: AppStrings.subject,
          value: slot.subject,
        ),
        const _RowDivider(),
        _InfoRow(
          icon: Icons.description_rounded,
          color: AppColors.tileGreen,
          label: AppStrings.activity,
          value: slot.activity,
        ),
        const _RowDivider(),
        _InfoRow(
          icon: Icons.auto_stories_rounded,
          color: AppColors.tileOrange,
          label: AppStrings.lesson,
          value: slot.lesson,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color.lerp(color, AppColors.white, 0.2)!, color],
            ),
          ),
          child: Icon(icon, color: AppColors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  height: 1.2,
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 36),
      child: Divider(height: 12, thickness: 1, color: AppColors.divider),
    );
  }
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel({required this.progress, required this.onTap});

  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const Color green = AppColors.tileGreen;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Material(
          color: green.withValues(alpha: 0.06),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: green.withValues(alpha: 0.35)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 6, 10),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: green,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: green.withValues(alpha: 0.35),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: AppColors.white, size: 18),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                AppStrings.ongoing,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: green,
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded,
                                size: 18, color: green),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 6,
                                  color: green,
                                  backgroundColor:
                                      green.withValues(alpha: 0.15),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${(progress * 100).round()}%',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.navy,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          AppStrings.classInProgress,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
