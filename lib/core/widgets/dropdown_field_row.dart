import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'field_row.dart';

/// Ligne de formulaire avec menu déroulant inline.
///
/// Même gabarit que [FieldRow], mais au tap la liste d'options [options]
/// apparaît juste sous la ligne. Sélectionner une option la renvoie via
/// [onChanged].
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
  bool _open = false;

  void _toggle() => setState(() => _open = !_open);

  void _select(String value) {
    setState(() => _open = false);
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final style =
        AppTextStyles.text.copyWith(color: AppColors.trottleWhite);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Ligne principale ───────────────────────────────────────────
        GestureDetector(
          onTap: _toggle,
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
                  _open
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.trottleMidGray,
                  size: FieldRow.iconSize,
                ),
              ],
            ),
          ),
        ),

        // ── Options ────────────────────────────────────────────────────
        if (_open)
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: FieldRow.horizontalMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.options.map((o) {
                final selected = o == widget.value;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _select(o),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const SizedBox(
                            width: FieldRow.iconSize + FieldRow.gap),
                        Expanded(
                          child: Text(
                            o,
                            style: style.copyWith(
                              color: selected
                                  ? AppColors.trottleMain
                                  : AppColors.trottleWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
