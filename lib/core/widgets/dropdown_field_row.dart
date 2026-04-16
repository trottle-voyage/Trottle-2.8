import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'field_row.dart';

/// Ligne de formulaire avec menu déroulant en popup overlay.
///
/// Le menu s'affiche par-dessus le reste du contenu, aligné sous
/// la zone de valeur, sans décaler les autres widgets.
class DropdownFieldRow extends StatefulWidget {
  const DropdownFieldRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.options,
    this.divider = false,
    this.onChanged,
  });

  final IconData icon;
  final String label;
  final String value;
  final List<String> options;
  final bool divider;
  final ValueChanged<String>? onChanged;

  @override
  State<DropdownFieldRow> createState() => _DropdownFieldRowState();
}

class _DropdownFieldRowState extends State<DropdownFieldRow> {
  OverlayEntry? _overlay;
  final GlobalKey _rowKey = GlobalKey();

  void _open() {
    if (_overlay != null) {
      _close();
      return;
    }

    final box = _rowKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final pos = box.localToGlobal(Offset.zero);

    // Calcule le décalage X pour aligner sur la zone valeur
    // (icône + gap + labelWidth + gap)
    const double offsetX = FieldRow.horizontalMargin +
        FieldRow.iconSize +
        FieldRow.gap +
        FieldRow.textWidth +
        FieldRow.gap;
    final double popupLeft = pos.dx + offsetX;
    final double popupTop  = pos.dy + box.size.height;
    final double popupWidth =
        box.size.width - offsetX - FieldRow.horizontalMargin;

    _overlay = OverlayEntry(
      builder: (_) => _PopupMenu(
        left: popupLeft,
        top: popupTop,
        width: popupWidth,
        options: widget.options,
        selected: widget.value,
        onSelect: (v) {
          widget.onChanged?.call(v);
          _close();
        },
        onDismiss: _close,
      ),
    );
    Overlay.of(context).insert(_overlay!);
    setState(() {});
  }

  void _close() {
    _overlay?.remove();
    _overlay = null;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _overlay?.remove();
    _overlay = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style =
        AppTextStyles.text.copyWith(color: AppColors.trottleWhite);
    final bool open = _overlay != null;

    return GestureDetector(
      key: _rowKey,
      onTap: _open,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: FieldRow.horizontalMargin),
        height: FieldRow.rowHeight,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: widget.divider ? 1 : 0,
              color: widget.divider
                  ? AppColors.trottleDark
                  : Colors.transparent,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: FieldRow.iconSize,
              height: FieldRow.iconSize,
              child: Icon(
                widget.icon,
                color: AppColors.trottleMidGray,
                size: FieldRow.iconSize,
              ),
            ),
            const SizedBox(width: FieldRow.gap),
            SizedBox(
              width: FieldRow.textWidth,
              child: Text(widget.label, style: style),
            ),
            Expanded(
              child: Text(widget.value, style: style),
            ),
            Icon(
              open
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: AppColors.trottleMidGray,
              size: FieldRow.iconSize,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Popup overlay ──────────────────────────────────────────────────────────

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({
    required this.left,
    required this.top,
    required this.width,
    required this.options,
    required this.selected,
    required this.onSelect,
    required this.onDismiss,
  });

  final double left;
  final double top;
  final double width;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final style =
        AppTextStyles.text.copyWith(color: AppColors.trottleWhite);

    return Stack(
      children: [
        // Zone invisible pour fermer en cliquant à l'extérieur
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onDismiss,
            child: const ColoredBox(color: Colors.transparent),
          ),
        ),

        // Menu
        Positioned(
          left: left,
          top: top,
          width: width,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0A2540), // légèrement plus clair que trottleBgDark
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x80000000),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: options.map((o) {
                  final isSel = o == selected;
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onSelect(o),
                    child: Container(
                      height: 40,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: o != options.last ? 0.5 : 0,
                            color: AppColors.trottleDark,
                          ),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          o,
                          style: style.copyWith(
                            color: isSel
                                ? AppColors.trottleMain
                                : AppColors.trottleWhite,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
