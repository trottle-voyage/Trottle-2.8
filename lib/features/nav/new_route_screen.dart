import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/back_arrow_bar.dart';
import '../../core/widgets/field_row.dart';
import '../../l10n/app_localizations.dart';

class NewRouteScreen extends StatefulWidget {
  const NewRouteScreen({super.key});

  @override
  State<NewRouteScreen> createState() => _NewRouteScreenState();
}

class _NewRouteScreenState extends State<NewRouteScreen> {
  /// Dimensions des boutons action AVANT import (état initial).
  static const double _btnW = 160;
  static const double _btnH = 85;

  /// Dimensions des tuiles action APRÈS import (dans la grille).
  static const double _actionTileSize = 112;
  static const double _gridGap        = 6;

  static const Widget _divider = _FieldDivider();

  final List<String> _photos = [];

  Future<void> _importPhotos() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        for (final f in result.files) {
          if (f.path != null) _photos.add(f.path!);
        }
      });
    }
  }

  Future<void> _addPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      final path = result.files.first.path;
      if (path != null) setState(() => _photos.add(path));
    }
  }

  void _removePhoto(int index) {
    setState(() => _photos.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.expand(
        child: Container(
          decoration: AppDecorations.bgGradient,
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BackArrowBar(),

                // ── Titre ─────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Text(
                    l.txtNewRoute,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.title
                        .copyWith(color: AppColors.trottleWhite),
                  ),
                ),

                // ── Corps scrollable ──────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                        const SizedBox(height: 8),

                        // ── Zone photos ──────────────────────────────────
                        if (_photos.isEmpty)
                          // État initial — deux grands boutons côte à côte
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _ActionTile(
                                  width:  _btnW,
                                  height: _btnH,
                                  icon:   const Icon(
                                    Icons.smartphone_outlined,
                                    color: AppColors.trottleWhite,
                                    size: 28,
                                  ),
                                  label: l.txtNewRouteImport,
                                  onTap: _importPhotos,
                                ),
                                _ActionTile(
                                  width:  _btnW,
                                  height: _btnH,
                                  icon:   Image.asset(
                                    'assets/icones/trottle_32.webp',
                                    width: 28,
                                    height: 28,
                                    color: AppColors.trottleWhite,
                                  ),
                                  label: l.txtNewRouteAdd,
                                  onTap: _addPhoto,
                                ),
                              ],
                            ),
                          )
                        else
                          // Grille photos + boutons 112×112 à la fin
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final tileW =
                                    (constraints.maxWidth - _gridGap * 2) / 3;

                                return Wrap(
                                  spacing:    _gridGap,
                                  runSpacing: _gridGap,
                                  children: [
                                    for (int i = 0; i < _photos.length; i++)
                                      _PhotoTile(
                                        path:     _photos[i],
                                        index:    i,
                                        size:     tileW,
                                        onRemove: () => _removePhoto(i),
                                      ),
                                    _ActionTile(
                                      width:  _actionTileSize,
                                      height: _actionTileSize,
                                      icon:   const Icon(
                                        Icons.smartphone_outlined,
                                        color: AppColors.trottleWhite,
                                        size: 24,
                                      ),
                                      label: l.txtNewRouteImport,
                                      onTap: _importPhotos,
                                    ),
                                    _ActionTile(
                                      width:  _actionTileSize,
                                      height: _actionTileSize,
                                      icon:   Image.asset(
                                        'assets/icones/trottle_32.webp',
                                        width: 24,
                                        height: 24,
                                        color: AppColors.trottleWhite,
                                      ),
                                      label: l.txtNewRouteAdd,
                                      onTap: _addPhoto,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                        const SizedBox(height: 16),

                        // ── Champs ──────────────────────────────────────
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
                          hint:  l.txtNewRoutePriceHint,
                        ),
                        _divider,

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // ── Boutons verrouillés en bas ────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
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
        ),
      ),
    );
  }
}

// ── Tuile photo importée ──────────────────────────────────────────────────────

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    required this.path,
    required this.index,
    required this.size,
    required this.onRemove,
  });

  final String       path;
  final int          index;
  final double       size;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:  size,
      height: size,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Badge numéro
          Positioned(
            top: 4, left: 4,
            child: Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
          // Supprimer
          Positioned(
            top: 4, right: 4,
            child: GestureDetector(
              onTap: onRemove,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 20, height: 20,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tuile action générique ────────────────────────────────────────────────────

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.width,
    required this.height,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final double       width;
  final double       height;
  final Widget       icon;
  final String       label;
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
            const SizedBox(height: 8),
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

// ── Ligne Prix ────────────────────────────────────────────────────────────────

class _PriceRow extends StatefulWidget {
  const _PriceRow({required this.label, required this.hint});
  final String label;
  final String hint;

  @override
  State<_PriceRow> createState() => _PriceRowState();
}

class _PriceRowState extends State<_PriceRow> {
  static const _currencies = ['€', '\$', '£', '¥', 'CHF'];
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
          const SizedBox(
            width: FieldRow.iconSize,
            height: FieldRow.iconSize,
            child: Icon(
              Icons.attach_money_outlined,
              color: AppColors.trottleMidGray,
              size: FieldRow.iconSize,
            ),
          ),
          const SizedBox(width: FieldRow.gap),
          SizedBox(
            width: FieldRow.textWidth,
            child: Text(widget.label, style: style),
          ),
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
