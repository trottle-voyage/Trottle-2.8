import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle title = TextStyle(
    fontFamily: 'LeagueSpartan',
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 24,
  );

  static const TextStyle subTitleBig = TextStyle(
    fontFamily: 'LeagueSpartan',
    fontWeight: FontWeight.w400, // Regular
    fontSize: 20,
  );

  static const TextStyle subTitleMedium = TextStyle(
    fontFamily: 'LeagueSpartan',
    fontWeight: FontWeight.w400, // Regular
    fontSize: 12,
  );

  static const TextStyle text = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400, // Regular
    fontSize: 12,
  );

  static const TextStyle textBold = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700, // Bold
    fontSize: 12,
  );

  static const TextStyle hashtag = TextStyle(
    fontFamily: 'LeagueSpartan',
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 14,
  );

  static const TextStyle info = TextStyle(
    fontFamily: 'LeagueGothic',
    fontWeight: FontWeight.w400, // Regular
    fontSize: 42,
  );
}
