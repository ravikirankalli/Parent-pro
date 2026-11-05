import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/home_content.dart';
import 'section_card.dart';

class SchoolGallerySection extends StatelessWidget {
  const SchoolGallerySection({
    super.key,
    required this.photos,
    required this.videos,
    required this.onViewAll,
    required this.onItemTap,
  });

  final List<GalleryItem> photos;
  final List<GalleryItem> videos;
  final ValueChanged<String> onViewAll;
  final ValueChanged<GalleryItem> onItemTap;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      header: const SectionTitle(
        icon: Icons.photo_camera_rounded,
        iconColor: AppColors.blue,
        lead: AppStrings.galleryLead,
        highlight: AppStrings.galleryHighlight,
        trailing: SectionTagline(words: AppStrings.galleryTagline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _MediaStrip(
            label: AppStrings.photos,
            icon: Icons.photo_library_rounded,
            items: photos,
            onViewAll: () => onViewAll(AppStrings.photos),
            onItemTap: onItemTap,
          ),
          const SizedBox(height: 14),
          _MediaStrip(
            label: AppStrings.videos,
            icon: Icons.videocam_rounded,
            items: videos,
            onViewAll: () => onViewAll(AppStrings.videos),
            onItemTap: onItemTap,
          ),
        ],
      ),
    );
  }
}

class _MediaStrip extends StatefulWidget {
  const _MediaStrip({
    required this.label,
    required this.icon,
    required this.items,
    required this.onViewAll,
    required this.onItemTap,
  });

  final String label;
  final IconData icon;
  final List<GalleryItem> items;
  final VoidCallback onViewAll;
  final ValueChanged<GalleryItem> onItemTap;

  @override
  State<_MediaStrip> createState() => _MediaStripState();
}

class _MediaStripState extends State<_MediaStrip> {
  final ScrollController _controller = ScrollController();
  bool _canScrollBack = false;
  bool _canScrollForward = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateArrows);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateArrows());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateArrows() {
    if (!mounted || !_controller.hasClients) return;
    final ScrollPosition position = _controller.position;
    final bool back = position.pixels > position.minScrollExtent + 1;
    final bool forward = position.pixels < position.maxScrollExtent - 1;
    if (back != _canScrollBack || forward != _canScrollForward) {
      setState(() {
        _canScrollBack = back;
        _canScrollForward = forward;
      });
    }
  }

  void _scrollBy(double delta) {
    if (!_controller.hasClients) return;
    final ScrollPosition position = _controller.position;
    _controller.animateTo(
      (position.pixels + delta).clamp(0.0, position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(widget.icon, color: AppColors.blue, size: 20),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                widget.label,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: widget.onViewAll,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      AppStrings.viewAll,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blue,
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded,
                        size: 22, color: AppColors.blue),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 84,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ListView.separated(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: widget.items.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (BuildContext context, int index) {
                  final GalleryItem item = widget.items[index];
                  return _Thumbnail(
                    item: item,
                    onTap: () => widget.onItemTap(item),
                  );
                },
              ),
              Positioned(
                left: 2,
                child: _ScrollArrow(
                  icon: Icons.chevron_left_rounded,
                  visible: _canScrollBack,
                  onTap: () => _scrollBy(-200),
                ),
              ),
              Positioned(
                right: 2,
                child: _ScrollArrow(
                  icon: Icons.chevron_right_rounded,
                  visible: _canScrollForward,
                  onTap: () => _scrollBy(200),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.item, required this.onTap});

  final GalleryItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 96,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset(item.asset, fit: BoxFit.cover),
              if (item.isVideo) ...<Widget>[
                Center(
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.45),
                      border: Border.all(color: AppColors.white, width: 1.5),
                    ),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: AppColors.white, size: 20),
                  ),
                ),
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.duration!,
                      style: GoogleFonts.poppins(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Minimal white round scroll button; fades out at the end of the strip.
class _ScrollArrow extends StatelessWidget {
  const _ScrollArrow({
    required this.icon,
    required this.visible,
    required this.onTap,
  });

  final IconData icon;
  final bool visible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: Icon(icon, color: AppColors.navy, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}
