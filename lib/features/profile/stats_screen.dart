import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/back_arrow_bar.dart';
import '../../l10n/app_localizations.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.trottleBgDark,
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BackArrowBar(),

            // ── Titre ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                l.txtProfileStats,
                textAlign: TextAlign.center,
                style: AppTextStyles.title
                    .copyWith(color: AppColors.trottleWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
