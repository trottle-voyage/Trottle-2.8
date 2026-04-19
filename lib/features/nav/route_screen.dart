import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/back_arrow_bar.dart';
import '../../l10n/app_localizations.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  static const double _avatarSize = 64;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final textStyle =
        AppTextStyles.text.copyWith(color: AppColors.trottleWhite);
    final saluteStyle =
        AppTextStyles.subTitleBig.copyWith(color: AppColors.trottleWhite);

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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                l.txtRoute,
                textAlign: TextAlign.center,
                style: AppTextStyles.title
                    .copyWith(color: AppColors.trottleWhite),
              ),
            ),

            // ── Bloc pp + salutation ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
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
                        Text(
                          '${l.txtRouteSalute}${l.txtProfileUser}',
                          style: saluteStyle,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l.txtRouteQuestion,
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
