import '../../../core/constants/app_assets.dart';

class HomeMenuItem {
  const HomeMenuItem({required this.title, required this.asset});

  final String title;
  final String asset;
}

class StudentProfile {
  const StudentProfile({
    required this.name,
    required this.className,
    required this.rollNo,
    required this.avatar,
  });

  final String name;
  final String className;
  final String rollNo;
  final String avatar;
}

class TimetableSlot {
  const TimetableSlot({
    required this.subject,
    required this.activity,
    required this.lesson,
    required this.timeRange,
    required this.progress,
  });

  final String subject;
  final String activity;
  final String lesson;
  final String timeRange;

  /// Fraction of the period elapsed, from 0 to 1.
  final double progress;
}

class GalleryItem {
  const GalleryItem({required this.asset, this.duration});

  final String asset;

  /// Set for videos only, e.g. `01:24`.
  final String? duration;

  bool get isVideo => duration != null;
}

/// Sample dashboard content until the ParentPro API is wired in.
class HomeContent {
  const HomeContent._();

  static const StudentProfile student = StudentProfile(
    name: 'Sundar Kumar Nallamothu',
    className: '6 - A',
    rollNo: '1',
    avatar: AppAssets.studentAvatar,
  );

  static const TimetableSlot currentSlot = TimetableSlot(
    subject: 'Telugu',
    activity: 'Reading & Explanation',
    lesson: '1. Our Country – India',
    timeRange: '09:00 AM – 09:45 AM',
    progress: 0.65,
  );

  static const List<HomeMenuItem> modules = <HomeMenuItem>[
    HomeMenuItem(title: 'Attendance', asset: AppAssets.attendance),
    HomeMenuItem(title: 'Homework', asset: AppAssets.homework),
    HomeMenuItem(title: 'Leave Letter', asset: AppAssets.leaveLetter),
    HomeMenuItem(title: 'Test & Exam', asset: AppAssets.testExam),
    HomeMenuItem(title: 'Notice Board', asset: AppAssets.noticeBoard),
    HomeMenuItem(title: 'Fitness', asset: AppAssets.fitness),
    HomeMenuItem(title: 'Sports', asset: AppAssets.sports),
    HomeMenuItem(title: 'Social Arts', asset: AppAssets.socialArts),
    HomeMenuItem(title: 'Daily Life', asset: AppAssets.dailyLife),
  ];

  static const List<HomeMenuItem> aiReports = <HomeMenuItem>[
    HomeMenuItem(
      title: 'AI review of academic performance of student',
      asset: AppAssets.aiAcademic,
    ),
    HomeMenuItem(
      title: "Student's learning ability",
      asset: AppAssets.aiLearning,
    ),
    HomeMenuItem(
      title: "Student's physical fitness and growth rate",
      asset: AppAssets.aiFitness,
    ),
    HomeMenuItem(
      title: "Assessment of student's creativity",
      asset: AppAssets.aiCreativity,
    ),
  ];

  static const List<HomeMenuItem> parentUpdates = <HomeMenuItem>[
    HomeMenuItem(title: 'General\nHealth', asset: AppAssets.generalHealth),
    HomeMenuItem(title: 'Competitions', asset: AppAssets.competitions),
    HomeMenuItem(title: 'Remarks', asset: AppAssets.remarks),
    HomeMenuItem(title: 'About\nSchool', asset: AppAssets.aboutSchool),
    HomeMenuItem(title: 'School\nJournal', asset: AppAssets.schoolJournal),
    HomeMenuItem(title: 'School\nFees', asset: AppAssets.schoolFees),
  ];

  static const List<GalleryItem> photos = <GalleryItem>[
    GalleryItem(asset: AppAssets.schoolLandscape),
    GalleryItem(asset: AppAssets.loginHero),
    GalleryItem(asset: AppAssets.familyStudy),
    GalleryItem(asset: AppAssets.schoolLandscape),
    GalleryItem(asset: AppAssets.loginHero),
  ];

  static const List<GalleryItem> videos = <GalleryItem>[
    GalleryItem(asset: AppAssets.loginHero, duration: '01:24'),
    GalleryItem(asset: AppAssets.familyStudy, duration: '02:15'),
    GalleryItem(asset: AppAssets.schoolLandscape, duration: '01:50'),
    GalleryItem(asset: AppAssets.loginHero, duration: '03:10'),
    GalleryItem(asset: AppAssets.familyStudy, duration: '01:40'),
  ];
}
