import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/back_arrow_bar.dart';
import '../../core/widgets/menu_row.dart';
import '../../l10n/app_localizations.dart';
import '../infos/version_screen.dart';
import '../nav/fav_screen.dart';
import '../nav/my_pictures_screen.dart';
import '../nav/my_route_screen.dart';
import '../nav/purchase_screen.dart';
import '../nav/trip_screen.dart';
import 'trophy_screen.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import 'stats_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const double _avatarSize = 96;

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const SettingsScreen(),
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

  void _openEditProfile(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const EditProfileScreen(),
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

  void _openMyPictures(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const MyPicturesScreen(),
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

  void _openMyRoute(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const MyRouteScreen(),
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

  void _openFav(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const FavScreen(),
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

  void _openPurchase(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const PurchaseScreen(),
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

  void _openTrip(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const TripScreen(),
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

  void _openTrophy(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const TrophyScreen(),
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

  void _openStats(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const StatsScreen(),
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

  void _openVersion(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const VersionScreen(),
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
      body: SafeArea(
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

            // ── Lignes de menu ─────────────────────────────────────────────
            MenuRow(
              icon: Icons.person_outline,
              label: l.txtProfileMenu,
              divider: true,
              onTap: () => _openEditProfile(context),
            ),
            MenuRow(
              icon: Icons.photo_camera_outlined,
              label: l.txtProfilePictures,
              onTap: () => _openMyPictures(context),
            ),
            MenuRow(
              icon: Icons.favorite_border,
              label: l.txtProfileFavorite,
              onTap: () => _openFav(context),
            ),
            MenuRow(
              icon: Icons.route_outlined,
              label: l.txtProfileRoute,
              onTap: () => _openMyRoute(context),
            ),
            MenuRow(
              icon: Icons.shopping_cart_outlined,
              label: l.txtProfilePurchase,
              onTap: () => _openPurchase(context),
            ),
            MenuRow(
              icon: Icons.luggage_outlined,
              label: l.txtProfileTrip,
              divider: true,
              onTap: () => _openTrip(context),
            ),
            MenuRow(
              icon: Icons.emoji_events_outlined,
              label: l.txtProfileTrophy,
              onTap: () => _openTrophy(context),
            ),
            MenuRow(
              icon: Icons.bar_chart_outlined,
              label: l.txtProfileStats,
              onTap: () => _openStats(context),
            ),
            MenuRow(
              icon: Icons.settings_outlined,
              label: l.txtProfileSettings,
              labelStyle: AppTextStyles.subTitleMedium
                  .copyWith(color: AppColors.trottleGray),
              labelWidth: 300,
              onTap: () => _openSettings(context),
            ),

            // ── Version de l'appli ─────────────────────────────────────────
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: GestureDetector(
                    onTap: () => _openVersion(context),
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
    );
  }
}
