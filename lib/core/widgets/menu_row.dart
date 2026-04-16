import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Ligne de menu générique — icône à gauche, libellé à droite,
/// stroke de séparation en bas.
///
/// Module partagé : modifier ce widget met à jour toutes les pages
/// qui l'utilisent (Profil, Réglages, etc.).
class MenuRow extends StatelessWidget {
  const MenuRow({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.divider = false,
    this.labelStyle,
    this.labelWidth,
    this.expandable = false,
    this.expanded = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  /// Affiche un stroke de séparation en bas de la ligne.
  final bool divider;

  /// Style override du libellé. Par défaut : text blanc Montserrat 12.
  final TextStyle? labelStyle;

  /// Largeur override de la zone de texte. Par défaut : [textWidth] = 120.
  final double? labelWidth;

  /// Si true, le chevron pointe vers le bas (replié) ou vers le haut
  /// (déplié selon [expanded]), au lieu de pointer vers la droite.
  final bool expandable;

  /// Utilisé quand [expandable] est true : bascule l'icône entre
  /// "déroulé" (haut) et "refermé" (bas).
  final bool expanded;

  // Dimensions
  static const double horizontalMargin = 20; // identique au bloc Profil
  static const double iconSize         = 24;
  static const double textWidth        = 120;
  static const double gap              = 12;
  static const double rowHeight        = 48;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: horizontalMargin),
        height: rowHeight,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: divider ? 1 : 0,
              color: divider ? AppColors.trottleDark : Colors.transparent,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: iconSize,
              height: iconSize,
              child: Icon(
                icon,
                color: AppColors.trottleMidGray,
                size: iconSize,
              ),
            ),
            const SizedBox(width: gap),
            SizedBox(
              width: labelWidth ?? textWidth,
              child: Text(
                label,
                style: labelStyle ??
                    AppTextStyles.text
                        .copyWith(color: AppColors.trottleWhite),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: iconSize,
              height: iconSize,
              child: Icon(
                expandable
                    ? (expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down)
                    : Icons.chevron_right,
                color: AppColors.trottleMidGray,
                size: iconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
