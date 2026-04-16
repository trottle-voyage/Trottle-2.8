import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Bandeau supérieur contenant la flèche de retour.
///
/// Module partagé : si on modifie l'apparence ou le comportement ici,
/// toutes les pages l'utilisant sont mises à jour automatiquement.
class BackArrowBar extends StatelessWidget {
  const BackArrowBar({
    super.key,
    this.onTap,
    this.trailing,
  });

  /// Callback optionnel pour la flèche. Par défaut : `Navigator.pop(context)`.
  final VoidCallback? onTap;

  /// Widget optionnel affiché à droite de la barre (ex : "Enregistrer").
  final Widget? trailing;

  // Dimensions
  static const double barHeight  = 56;
  static const double iconSize   = 20;
  static const double hitSize    = 44;
  static const double edgeInset  = 10;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return SizedBox(
      height: barHeight + topPadding,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: Stack(
          children: [
            // Flèche — identique sur toutes les pages
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: edgeInset),
                child: GestureDetector(
                  onTap: onTap ?? () => Navigator.pop(context),
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox(
                    width: hitSize,
                    height: hitSize,
                    child: Center(
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.trottleWhite,
                        size: iconSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Slot trailing — optionnel, à droite
            if (trailing != null)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: edgeInset + 10),
                  child: trailing,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
