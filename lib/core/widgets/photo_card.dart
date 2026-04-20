import 'package:flutter/material.dart';
import '../models/photo_item.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Carte photo réutilisable.
///
/// Layout : photo carrée [width × width] en haut,
/// section infos (hashtag + ville + like) en bas.
/// Hauteur totale = [width] + [infoHeight].
class PhotoCard extends StatefulWidget {
  const PhotoCard({
    super.key,
    required this.item,
    this.width = 120,
    this.onLikeChanged,
  });

  final PhotoItem item;
  final double width;

  /// Callback optionnel déclenché quand l'utilisateur toggle le like.
  final ValueChanged<bool>? onLikeChanged;

  /// Hauteur fixe de la section infos sous la photo.
  static const double infoHeight = 52.0;

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
    return SizedBox(
      width: widget.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // ── Photo carrée ─────────────────────────────────────────────
            SizedBox(
              width: widget.width,
              height: widget.width,
              child: Stack(
                fit: StackFit.expand,
                children: [

                  // Fond de secours
                  Container(color: AppColors.trottleDark),

                  // Image
                  Image.asset(
                    widget.item.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: AppColors.trottleDark),
                  ),

                  // Bouton Like — haut droite
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: _toggleLike,
                      behavior: HitTestBehavior.opaque,
                      child: Icon(
                        _liked ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: _liked
                            ? AppColors.trottleMain
                            : AppColors.trottleWhite,
                        shadows: const [
                          Shadow(color: Colors.black54, blurRadius: 4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Section infos ─────────────────────────────────────────────
            Container(
              height: PhotoCard.infoHeight,
              color: AppColors.trottleDark,
              padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // Cartouche hashtag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: AppColors.trottleMain,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      widget.item.hashtag,
                      style: AppTextStyles.hashtagSmall.copyWith(
                        color: AppColors.trottleWhite,
                      ),
                    ),
                  ),

                  const SizedBox(height: 3),

                  // Ville + drapeau
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

          ],
        ),
      ),
    );
  }
}
