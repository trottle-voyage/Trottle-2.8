import 'package:flutter/material.dart';
import '../../core/models/photo_item.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/back_arrow_bar.dart';
import '../../core/widgets/route_card.dart';
import '../../l10n/app_localizations.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  static const double _avatarSize = 64;

  // ── Données de test parcours ─────────────────────────────────────────────
  static final _testRoutes = [
    (item: PhotoItem(imageAsset: 'assets/photos/img_01.webp', hashtag: 'Randonnée', city: 'Dagobah',   flag: '🌿'), price: '€ 12,99'),
    (item: PhotoItem(imageAsset: 'assets/photos/img_03.webp', hashtag: 'Vélo',      city: 'Tatooine',  flag: '☀️'), price: '€ 24,99'),
    (item: PhotoItem(imageAsset: 'assets/photos/img_05.webp', hashtag: 'Moto',      city: 'Naboo',     flag: '💧'), price: '€ 9,99'),
    (item: PhotoItem(imageAsset: 'assets/photos/img_07.webp', hashtag: 'Trek',      city: 'Corellia',  flag: '🚀'), price: 'Gratuit'),
  ];

  @override
  Widget build(BuildContext context) {
    final l           = AppLocalizations.of(context)!;
    final textStyle   = AppTextStyles.text.copyWith(color: AppColors.trottleWhite);
    final saluteStyle = AppTextStyles.subTitleBig.copyWith(color: AppColors.trottleWhite);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: AppDecorations.bgGradient,
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ══ PARTIE FIXE ═══════════════════════════════════════════════

              const BackArrowBar(),

              // ── Titre ────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Text(
                  l.txtRoute,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title.copyWith(color: AppColors.trottleWhite),
                ),
              ),

              // ── Bloc pp + salutation ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: _avatarSize,
                      height: _avatarSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1,
                          color: AppColors.trottleMain.withValues(alpha: 0.4),
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/pp.webp',
                          width: _avatarSize,
                          height: _avatarSize,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${l.txtRouteSalute}${l.txtProfileUser}', style: saluteStyle),
                          const SizedBox(height: 4),
                          Text(l.txtRouteQuestion, style: textStyle),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Stroke délimiteur ────────────────────────────────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 0.5,
                color: AppColors.trottleDark,
              ),

              const SizedBox(height: 16),

              // ══ PARTIE SCROLLABLE ══════════════════════════════════════════

              Expanded(
                child: SingleChildScrollView(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const double paddingH = 20;
                      const double gap      = 6;
                      final double cardW    = (constraints.maxWidth - paddingH * 2 - gap) / 2;

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(paddingH, 0, paddingH, 24),
                        child: Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: _testRoutes.map((r) => RouteCard(
                            item:  r.item,
                            width: cardW,
                            price: r.price,
                          )).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
