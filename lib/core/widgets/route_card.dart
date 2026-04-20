import 'package:flutter/material.dart';
import '../models/photo_item.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Carte parcours.
///
/// Hauteur auto selon le contenu : image (width × _imageRatio) + titre + infos.
class RouteCard extends StatefulWidget {
  const RouteCard({
    super.key,
    required this.item,
    this.width  = 192,
    this.price,
    this.onLikeChanged,
  });

  final PhotoItem item;
  final double    width;

  /// Prix affiché en bas-droite (ex. '€ 24,99'). Null = non affiché.
  final String?   price;

  /// Rapport hauteur/largeur de la zone image.
  static const double _imageRatio = 1.3;

  /// Callback optionnel déclenché quand l'utilisateur toggle le like.
  final ValueChanged<bool>? onLikeChanged;

  @override
  State<RouteCard> createState() => _RouteCardState();
}

class _RouteCardState extends State<RouteCard> {
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
    final imageH = widget.width * RouteCard._imageRatio;

    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // ── Photo portrait ────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width:  widget.width,
              height: imageH,
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
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: _toggleLike,
                      behavior: HitTestBehavior.opaque,
                      child: Icon(
                        _liked ? Icons.favorite : Icons.favorite_border,
                        size: 20,
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
          ),

          // ── Titre ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 4),
            child: Text(
              widget.item.hashtag,
              textAlign: TextAlign.center,
              style: AppTextStyles.subTitleBig.copyWith(
                color: AppColors.trottleWhite,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // ── Section infos ─────────────────────────────────────────────
          Container(
            color: AppColors.trottleDark,
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // Hashtag + ville
                Expanded(
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

                // Badge prix — droite
                if (widget.price != null) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 0),
                    decoration: BoxDecoration(
                      color: AppColors.trottleLightGray,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.price!,
                      style: AppTextStyles.info.copyWith(
                        color: AppColors.trottleOrange,
                        fontSize: 21,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

        ],
      ),
    );
  }
}
