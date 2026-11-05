import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../data/home_content.dart';
import 'arrow_circle.dart';

const double _tilePadding = 7;
const double _arrowSize = 24;
const double _arrowGap = 4;
const double _maxTitleSize = 12;

// letterSpacing is explicit so the theme's default spacing can't make the
// rendered title wider than the measured one.
TextStyle _titleStyle(double fontSize) => GoogleFonts.poppins(
      fontSize: fontSize,
      height: 1.2,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
      color: AppColors.navy,
    );

/// Three-column grid of white module tiles.
///
/// All tiles in a grid share one title size: the largest size at which every
/// word fits on a line, so titles wrap between words and never mid-word.
class FeatureGrid extends StatefulWidget {
  const FeatureGrid({
    super.key,
    required this.items,
    required this.onTap,
    this.childAspectRatio = 0.95,
    this.spacing = 12,
  });

  final List<HomeMenuItem> items;
  final ValueChanged<HomeMenuItem> onTap;
  final double childAspectRatio;
  final double spacing;

  @override
  State<FeatureGrid> createState() => _FeatureGridState();
}

class _FeatureGridState extends State<FeatureGrid> {
  @override
  void initState() {
    super.initState();
    // Titles are measured with the fallback font until Poppins is loaded.
    GoogleFonts.pendingFonts(<TextStyle>[_titleStyle(_maxTitleSize)]).then(
      (_) {
        if (mounted) setState(() {});
      },
    );
  }

  double _titleSize(double textWidth, TextScaler scaler) {
    double size = _maxTitleSize;
    for (final HomeMenuItem item in widget.items) {
      for (final String word in item.title.split(RegExp(r'\s+'))) {
        final TextPainter painter = TextPainter(
          text: TextSpan(text: word, style: _titleStyle(_maxTitleSize)),
          textDirection: TextDirection.ltr,
          textScaler: scaler,
          maxLines: 1,
        )..layout();
        if (painter.width > textWidth) {
          size = math.min(size, _maxTitleSize * textWidth / painter.width);
        }
        painter.dispose();
      }
    }
    // Small margin for sub-pixel rounding differences.
    return size * 0.99;
  }

  @override
  Widget build(BuildContext context) {
    final double spacing = widget.spacing;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double tileWidth = (constraints.maxWidth - 2 * spacing) / 3;
        final double textWidth =
            tileWidth - 2 * _tilePadding - _arrowGap - _arrowSize;
        final double titleSize =
            _titleSize(textWidth, MediaQuery.textScalerOf(context));

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: widget.childAspectRatio,
          ),
          itemCount: widget.items.length,
          itemBuilder: (BuildContext context, int index) {
            final HomeMenuItem item = widget.items[index];
            return FeatureTile(
              item: item,
              titleSize: titleSize,
              onTap: () => widget.onTap(item),
            );
          },
        );
      },
    );
  }
}

class FeatureTile extends StatelessWidget {
  const FeatureTile({
    super.key,
    required this.item,
    required this.onTap,
    this.titleSize = _maxTitleSize,
  });

  final HomeMenuItem item;
  final VoidCallback onTap;
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(16);
    return Container(
      decoration: AppDecorations.card(radius: 16),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(_tilePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Image.asset(item.asset, fit: BoxFit.contain),
                ),
                const SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: _titleStyle(titleSize),
                      ),
                    ),
                    const SizedBox(width: _arrowGap),
                    const ArrowCircle(size: _arrowSize),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
