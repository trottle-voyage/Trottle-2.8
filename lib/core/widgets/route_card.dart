import 'package:flutter/material.dart';
import '../models/photo_item.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Carte parcours — cadre [width] (défaut 320), fond `TrottleDark`, hauteur au plus juste.
///
/// Image carrée [width × width] (ombre portée), titre centré blanc, cartouche mot-clé,
/// pays, prix optionnel, like en bas à droite sur l’image. Padding H 12 / V 6, gaps 6.
class RouteCard extends StatefulWidget {
  const RouteCard({
    super.key,
    required this.item,
    this.width = 320,
    this.price,
    this.onLikeChanged,
  });

  final PhotoItem item;
  final double width;

  /// Prix affiché sous le pays (ex. '€ 24,99'). Null = non affiché.
  final String? price;

  /// Callback optionnel déclenché quand l'utilisateur toggle le like.
  final ValueChanged<bool>? onLikeChanged;

  static const double frameBorderRadius = 20;
  static const double imageBorderRadius = 14;

  /// Espace entre le bas de l’image et le bloc texte (titre).
  static const double imageToTitleGap = 6;

  /// Padding du bloc titre + infos.
  static const double contentPaddingH = 12;
  static const double contentPaddingV = 6;

  /// Ombre sous l’image : Y=4, blur=4, opacité 50 %.
  static final List<BoxShadow> imageShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.5),
      offset: const Offset(0, 4),
      blurRadius: 4,
    ),
  ];

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

  String get _titleText =>
      widget.item.city.isNotEmpty ? widget.item.city : widget.item.hashtag;

  String get _countryLine => widget.item.flag.isEmpty
      ? widget.item.city
      : '${widget.item.flag} ${widget.item.city}';

  @override
  Widget build(BuildContext context) {
    final w = widget.width;

    return ClipRRect(
      borderRadius: BorderRadius.circular(RouteCard.frameBorderRadius),
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
                      BorderRadius.circular(RouteCard.imageBorderRadius),
                  boxShadow: RouteCard.imageShadow,
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(RouteCard.imageBorderRadius),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(color: AppColors.trottleDark),
                      Image.asset(
                        widget.item.imageAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: AppColors.trottleDark),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: GestureDetector(
                          onTap: _toggleLike,
                          behavior: HitTestBehavior.opaque,
                          child: Icon(
                            _liked ? Icons.favorite : Icons.favorite_border,
                            size: 26,
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

            const SizedBox(height: RouteCard.imageToTitleGap),

            // ── Titre + mot-clé + pays + prix ─────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                RouteCard.contentPaddingH,
                RouteCard.contentPaddingV,
                RouteCard.contentPaddingH,
                RouteCard.contentPaddingV,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _titleText,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.trottleWhite,
                      fontSize: 21,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
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
                            const SizedBox(height: 6),
                            Text(
                              _countryLine,
                              textAlign: TextAlign.left,
                              style: AppTextStyles.subTitleMedium.copyWith(
                                color: AppColors.trottleWhite,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (widget.price != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.trottleLightGray,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.price!,
                              style: AppTextStyles.info.copyWith(
                                color: AppColors.trottleOrange,
                                fontSize: 21,
                              ),
                            ),
                          ),
                        ),
                    ],
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
