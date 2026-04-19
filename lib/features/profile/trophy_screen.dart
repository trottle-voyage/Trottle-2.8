import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/back_arrow_bar.dart';
import '../../core/widgets/menu_row.dart';
import '../../l10n/app_localizations.dart';

class TrophyScreen extends StatefulWidget {
  const TrophyScreen({super.key});

  @override
  State<TrophyScreen> createState() => _TrophyScreenState();
}

class _TrophyScreenState extends State<TrophyScreen> {
  bool _passportOpen = false;
  bool _rewardsOpen  = false;

  // Liste des stamps débloqués — à connecter à la DB plus tard.
  // Pour l'instant on charge tous les fichiers présents dans assets/stamps/.
  static const List<String> _stamps = [
    'assets/stamps/Australie.png',
    'assets/stamps/France.png',
    'assets/stamps/Japon.png',
    'assets/stamps/Nouvelle-Zélande.png',
    'assets/stamps/USA.png',
  ];

  int get _stampCount => _stamps.length;

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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                l.txtTrophy,
                textAlign: TextAlign.center,
                style: AppTextStyles.title
                    .copyWith(color: AppColors.trottleWhite),
              ),
            ),

            // ── Passeport (dépliable) ──────────────────────────────────────
            _buildPassportRow(l),
            if (_passportOpen) _buildPassportContent(l),

            // ── Accomplissements (dépliable) ───────────────────────────────
              MenuRow(
                icon: Icons.emoji_events_outlined,
                label: l.txtTrophyRewards,
                expandable: true,
                expanded: _rewardsOpen,
                onTap: () =>
                    setState(() => _rewardsOpen = !_rewardsOpen),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Ligne Passeport personnalisée : même gabarit que MenuRow mais avec
  /// le compteur "0/195" affiché à droite comme un hint, avant le chevron.
  Widget _buildPassportRow(AppLocalizations l) {
    final labelStyle =
        AppTextStyles.text.copyWith(color: AppColors.trottleWhite);
    final hintStyle =
        AppTextStyles.text.copyWith(color: AppColors.trottleMidGray);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _passportOpen = !_passportOpen),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 48,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: Icon(Icons.public_outlined,
                  color: AppColors.trottleMidGray, size: 24),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 120,
              child: Text(l.txtTrophyPassport, style: labelStyle),
            ),
            // Hint dynamique : stampCount + count libellé
            Expanded(
              child: Text(
                '$_stampCount${l.txtTrophyPassportCount}',
                style: hintStyle,
              ),
            ),
            Icon(
              _passportOpen
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: AppColors.trottleMidGray,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  /// Grille de stamps 64×64, 4 colonnes, sous la ligne Passeport.
  Widget _buildPassportContent(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _stamps.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemBuilder: (_, i) => ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            _stamps[i],
            width: 64,
            height: 64,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
