import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/back_arrow_bar.dart';
import '../../core/widgets/menu_row.dart';
import '../../l10n/app_localizations.dart';
import '../splash/splash_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _logOut(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const SplashScreen(),
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        ),
      ),
      (route) => false,
    );
  }

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
                l.txtProfileSettings,
                textAlign: TextAlign.center,
                style: AppTextStyles.title
                    .copyWith(color: AppColors.trottleWhite),
              ),
            ),

            // ── Stroke délimiteur ──────────────────────────────────────────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 0.5,
              color: AppColors.trottleDark,
            ),

            // ── Lignes de menu ─────────────────────────────────────────────
            MenuRow(
              icon: Icons.alternate_email,
              label: l.txtSettingsMailPassword,
              labelWidth: 300,
              divider: true,
            ),
            MenuRow(
              icon: Icons.help_outline,
              label: l.txtSettingsHelp,
            ),
            MenuRow(
              icon: Icons.person_outline,
              label: l.txtSettingsStatus,
            ),
            MenuRow(
              icon: Icons.military_tech_outlined,
              label: l.txtSettingsSubscription,
            ),
            MenuRow(
              icon: Icons.perm_device_information_outlined,
              label: l.txtSettingsAuth,
            ),
            MenuRow(
              icon: Icons.notifications_none_outlined,
              label: l.txtSettingsNotifications,
            ),
            MenuRow(
              icon: Icons.info_outline,
              label: l.txtSettingsAbout,
              divider: true,
            ),

            // ── Se déconnecter ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: GestureDetector(
                onTap: () => _logOut(context),
                behavior: HitTestBehavior.opaque,
                child: Text(
                  l.txtSettingsLogOut,
                  textAlign: TextAlign.left,
                  style: AppTextStyles.subTitleMedium
                      .copyWith(color: AppColors.trottleGray),
                ),
              ),
            ),

            // ── Liens légaux tout en bas ───────────────────────────────────
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l.txtSettingsLegal,
                        style: AppTextStyles.subTitleMedium
                            .copyWith(color: AppColors.trottleGray),
                      ),
                      const SizedBox(width: 80),
                      Text(
                        l.txtSettingsGeneral,
                        style: AppTextStyles.subTitleMedium
                            .copyWith(color: AppColors.trottleGray),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
