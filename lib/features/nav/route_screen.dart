import 'package:flutter/material.dart';
import '../../core/models/photo_item.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/back_arrow_bar.dart';
import '../../core/widgets/photo_card.dart';
import '../../l10n/app_localizations.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  static const double _avatarSize = 64;

  // ── Données de test (Star Wars) ──────────────────────────────────────────
  static final _testPhotos = [
    PhotoItem(imageAsset: 'assets/photos/img_01.webp', hashtag: 'Yoda',         city: 'Dagobah',    flag: '🌿'),
    PhotoItem(imageAsset: 'assets/photos/img_02.webp', hashtag: 'Dark Vador',   city: 'Mustafar',   flag: '🔴'),
    PhotoItem(imageAsset: 'assets/photos/img_03.webp', hashtag: 'Luke',         city: 'Tatooine',   flag: '☀️'),
    PhotoItem(imageAsset: 'assets/photos/img_04.webp', hashtag: 'Obi-Wan',      city: 'Coruscant',  flag: '🌆'),
    PhotoItem(imageAsset: 'assets/photos/img_05.webp', hashtag: 'R2-D2',        city: 'Naboo',      flag: '💧'),
    PhotoItem(imageAsset: 'assets/photos/img_06.webp', hashtag: 'Chewbacca',    city: 'Kashyyyk',   flag: '🌲'),
    PhotoItem(imageAsset: 'assets/photos/img_07.webp', hashtag: 'Han Solo',     city: 'Corellia',   flag: '🚀'),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final textStyle    = AppTextStyles.text.copyWith(color: AppColors.trottleWhite);
    final saluteStyle  = AppTextStyles.subTitleBig.copyWith(color: AppColors.trottleWhite);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.expand(
        child: Container(
        decoration: AppDecorations.bgGradient,
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BackArrowBar(),

              // ── Titre ─────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Text(
                  l.txtRoute,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title.copyWith(color: AppColors.trottleWhite),
                ),
              ),

              // ── Bloc pp + salutation ──────────────────────────────────────
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
                          color: AppColors.trottleMain.withOpacity(0.4),
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

              // ── Stroke délimiteur ─────────────────────────────────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 0.5,
                color: AppColors.trottleDark,
              ),

              const SizedBox(height: 16),

              // ── Carrousel de photos : 3 cartes visibles, scroll horizontal ──
              LayoutBuilder(
                builder: (context, constraints) {
                  const double paddingH = 20;
                  const double gap     = 8;
                  const int    visible = 3;
                  final cardW = (constraints.maxWidth - paddingH * 2 - gap * (visible - 1)) / visible;
                  final cardH = cardW + PhotoCard.infoHeight;

                  return SizedBox(
                    height: cardH,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: paddingH),
                      itemCount: _testPhotos.length,
                      separatorBuilder: (_, __) => const SizedBox(width: gap),
                      itemBuilder: (_, i) => PhotoCard(
                        item:  _testPhotos[i],
                        width: cardW,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
