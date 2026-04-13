import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppDecorations {
  AppDecorations._();

  // Trottle BG Dark — opacity 90%
  static BoxDecoration get trottleBgDark => BoxDecoration(
        color: AppColors.trottleBgDark.withOpacity(0.9),
      );

  // Trottle Cadre — opacity 15%
  static BoxDecoration get trottleCadre => BoxDecoration(
        color: AppColors.trottleWhite.withOpacity(0.15),
      );

  // BG Blur — background blur sigma 2
  static ImageFilter get bgBlur =>
      ImageFilter.blur(sigmaX: 2, sigmaY: 2, tileMode: TileMode.clamp);

  // Drop Shadow — x=0 y=0 blur=24 spread=8 color #000000 50%
  static const BoxShadow dropShadow = BoxShadow(
    color: Color(0x80000000), // #000000 à 50%
    blurRadius: 24,
    spreadRadius: 8,
    offset: Offset(0, 0),
  );
}
