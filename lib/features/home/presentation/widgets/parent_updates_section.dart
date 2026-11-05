import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/home_content.dart';
import 'feature_grid.dart';
import 'section_card.dart';

class ParentUpdatesSection extends StatelessWidget {
  const ParentUpdatesSection({
    super.key,
    required this.items,
    required this.onTap,
  });

  final List<HomeMenuItem> items;
  final ValueChanged<HomeMenuItem> onTap;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.fromLTRB(10, 14, 10, 12),
      header: const SectionTitle(
        icon: Icons.campaign_rounded,
        iconColor: AppColors.blue,
        lead: AppStrings.parentUpdatesLead,
        highlight: AppStrings.parentUpdatesHighlight,
        trailing: SectionTagline(words: AppStrings.parentUpdatesTagline),
      ),
      child: FeatureGrid(
        items: items,
        onTap: onTap,
        childAspectRatio: 0.88,
        spacing: 10,
      ),
    );
  }
}
