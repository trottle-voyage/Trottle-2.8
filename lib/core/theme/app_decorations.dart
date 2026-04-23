import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppDecorations {
  AppDecorations._();

  // Trottle BG Dark — opacity 90%
  static BoxDecoration get trottleBgDark => BoxDecoration(
        color: AppColors.trottleBgDark.withValues(alpha: 0.9),
      );

  // Trottle Cadre — opacity 15%, border radius 24px
  static BoxDecoration get trottleCadre => BoxDecoration(
        color: AppColors.trottleMain.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
      );

  // Trottle Stroke — dégradé vertical trottleWhite → trottleMain, épaisseur 0.2px
  static const LinearGradient trottleStroke = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.trottleWhite, AppColors.trottleMain],
  );

  /// Dégradé diagonal « pages Trottle » (haut-gauche clair → bas-droite sombre).
  /// Réutilisable seul (`Shader`, `SweepGradient` dérivé, etc.) ou via [bgGradient].
  static const LinearGradient trottleBgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0E3549), AppColors.trottleBgDark],
  );

  /// [BoxDecoration] plein écran : même gradient que [trottleBgGradient].
  static const BoxDecoration bgGradient = BoxDecoration(
    gradient: trottleBgGradient,
  );

  // BG Blur — background blur sigma 8
  static ImageFilter get bgBlur =>
      ImageFilter.blur(sigmaX: 10, sigmaY: 10, tileMode: TileMode.clamp);

  // Drop Shadow — x=0 y=0 blur=24 spread=0 color #000000 50% (contours uniquement)
  static const BoxShadow dropShadow = BoxShadow(
    color: Color(0x80000000), // #000000 à 75%
    blurRadius: 24,
    spreadRadius: 0,
    offset: Offset(0, 8),
  );
}
