import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../data/home_content.dart';
import 'arrow_circle.dart';
import 'section_card.dart';

/// Collapsible list of AI-generated reports on the student.
class AiReportSection extends StatefulWidget {
  const AiReportSection({super.key, required this.items, required this.onTap});

  final List<HomeMenuItem> items;
  final ValueChanged<HomeMenuItem> onTap;

  @override
  State<AiReportSection> createState() => _AiReportSectionState();
}

class _AiReportSectionState extends State<AiReportSection> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      header: SectionTitle(
        icon: Icons.insights_rounded,
        iconColor: AppColors.tileOrange,
        lead: AppStrings.aiReportLead,
        highlight: AppStrings.aiReportHighlight,
        trailing: _ToggleButton(
          expanded: _expanded,
          onTap: () => setState(() => _expanded = !_expanded),
        ),
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: _expanded
            ? Column(
                children: <Widget>[
                  for (final HomeMenuItem item in widget.items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ReportTile(
                        item: item,
                        onTap: () => widget.onTap(item),
                      ),
                    ),
                ],
              )
            : const SizedBox(width: double.infinity),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({required this.expanded, required this.onTap});

  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.navy, width: 1.5),
        ),
        child: AnimatedRotation(
          turns: expanded ? 0 : -0.25,
          duration: const Duration(milliseconds: 250),
          child: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.navy,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({required this.item, required this.onTap});

  final HomeMenuItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      decoration: AppDecorations.card(radius: 16),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 120,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(item.asset, fit: BoxFit.contain),
                ),
              ),
              Container(
                width: 1.5,
                height: 44,
                color: AppColors.tileBlue.withValues(alpha: 0.35),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const ArrowCircle(size: 30),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
