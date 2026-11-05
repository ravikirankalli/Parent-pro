import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import 'widgets/brand_wordmark.dart';
import 'widgets/decorative_border.dart';
import 'widgets/gold_divider_text.dart';
import 'widgets/stacked_slogan.dart';

/// Branded entry screen, shown for [_splashDuration] before the login screen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _splashDuration = Duration(milliseconds: 2800);

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _timer = Timer(_splashDuration, _goToLogin);
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _buildBackgroundLandscape(size),
          const Align(
            alignment: Alignment.topLeft,
            child: DecorativeBorder(alignment: Alignment.topLeft),
          ),
          const Align(
            alignment: Alignment.bottomRight,
            child: DecorativeBorder(alignment: Alignment.bottomRight),
          ),
          SafeArea(child: _buildContent(size)),
        ],
      ),
    );
  }

  /// The faded school landscape occupying the lower half of the canvas.
  Widget _buildBackgroundLandscape(Size size) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: size.height * 0.05,
      child: Opacity(
        opacity: 0.55,
        child: Image.asset(
          AppAssets.schoolLandscape,
          fit: BoxFit.contain,
          width: size.width,
        ),
      ),
    );
  }

  Widget _buildContent(Size size) {
    final double horizontalPadding = size.width * 0.07;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: <Widget>[
          SizedBox(height: size.height * 0.05),
          _buildTopSlogans(size),
          const Spacer(flex: 2),
          FadeTransition(
            opacity: _fade,
            child: ScaleTransition(scale: _scale, child: _buildBrandUnit(size)),
          ),
          const Spacer(flex: 2),
          Align(
            alignment: Alignment.centerRight,
            child: FadeTransition(
              opacity: _fade,
              child: const StackedSlogan(
                words: AppStrings.rightSlogan,
                alignment: CrossAxisAlignment.end,
              ),
            ),
          ),
          const Spacer(flex: 3),
          _buildTrustBranding(),
          SizedBox(height: size.height * 0.04),
        ],
      ),
    );
  }

  Widget _buildTopSlogans(Size size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const StackedSlogan(
          words: AppStrings.leftSlogan,
          alignment: CrossAxisAlignment.start,
        ),
        const Spacer(),
        SizedBox(
          width: size.width * 0.3,
          child: Text(
            AppStrings.handwrittenSlogan,
            textAlign: TextAlign.right,
            style: GoogleFonts.caveat(
              fontSize: 26,
              height: 1.15,
              fontWeight: FontWeight.w600,
              color: AppColors.sloganText,
            ),
          ),
        ),
      ],
    );
  }

  /// Family illustration, wordmark and tagline treated as one centered unit.
  Widget _buildBrandUnit(Size size) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Image.asset(
          AppAssets.familyStudy,
          width: size.width * 0.78,
          fit: BoxFit.contain,
        ),
        SizedBox(height: size.height * 0.006),
        BrandWordmark(fontSize: size.width * 0.12),
        const SizedBox(height: 8),
        GoldDividerText(
          text: AppStrings.splashTagline,
          style: GoogleFonts.poppins(
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.w500,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }

  Widget _buildTrustBranding() {
    return FadeTransition(
      opacity: _fade,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            AppStrings.fromLabel,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            AppStrings.trustName,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}
