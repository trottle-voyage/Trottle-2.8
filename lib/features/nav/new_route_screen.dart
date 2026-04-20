import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/back_arrow_bar.dart';
import '../../core/widgets/dropdown_field_row.dart';
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
              FieldRow(
                icon: Icons.route_outlined,
                label: l.txtNewRouteDistance,
                initialValue: '',
                hintText: l.txtNewRouteDistanceHint,
                keyboardType: TextInputType.number,
              ),
              FieldRow(
                icon: Icons.timer_outlined,
                label: l.txtNewRouteDuration,
                initialValue: '',
                hintText: l.txtNewRouteDurationHint,
              ),
              FieldRow(
                icon: Icons.accessible_outlined,
                label: l.txtNewRouteAccess,
                initialValue: '',
              ),
              _PriceRow(
                label: l.txtNewRoutePrice,
                hint: l.txtNewRoutePriceHint,
              ),
              _divider,

              const SizedBox(height: 16),

              // ── Boutons Brouillon / Publier ────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _TextButton(
                      label: l.txtNewRouteDraft,
                      color: AppColors.trottleMidGray,
                      onTap: () {},
                    ),
                    const SizedBox(width: 10),
                    _TextButton(
                      label: l.txtNewRoutePublish,
                      color: AppColors.trottleLightBlue,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
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
          borderRadius: BorderRadius.circular(8),
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

// ── Ligne Prix : dropdown devise + champ montant ─────────────────────────────

class _PriceRow extends StatefulWidget {
  const _PriceRow({required this.label, required this.hint});
  final String label;
  final String hint;

  @override
  State<_PriceRow> createState() => _PriceRowState();
}

class _PriceRowState extends State<_PriceRow> {
  static const _currencies = ['€', '\$', '£', '¥'];
  String _currency = '€';

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.text.copyWith(color: AppColors.trottleWhite);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FieldRow.horizontalMargin),
      height: FieldRow.rowHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icône
          SizedBox(
            width: FieldRow.iconSize,
            height: FieldRow.iconSize,
            child: const Icon(
              Icons.attach_money_outlined,
              color: AppColors.trottleMidGray,
              size: FieldRow.iconSize,
            ),
          ),
          const SizedBox(width: FieldRow.gap),
          // Label
          SizedBox(
            width: FieldRow.textWidth,
            child: Text(widget.label, style: style),
          ),
          // Dropdown devise (compact)
          DropdownButton<String>(
            value: _currency,
            dropdownColor: const Color(0xFF0A2540),
            underline: const SizedBox.shrink(),
            icon: const Icon(Icons.keyboard_arrow_down,
                color: AppColors.trottleMidGray, size: 16),
            style: style,
            items: _currencies
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _currency = v!),
          ),
          const SizedBox(width: 4),
          // Champ montant
          Expanded(
            child: TextField(
              style: style,
              cursorColor: AppColors.trottleMain,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
                hintText: widget.hint,
                hintStyle: style,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bouton texte coloré ───────────────────────────────────────────────────────

class _TextButton extends StatelessWidget {
  const _TextButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String       label;
  final Color        color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: AppTextStyles.text.copyWith(color: AppColors.trottleWhite),
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
