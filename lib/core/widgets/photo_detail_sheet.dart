import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/photo_item.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Affiche la fiche détail d'un [PhotoItem] en slide depuis le bas.
/// Le swipe horizontal sur l'image navigue dans [photos].
void showPhotoDetail(
  BuildContext context,
  List<PhotoItem> photos,
  int initialIndex,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (_) => PhotoDetailSheet(
      photos:       photos,
      initialIndex: initialIndex,
    ),
  );
}

class PhotoDetailSheet extends StatefulWidget {
  const PhotoDetailSheet({
    super.key,
    required this.photos,
    required this.initialIndex,
  });

  final List<PhotoItem> photos;
  final int             initialIndex;

  @override
  State<PhotoDetailSheet> createState() => _PhotoDetailSheetState();
}

class _PhotoDetailSheetState extends State<PhotoDetailSheet> {
  late final PageController _pageCtrl;
  late int _index;

  PhotoItem get _item => widget.photos[_index];

  @override
  void initState() {
    super.initState();
    _index   = widget.initialIndex;
    _pageCtrl = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() => _item.liked = !_item.liked);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          height: mq.size.height * 0.92,
          color: AppColors.trottleBgDark.withValues(alpha: 0.90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── Handle ─────────────────────────────────────────────────
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.trottleMidGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // ── Image swipeable ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: PageView.builder(
                      controller: _pageCtrl,
                      itemCount: widget.photos.length,
                      onPageChanged: (i) => setState(() => _index = i),
                      itemBuilder: (_, i) {
                        final photo = widget.photos[i];
                        return Image.asset(
                          photo.imageAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: AppColors.trottleDark),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // ── Titre centré ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                child: Text(
                  _item.resolvedTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subTitleBig.copyWith(
                    color: AppColors.trottleWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // ── Frame infos (gauche) + Frame icônes (droite) ───────────
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    // ── Infos — scrollable ──────────────────────────────
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(15, 0, 12, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // Mots-clés
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: _item.resolvedKeywords
                                  .map((kw) => Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.trottleMain,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          kw,
                                          style: AppTextStyles.hashtag
                                              .copyWith(
                                                  color: AppColors
                                                      .trottleWhite),
                                        ),
                                      ))
                                  .toList(),
                            ),

                            // Date
                            if (_item.dateLabel.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                _item.dateLabel,
                                style: AppTextStyles.subTitleMedium.copyWith(
                                  color: AppColors.trottleLightGray,
                                ),
                              ),
                            ],

                            // Ville
                            const SizedBox(height: 16),
                            _InfoRow(
                              icon: Icons.location_on_outlined,
                              label: _item.flag.isEmpty
                                  ? _item.city
                                  : '${_item.flag} ${_item.city}',
                            ),

                            // Utilisateur
                            if (_item.user.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              _InfoRow(
                                icon: Icons.person_outline,
                                label: _item.user,
                              ),
                            ],

                            // Description
                            if (_item.description.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.description_outlined,
                                    color: AppColors.trottleMidGray,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      _item.description,
                                      style: AppTextStyles.text.copyWith(
                                        color: AppColors.trottleWhite
                                            .withValues(alpha: 0.85),
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // ── Icônes — colonne fixe 44 px ─────────────────────
                    SizedBox(
                      width: 44,
                      child: Column(
                        children: [

                          const SizedBox(height: 4),

                          // Localisation
                          _SideIcon(
                            Icons.location_on_outlined,
                            onTap: () => Navigator.pop(context),
                          ),

                          const SizedBox(height: 40),

                          // Like
                          _SideIcon(
                            _item.liked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _item.liked
                                ? AppColors.trottleMain
                                : AppColors.trottleWhite,
                            onTap: _toggleLike,
                          ),
                          // Favoris
                          _SideIcon(
                            Icons.bookmark_add_outlined,
                            onTap: () {},
                          ),
                          // Partage
                          _SideIcon(
                            Icons.ios_share,
                            onTap: () {},
                          ),

                          const SizedBox(height: 40),

                          // Signalement
                          _SideIcon(
                            Icons.flag_outlined,
                            onTap: () {},
                          ),
                          // Modification
                          _SideIcon(
                            Icons.edit_outlined,
                            onTap: () {},
                          ),
                          // Suppression
                          _SideIcon(
                            Icons.delete_outline,
                            onTap: () {},
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Ligne info ────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String   label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.trottleMidGray, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.text.copyWith(color: AppColors.trottleWhite),
          ),
        ),
      ],
    );
  }
}

// ── Icône latérale ────────────────────────────────────────────────────────────

class _SideIcon extends StatelessWidget {
  const _SideIcon(
    this.icon, {
    this.color = AppColors.trottleWhite,
    this.onTap,
  });

  final IconData      icon;
  final Color         color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 44,
        height: 30,
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
