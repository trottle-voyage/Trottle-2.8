import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/back_arrow_bar.dart';
import '../../core/widgets/globe_background.dart';
import '../../core/widgets/menu_row.dart';
import '../../l10n/app_localizations.dart';
import '../infos/version_screen.dart';
import '../nav/fav_screen.dart';
import '../nav/my_pictures_screen.dart';
import '../nav/my_route_screen.dart';
import '../nav/purchase_screen.dart';
import '../nav/trip_screen.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import 'stats_screen.dart';
import 'trophy_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const double _avatarSize = 96;
  static const Duration _transitionDuration = Duration(milliseconds: 400);

  void _push(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: _transitionDuration,
        reverseTransitionDuration: _transitionDuration,
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.trottleBgDark,
      body: Stack(
        children: [
          // ── Fond : dégradé radial + globe filigrane ──────────────────
          const Positioned.fill(
            child: GlobeBackground(
              arcStartFraction: 0.62, // arc visible à partir du niveau "Achats"
            ),
          ),

          // ── Contenu ──────────────────────────────────────────────────
          SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BackArrowBar(),

                // ── Bloc haut : titre + avatar + pseudo ────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l.txtProfile,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.title
                            .copyWith(color: AppColors.trottleWhite),
                      ),
                      const SizedBox(height: 12),
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
                      const SizedBox(height: 12),
                      Text(
                        l.txtProfileUser,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.subTitleBig
                            .copyWith(color: AppColors.trottleWhite),
                      ),
                    ],
                  ),
                ),

                // ── Stroke délimiteur ──────────────────────────────────────────
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 0.5,
                  color: AppColors.trottleDark,
                ),

                // ── Lignes de menu (version d'il y a ~24h) ─────────────────────
                MenuRow(
                  icon: Icons.person_outline,
                  label: l.txtProfileMenu,
                  divider: true,
                  onTap: () => _push(context, const EditProfileScreen()),
                ),
                MenuRow(
                  icon: Icons.photo_camera_outlined,
                  label: l.txtProfilePictures,
                  onTap: () => _push(context, const MyPicturesScreen()),
                ),
                MenuRow(
                  icon: Icons.favorite_border,
                  label: l.txtProfileFavorite,
                  onTap: () => _push(context, const FavScreen()),
                ),
                MenuRow(
                  icon: Icons.route_outlined,
                  label: l.txtProfileRoute,
                  onTap: () => _push(context, const MyRouteScreen()),
                ),
                MenuRow(
                  icon: Icons.shopping_cart_outlined,
                  label: l.txtProfilePurchase,
                  onTap: () => _push(context, const PurchaseScreen()),
                ),
                MenuRow(
                  icon: Icons.luggage_outlined,
                  label: l.txtProfileTrip,
                  divider: true,
                  onTap: () => _push(context, const TripScreen()),
                ),
                MenuRow(
                  icon: Icons.emoji_events_outlined,
                  label: l.txtProfileTrophy,
                  onTap: () => _push(context, const TrophyScreen()),
                ),
                MenuRow(
                  icon: Icons.bar_chart_outlined,
                  label: l.txtProfileStats,
                  onTap: () => _push(context, const StatsScreen()),
                ),
                MenuRow(
                  icon: Icons.settings_outlined,
                  label: l.txtProfileSettings,
                  labelStyle: AppTextStyles.subTitleMedium
                      .copyWith(color: AppColors.trottleGray),
                  labelWidth: 300,
                  onTap: () => _push(context, const SettingsScreen()),
                ),

                // ── Version de l'appli ─────────────────────────────────────────
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: GestureDetector(
                        onTap: () => _push(context, const VersionScreen()),
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          '${l.txtVersion} ${AppConstants.appVersion}',
                          style: AppTextStyles.subTitleMedium
                              .copyWith(color: AppColors.trottleWhite),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
