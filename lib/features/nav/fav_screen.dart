import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/back_arrow_bar.dart';
import '../../core/widgets/menu_row.dart';
import '../../l10n/app_localizations.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  bool _likeOpen = false;
  bool _favOpen = false;
  bool _folderOpen = false;

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
                l.txtFav,
                textAlign: TextAlign.center,
                style: AppTextStyles.title
                    .copyWith(color: AppColors.trottleWhite),
              ),
            ),

            // ── Sous-menus dépliables ──────────────────────────────────────
            MenuRow(
              icon: Icons.favorite_border,
              label: l.txtFavLike,
              expandable: true,
              expanded: _likeOpen,
              onTap: () => setState(() => _likeOpen = !_likeOpen),
            ),
            MenuRow(
              icon: Icons.bookmark_border,
              label: l.txtFavFav,
              expandable: true,
              expanded: _favOpen,
              onTap: () => setState(() => _favOpen = !_favOpen),
            ),
            MenuRow(
              icon: Icons.folder_outlined,
              label: l.txtFavAdd,
              expandable: true,
              expanded: _folderOpen,
              onTap: () => setState(() => _folderOpen = !_folderOpen),
            ),
          ],
        ),
      ),
    );
  }
}
