import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/back_arrow_bar.dart';
import '../../l10n/app_localizations.dart';

class VersionScreen extends StatelessWidget {
  const VersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: AppDecorations.bgGradient,
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BackArrowBar(),

              // ── Titre ──────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                child: Text(
                  '${l.txtVersion} ${AppConstants.appVersion}',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title
                      .copyWith(color: AppColors.trottleWhite),
                ),
              ),

              // ── Sous-titre date ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Text(
                  AppConstants.infoVersion,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subTitleMedium
                      .copyWith(color: AppColors.trottleMidGray),
                ),
              ),

              // ── Stroke délimiteur ──────────────────────────────────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 0.5,
                color: AppColors.trottleDark,
              ),

              // ── Notes de version (scrollable) ──────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  child: Text(
                    l.txtVersionDetails,
                    style: AppTextStyles.text.copyWith(
                      color: AppColors.trottleWhite,
                      height: 1.7,
                    ),
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
