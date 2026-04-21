import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/app_localizations.dart';
import '../nav/route_screen.dart';

/// Popup de recherche par mot-clé.
class SearchPopup extends StatefulWidget {
  const SearchPopup({super.key, this.onClose});

  final VoidCallback? onClose;

  @override
  State<SearchPopup> createState() => _SearchPopupState();
}

class _SearchPopupState extends State<SearchPopup> {
  final _ctrl     = TextEditingController();
  final _cityCtrl = TextEditingController();
  String _location = 'around';

  @override
  void dispose() {
    _ctrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  void _goToRoute() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const RouteScreen(),
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    final cats = [
      _Cat(l.txtSearchLast,    AppColors.trottleMain, null),
      _Cat(l.txtSearchRoute,   AppColors.trottleMain, _goToRoute),
      _Cat('Incontournable',   AppColors.trottleMain, null),
      _Cat('Monument',         AppColors.trottleMain, null),
      _Cat('Randonnée',        AppColors.trottleMain, null),
      _Cat('Statue',           AppColors.trottleMain, null),
      _Cat('Street Art',       AppColors.trottleMain, null),
    ];

    final locOptions = [
      (key: 'around', label: l.txtSearchAroundMe),
      (key: 'city',   label: l.txtSearchCity),
      (key: 'world',  label: l.txtSearchWorld),
    ];
    final selIndex = locOptions.indexWhere((o) => o.key == _location);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          gradient: AppDecorations.trottleStroke,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: AppColors.trottleBgDark.withValues(alpha: 0.95),
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  // ── Barre de recherche principale ─────────────────────
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.trottleDark.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.search,
                            color: AppColors.trottleWhite, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _ctrl,
                            style: AppTextStyles.text
                                .copyWith(color: AppColors.trottleWhite),
                            cursorColor: AppColors.trottleMain,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isCollapsed: true,
                              hintText: l.txtSearch,
                              hintStyle: AppTextStyles.text
                                  .copyWith(color: AppColors.trottleWhite),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onClose,
                          behavior: HitTestBehavior.opaque,
                          child: const Icon(Icons.close,
                              color: AppColors.trottleWhite, size: 16),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Recommandations / + Plus d'options ────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l.txtSearchReco,
                          style: AppTextStyles.text
                              .copyWith(color: AppColors.trottleMain)),
                      Text(l.txtSearchOptions,
                          style: AppTextStyles.text
                              .copyWith(color: AppColors.trottleMain)),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Chips catégories — taille 14, centrées ────────────
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: cats.map((cat) => GestureDetector(
                      onTap: cat.onTap,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: cat.color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          cat.label,
                          style: AppTextStyles.hashtagSmall.copyWith(
                            color: AppColors.trottleWhite,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )).toList(),
                  ),

                  const SizedBox(height: 16),

                  // ── Sélecteur localisation — 3/4 de largeur, centré ───
                  LayoutBuilder(builder: (context, constraints) {
                    final barW = constraints.maxWidth * 0.75 + 20;
                    return Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: barW,
                        child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          // Cartouche trottleDark avec indicateur glissant
                          LayoutBuilder(builder: (context, constraints) {
                            final totalW = constraints.maxWidth;
                            final chipW  = totalW / locOptions.length;
                            const barH   = 30.0;
                            const radius = 15.0;

                            return Container(
                              height: barH,
                              decoration: BoxDecoration(
                                color: AppColors.trottleDark,
                                borderRadius: BorderRadius.circular(radius),
                              ),
                              child: Stack(
                                children: [
                                  // Indicateur glissant easeInOut
                                  AnimatedPositioned(
                                    duration:
                                        const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                    left:   selIndex * chipW,
                                    top:    0,
                                    width:  chipW,
                                    height: barH,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.trottleMidGray,
                                        borderRadius:
                                            BorderRadius.circular(radius),
                                      ),
                                    ),
                                  ),
                                  // Labels
                                  Row(
                                    children: locOptions.map((opt) {
                                      final isOn = _location == opt.key;
                                      return Expanded(
                                        child: GestureDetector(
                                          onTap: () => setState(
                                              () => _location = opt.key),
                                          behavior:
                                              HitTestBehavior.opaque,
                                          child: Center(
                                            child: Text(
                                              opt.label,
                                              style: AppTextStyles.text
                                                  .copyWith(
                                                color: isOn
                                                    ? AppColors.trottleWhite
                                                    : AppColors.trottleMain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            );
                          }),

                          // ── Barre ville — apparaît si "Ville" sélectionné
                          AnimatedSize(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            child: _location == 'city'
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Container(
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: AppColors.trottleDark
                                            .withValues(alpha: 0.6),
                                        borderRadius:
                                            BorderRadius.circular(18),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.search,
                                              color:
                                                  AppColors.trottleWhite,
                                              size: 16),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: TextField(
                                              controller: _cityCtrl,
                                              style: AppTextStyles.text
                                                  .copyWith(
                                                      color: AppColors
                                                          .trottleWhite),
                                              cursorColor:
                                                  AppColors.trottleMain,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                isCollapsed: true,
                                                hintText: l.txtSearchCity,
                                                hintStyle: AppTextStyles
                                                    .text
                                                    .copyWith(
                                                        color: AppColors
                                                            .trottleWhite),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Données catégorie ─────────────────────────────────────────────────────────

class _Cat {
  const _Cat(this.label, this.color, this.onTap);
  final String        label;
  final Color         color;
  final VoidCallback? onTap;
}
