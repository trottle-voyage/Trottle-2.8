import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppDecorations {
  AppDecorations._();

  // Trottle BG Dark — opacity 90%
  static BoxDecoration get trottleBgDark => BoxDecoration(
        color: AppColors.trottleBgDark.withOpacity(0.9),
      );

  // Trottle Cadre — opacity 15%, border radius 24px
  static BoxDecoration get trottleCadre => BoxDecoration(
        color: AppColors.trottleMain.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
      );

  // Trottle Stroke — dégradé vertical trottleWhite → trottleMain, épaisseur 0.2px
  static const LinearGradient trottleStroke = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.trottleWhite, AppColors.trottleMain],
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
