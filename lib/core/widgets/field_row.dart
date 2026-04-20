import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Ligne de formulaire — icône, libellé, puis champ texte éditable.
///
/// Même gabarit que [MenuRow] mais le chevron est remplacé par un
/// [TextField] permettant à l'utilisateur de modifier la valeur directement.
/// Un callback [onChanged] permet de récupérer la valeur pour la persister.
class FieldRow extends StatefulWidget {
  const FieldRow({
    super.key,
    required this.icon,
    required this.label,
    required this.initialValue,
    this.hintText,
    this.divider = false,
    this.onChanged,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String initialValue;
  final String? hintText;
  final bool divider;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  /// Si true, le champ n'est pas éditable au clavier et délègue le tap
  /// à [onTap] (ex : ouvre une page de recherche).
  final bool readOnly;
  final VoidCallback? onTap;

  // Dimensions — identiques à MenuRow
  static const double horizontalMargin = 20;
  static const double iconSize         = 24;
  static const double textWidth        = 120;
  static const double gap              = 12;
  static const double rowHeight        = 48;

  @override
  State<FieldRow> createState() => _FieldRowState();
}

class _FieldRowState extends State<FieldRow> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant FieldRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.text.copyWith(color: AppColors.trottleWhite);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FieldRow.horizontalMargin),
      height: FieldRow.rowHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: widget.divider ? 1 : 0,
            color:
                widget.divider ? AppColors.trottleDark : Colors.transparent,
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
            child: TextField(
              controller: _controller,
              style: style,
              cursorColor: AppColors.trottleMain,
              keyboardType: widget.keyboardType,
              onChanged: widget.onChanged,
              readOnly: widget.readOnly,
              showCursor: !widget.readOnly,
              onTap: widget.onTap,
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
                hintText: widget.hintText,
                hintStyle: AppTextStyles.text.copyWith(
                  color: AppColors.trottleWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
