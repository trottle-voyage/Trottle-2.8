import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/back_arrow_bar.dart';
import '../../l10n/app_localizations.dart';
import '../main/main_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

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

                // ── Titre ────────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Text(
                    l.txtAbout,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.title
                        .copyWith(color: AppColors.trottleWhite),
                  ),
                ),

                // ── Stroke délimiteur ────────────────────────────────────────
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 0.5,
                  color: AppColors.trottleDark,
                ),

                // ── Corps scrollable ─────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                        // ── Badge BETA + Brand ────────────────────────────────
                        Center(
                          child: Column(
                            children: [
                              // Badge BETA
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.trottleFerrari,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  l.txtAboutBeta,
                                  style: AppTextStyles.textBold.copyWith(
                                    color: AppColors.trottleWhite,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              // Logo Trottle full white
                              Image.asset(
                                'assets/logos/logo_full_white.webp',
                                height: 156,
                              ),

                              const SizedBox(height: 10),

                              // Tagline
                              Text(
                                l.txtAboutTagline,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.text.copyWith(
                                  color: AppColors.trottleLightGray,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Chips tags — trottleMain bg, hashtag 14pt blanc ───
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            l.txtAboutTag1,
                            l.txtAboutTag2,
                            l.txtAboutTag3,
                            l.txtAboutTag4,
                            l.txtAboutTag5,
                            l.txtAboutTag6,
                          ].map((tag) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.trottleMain,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tag,
                              style: AppTextStyles.hashtag.copyWith(
                                color: AppColors.trottleWhite,
                                fontSize: 14,
                              ),
                            ),
                          )).toList(),
                        ),

                        const SizedBox(height: 28),

                        // ── Stats ─────────────────────────────────────────────
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                          decoration: BoxDecoration(
                            color: AppColors.trottleDark.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppColors.trottleMidGray
                                    .withValues(alpha: 0.3),
                                width: 0.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _StatItem(
                                  value: l.txtAboutStat1Value,
                                  label: l.txtAboutStat1Label),
                              _VertDivider(),
                              _StatItem(
                                  value: l.txtAboutStat2Value,
                                  label: l.txtAboutStat2Label),
                              _VertDivider(),
                              _StatItem(
                                  value: l.txtAboutStat3Value,
                                  label: l.txtAboutStat3Label),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Notre Vision ──────────────────────────────────────
                        _SectionTitle(text: l.txtAboutVisionTitle),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.trottleDark.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppColors.trottleMain.withValues(alpha: 0.4),
                                width: 0.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                l.txtAboutVisionQuote,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.subTitleBig.copyWith(
                                  color: AppColors.trottleMain,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                l.txtAboutVisionBody,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.text.copyWith(
                                    color: AppColors.trottleLightGray),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Les 6 Univers — 3 rangées de 2 ───────────────────
                        _SectionTitle(text: l.txtAboutUniversTitle),
                        const SizedBox(height: 12),
                        LayoutBuilder(builder: (ctx, constraints) {
                          final cardW = (constraints.maxWidth - 10) / 2;
                          return Column(
                            children: [
                              Row(children: [
                                SizedBox(width: cardW, child: _UniversCard(icon: Icons.terrain,                   title: l.txtAboutUnivers1, subtitle: l.txtAboutUnivers1Sub)),
                                const SizedBox(width: 10),
                                SizedBox(width: cardW, child: _UniversCard(icon: Icons.directions_bike_outlined,  title: l.txtAboutUnivers2, subtitle: l.txtAboutUnivers2Sub)),
                              ]),
                              const SizedBox(height: 10),
                              Row(children: [
                                SizedBox(width: cardW, child: _UniversCard(icon: Icons.two_wheeler_outlined,      title: l.txtAboutUnivers3, subtitle: l.txtAboutUnivers3Sub)),
                                const SizedBox(width: 10),
                                SizedBox(width: cardW, child: _UniversCard(icon: Icons.brush_outlined,            title: l.txtAboutUnivers4, subtitle: l.txtAboutUnivers4Sub)),
                              ]),
                              const SizedBox(height: 10),
                              Row(children: [
                                SizedBox(width: cardW, child: _UniversCard(icon: Icons.theaters,                  title: l.txtAboutUnivers5, subtitle: l.txtAboutUnivers5Sub)),
                                const SizedBox(width: 10),
                                SizedBox(width: cardW, child: _UniversCard(icon: Icons.account_balance_outlined,  title: l.txtAboutUnivers6, subtitle: l.txtAboutUnivers6Sub)),
                              ]),
                            ],
                          );
                        }),

                        const SizedBox(height: 28),

                        // ── Pourquoi Trottle ──────────────────────────────────
                        _SectionTitle(text: l.txtAboutWhyTitle),
                        const SizedBox(height: 12),
                        _WhyCard(
                          icon: l.txtAboutWhy1Icon,
                          title: l.txtAboutWhy1Title,
                          body: l.txtAboutWhy1Body,
                        ),
                        const SizedBox(height: 10),
                        _WhyCard(
                          icon: l.txtAboutWhy2Icon,
                          title: l.txtAboutWhy2Title,
                          body: l.txtAboutWhy2Body,
                        ),
                        const SizedBox(height: 10),
                        _WhyCard(
                          icon: l.txtAboutWhy3Icon,
                          title: l.txtAboutWhy3Title,
                          body: l.txtAboutWhy3Body,
                        ),

                        const SizedBox(height: 36),

                        // ── CTA → Map ─────────────────────────────────────────
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 400),
                                reverseTransitionDuration:
                                    const Duration(milliseconds: 400),
                                pageBuilder: (_, __, ___) =>
                                    const MainScreen(),
                                transitionsBuilder:
                                    (_, animation, __, child) =>
                                        SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 1),
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOut,
                                  )),
                                  child: child,
                                ),
                              ),
                            ),
                            behavior: HitTestBehavior.opaque,
                            child: Text(
                              l.txtAboutCta,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.subTitleBig.copyWith(
                                color: AppColors.trottleWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Widgets internes ──────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.title.copyWith(
        color: AppColors.trottleWhite,
        fontSize: 18,
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTextStyles.info.copyWith(
            color: AppColors.trottleMain,
            fontSize: 38,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.text
              .copyWith(color: AppColors.trottleLightGray),
        ),
      ],
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.5,
      height: 40,
      color: AppColors.trottleMidGray.withValues(alpha: 0.4),
    );
  }
}

class _UniversCard extends StatelessWidget {
  const _UniversCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String   title;
  final String   subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.trottleDark.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppColors.trottleMidGray.withValues(alpha: 0.3),
            width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.trottleMain, size: 22),
          const SizedBox(height: 6),
          Text(
            title,
            style: AppTextStyles.hashtag
                .copyWith(color: AppColors.trottleWhite),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTextStyles.text
                .copyWith(color: AppColors.trottleLightGray),
          ),
        ],
      ),
    );
  }
}

class _WhyCard extends StatelessWidget {
  const _WhyCard({
    required this.icon,
    required this.title,
    required this.body,
  });
  final String icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.trottleDark.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppColors.trottleMidGray.withValues(alpha: 0.3),
            width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.hashtag
                      .copyWith(color: AppColors.trottleWhite),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: AppTextStyles.text
                      .copyWith(color: AppColors.trottleLightGray),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
