import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../splash/presentation/widgets/brand_wordmark.dart';
import 'header_ribbon.dart';

/// Pinned dashboard header: brand ribbon, centered wordmark and the meal /
/// menu actions.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.onMealTap,
    required this.onMenuTap,
  });

  final VoidCallback onMealTap;
  final VoidCallback onMenuTap;

  /// Width reserved on both sides so the wordmark stays truly centered.
  static const double _sideWidth = 84;

  @override
  Widget build(BuildContext context) {
    final double top = MediaQuery.paddingOf(context).top;
    return Stack(
      children: <Widget>[
        const Positioned(left: 0, top: 0, child: HeaderRibbon()),
        Padding(
          padding: EdgeInsets.fromLTRB(14, top + 10, 10, 10),
          child: Row(
            children: <Widget>[
              const SizedBox(width: _sideWidth),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const BrandWordmark(fontSize: 30),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: _Tagline(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: _sideWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    _MealButton(onTap: onMealTap),
                    IconButton(
                      onPressed: onMenuTap,
                      icon: const Icon(Icons.menu_rounded, size: 28),
                      color: AppColors.navy,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Tagline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget line() => Container(width: 18, height: 1.5, color: AppColors.gold);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        line(),
        const SizedBox(width: 6),
        Text(
          AppStrings.splashTagline,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(width: 6),
        line(),
      ],
    );
  }
}

class _MealButton extends StatelessWidget {
  const _MealButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
        boxShadow: AppDecorations.cardShadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: const Icon(
            Icons.restaurant_rounded,
            size: 19,
            color: AppColors.navy,
          ),
        ),
      ),
    );
  }
}
