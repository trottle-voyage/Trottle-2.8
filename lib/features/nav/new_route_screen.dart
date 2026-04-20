import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/back_arrow_bar.dart';
import '../../core/widgets/field_row.dart';
import '../../l10n/app_localizations.dart';

class NewRouteScreen extends StatelessWidget {
  const NewRouteScreen({super.key});

  static const double _btnW = 160;
  static const double _btnH = 85;

  static const Widget _divider = _FieldDivider();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.expand(child: Container(
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
                  l.txtNewRoute,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title
                      .copyWith(color: AppColors.trottleWhite),
                ),
              ),

              const SizedBox(height: 16),

              // ── Deux boutons import / ajout ────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ActionButton(
                      width: _btnW,
                      height: _btnH,
                      icon: const Icon(
                        Icons.smartphone_outlined,
                        color: AppColors.trottleWhite,
                        size: 28,
                      ),
                      label: l.txtNewRouteImport,
                      onTap: () {},
                    ),
                    _ActionButton(
                      width: _btnW,
                      height: _btnH,
                      icon: Image.asset(
                        'assets/icones/trottle_32.webp',
                        width: 28,
                        height: 28,
                        color: AppColors.trottleWhite,
                      ),
                      label: l.txtNewRouteAdd,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Champs ────────────────────────────────────────────────────
              FieldRow(
                icon: Icons.edit_outlined,
                label: l.txtNewRouteTitle,
                initialValue: '',
                hintText: l.txtNewRouteTitleHint,
              ),
              _divider,
              FieldRow(
                icon: Icons.tag,
                label: l.txtNewRouteHashtag,
                initialValue: '',
              ),
              FieldRow(
                icon: Icons.hiking_outlined,
                label: l.txtNewRouteCategory,
                initialValue: '',
              ),
              FieldRow(
                icon: Icons.edit_outlined,
                label: l.txtNewRouteDescription,
                initialValue: '',
                hintText: l.txtNewRouteDescriptionHint,
              ),
              _divider,
            ],
          ),
        ),
      )),
    );
  }
}

// ── Widget bouton action ──────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.width,
    required this.height,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final double    width;
  final double    height;
  final Widget    icon;
  final String    label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.trottleMidGray,
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextStyles.text.copyWith(
                color: AppColors.trottleMidGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Séparateur ────────────────────────────────────────────────────────────────

class _FieldDivider extends StatelessWidget {
  const _FieldDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 0.5,
      color: AppColors.trottleDark,
    );
  }
}
