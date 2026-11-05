import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../data/home_content.dart';
import 'widgets/ai_report_section.dart';
import 'widgets/feature_grid.dart';
import 'widgets/home_header.dart';
import 'widgets/parent_updates_section.dart';
import 'widgets/school_gallery_section.dart';
import 'widgets/student_overview.dart';

/// Parent dashboard shown after login.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _comingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            '${title.replaceAll('\n', ' ')} ${AppStrings.comingSoon}',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    void openItem(HomeMenuItem item) => _comingSoon(context, item.title);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.scaffold,
        body: Column(
          children: <Widget>[
            HomeHeader(
              onMealTap: () => _comingSoon(context, 'Meal menu'),
              onMenuTap: () => _comingSoon(context, 'Menu'),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  24 + MediaQuery.paddingOf(context).bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    StudentCard(
                      student: HomeContent.student,
                      onTap: () => _comingSoon(context, 'Student profile'),
                    ),
                    const SizedBox(height: 12),
                    TimetableCard(
                      slot: HomeContent.currentSlot,
                      onTap: () =>
                          _comingSoon(context, AppStrings.classTimetable),
                    ),
                    const SizedBox(height: 16),
                    FeatureGrid(
                      items: HomeContent.modules,
                      onTap: openItem,
                    ),
                    const SizedBox(height: 20),
                    AiReportSection(
                      items: HomeContent.aiReports,
                      onTap: openItem,
                    ),
                    const SizedBox(height: 20),
                    ParentUpdatesSection(
                      items: HomeContent.parentUpdates,
                      onTap: openItem,
                    ),
                    const SizedBox(height: 20),
                    SchoolGallerySection(
                      photos: HomeContent.photos,
                      videos: HomeContent.videos,
                      onViewAll: (String label) => _comingSoon(context, label),
                      onItemTap: (_) => _comingSoon(context, 'Gallery viewer'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
