import 'package:flutter/material.dart';
import '../models/photo_item.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Carte photo — cadre [width] en X, hauteur au plus juste (hug vertical), fond `TrottleDark`.
///
/// Image carrée [width × width], puis mot-clé + pays (padding H 12, V 8) ; like sur l’image.
class PhotoCard extends StatefulWidget {
  const PhotoCard({
    super.key,
    required this.item,
    this.width = 128,
    this.onLikeChanged,
    this.onImageTap,
  });

  final PhotoItem item;
  final double width;

  /// Callback optionnel déclenché quand l'utilisateur toggle le like.
  final ValueChanged<bool>? onLikeChanged;

  /// Callback optionnel déclenché quand l'utilisateur tape sur l'image.
  final VoidCallback? onImageTap;

  /// Rayon des coins du cadre extérieur.
  static const double frameBorderRadius = 20;

  /// Rayon des coins de la zone image.
  static const double imageBorderRadius = 14;

  /// Espace entre le bas de l’image et le bloc textes (0 = collé au padding du bloc).
  static const double imageToKeywordGap = 0;

  /// Padding horizontal du bloc textes (mot-clé + pays).
  static const double infoPaddingH = 6;

  /// Padding vertical du bloc textes (haut + bas du `Padding` infos).
  static const double infoPaddingV = 8;

  /// Hauteur réelle du stack mot-clé + pays :
  /// chip hashtagSmall (10pt + v:2 → ~14px) + ville (subTitleMedium 12pt → ~14px) = 28px.
  static const double _infoStackMinHeight = 34;

  /// Marge bas du cadre.
  static const double frameBottomExtra = 0;

  /// Hauteur verticale approximative (image carrée + gap + bloc infos + paddings + marge bas).
  /// Utile pour dimensionner un parent à hauteur fixe (ex. bandeau carrousel).
  static double intrinsicHeight(double width) =>
      width +
      imageToKeywordGap +
      infoPaddingV * 2 +
      _infoStackMinHeight +
      frameBottomExtra;

  /// Ombre sous l’image : Y=2, blur=4, opacité 50 %.
  static final List<BoxShadow> imageShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.5),
      offset: const Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  @override
  State<PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard> {
  late bool _liked;

  @override
  void initState() {
    super.initState();
    _liked = widget.item.liked;
  }

  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      widget.item.liked = _liked;
    });
    widget.onLikeChanged?.call(_liked);
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.width;

    return ClipRRect(
      borderRadius: BorderRadius.circular(PhotoCard.frameBorderRadius),
      child: Container(
        width: w,
        color: AppColors.trottleDark,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Image [w×w] + ombre + like ───────────────────────────────
            SizedBox(
              width: w,
              height: w,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(PhotoCard.imageBorderRadius),
                  boxShadow: PhotoCard.imageShadow,
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(PhotoCard.imageBorderRadius),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(color: AppColors.trottleDark),
                      // Image + zone de tap (sous le bouton like)
                      GestureDetector(
                        onTap: widget.onImageTap,
                        behavior: HitTestBehavior.opaque,
                        child: Image.asset(
                          widget.item.imageAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: AppColors.trottleDark),
                        ),
                      ),
                      Positioned(
                        right: 6,
                        bottom: 6,
                        child: GestureDetector(
                          onTap: _toggleLike,
                          behavior: HitTestBehavior.opaque,
                          child: Icon(
                            _liked ? Icons.favorite : Icons.favorite_border,
                            size: 22,
                            color: _liked
                                ? AppColors.trottleMain
                                : AppColors.trottleWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Infos : mot-clé + pays ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                PhotoCard.infoPaddingH,
                PhotoCard.infoPaddingV,
                PhotoCard.infoPaddingH,
                PhotoCard.infoPaddingV,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.trottleMain,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.item.hashtag,
                      style: AppTextStyles.hashtagSmall.copyWith(
                        color: AppColors.trottleWhite,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.item.flag.isEmpty
                        ? widget.item.city
                        : '${widget.item.flag} ${widget.item.city}',
                    style: AppTextStyles.subTitleMedium.copyWith(
                      color: AppColors.trottleWhite,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: PhotoCard.frameBottomExtra),
          ],
        ),
      ),
    );
  }
}
