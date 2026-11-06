import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../auth/data/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../data/home_content.dart';
import 'widgets/ai_report_section.dart';
import 'widgets/feature_grid.dart';
import 'widgets/home_header.dart';
import 'widgets/parent_updates_section.dart';
import 'widgets/school_gallery_section.dart';
import 'widgets/student_overview.dart';

/// Parent dashboard shown after login.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _studentName;

  @override
  void initState() {
    super.initState();
    AuthService.activeStudentName().then((name) {
      if (mounted) setState(() => _studentName = name);
    });
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'You will be returned to the login screen. Your saved students stay '
          'on this device, so you can tap straight back in.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await AuthService().logout();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  }

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
        key: _scaffoldKey,
        backgroundColor: AppColors.scaffold,
        endDrawer: _buildMenuDrawer(),
        body: Column(
          children: <Widget>[
            HomeHeader(
              onMealTap: () => _comingSoon(context, 'Meal menu'),
              onMenuTap: () => _scaffoldKey.currentState?.openEndDrawer(),
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

  Widget _buildMenuDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(color: AppColors.navy),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.school, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _studentName?.isNotEmpty == true
                          ? _studentName!
                          : 'Parent Pro',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      'Signed in as student',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz, color: AppColors.navy),
              title: const Text('Switch student'),
              subtitle: const Text('Go back and pick another child'),
              onTap: () {
                Navigator.of(context).pop();
                _logout();
              },
            ),
            const Spacer(),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.red),
              title: const Text(
                'Log out',
                style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _logout();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
