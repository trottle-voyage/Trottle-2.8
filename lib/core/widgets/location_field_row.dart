import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'field_row.dart';

/// Ligne de formulaire pour la localisation : même gabarit que [FieldRow]
/// mais au-dessous du champ apparaît un menu déroulant alimenté en live
/// par l'API Nominatim (OpenStreetMap), au format "ville, pays".
class LocationFieldRow extends StatefulWidget {
  const LocationFieldRow({
    super.key,
    required this.icon,
    required this.label,
    required this.initialValue,
    this.divider = false,
    this.onChanged,
  });

  final IconData icon;
  final String label;
  final String initialValue;
  final bool divider;
  final ValueChanged<String>? onChanged;

  @override
  State<LocationFieldRow> createState() => _LocationFieldRowState();
}

class _LocationFieldRowState extends State<LocationFieldRow> {
  late final TextEditingController _controller;
  Timer? _debounce;
  List<String> _suggestions = [];
  bool _loading = false;
  bool _justSelected = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    widget.onChanged?.call(value);
    if (_justSelected) {
      // Empêche la relance de recherche juste après une sélection.
      _justSelected = false;
      return;
    }
    _scheduleSearch(value);
  }

  void _scheduleSearch(String query) {
    _debounce?.cancel();
    if (query.trim().length < 2) {
      setState(() {
        _suggestions = [];
        _loading = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _runSearch(query.trim());
    });
  }

  Future<void> _runSearch(String query) async {
    setState(() => _loading = true);
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': query,
        'format': 'json',
        'addressdetails': '1',
        'limit': '6',
        'accept-language': 'fr',
      });

      final client = HttpClient();
      final request = await client.getUrl(uri);
      request.headers
          .set('User-Agent', 'TrottleApp/2.8 (contact@trottle.app)');
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      client.close();

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final List<dynamic> data = json.decode(body);
      final results = <String>[];
      final seen = <String>{};
      for (final item in data) {
        final addr = (item['address'] as Map?) ?? {};
        final city = (addr['city'] ??
                addr['town'] ??
                addr['village'] ??
                addr['municipality'] ??
                addr['hamlet'])
            ?.toString();
        final country = addr['country']?.toString();
        if (city == null || country == null) continue;
        final formatted = '$city, $country';
        if (seen.add(formatted)) results.add(formatted);
      }

      if (!mounted) return;
      setState(() {
        _suggestions = results;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _suggestions = [];
        _loading = false;
      });
    }
  }

  void _select(String value) {
    _justSelected = true;
    _controller.text = value;
    _controller.selection =
        TextSelection.collapsed(offset: value.length);
    setState(() => _suggestions = []);
    widget.onChanged?.call(value);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final style =
        AppTextStyles.text.copyWith(color: AppColors.trottleWhite);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Ligne principale — même gabarit qu'un FieldRow ──────────────
        Container(
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
                child: TextField(
                  controller: _controller,
                  style: style,
                  cursorColor: AppColors.trottleMain,
                  onChanged: _onChanged,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (_loading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: AppColors.trottleMain,
                    strokeWidth: 2,
                  ),
                ),
            ],
          ),
        ),

        // ── Menu déroulant ─────────────────────────────────────────────
        if (_suggestions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: FieldRow.horizontalMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _suggestions.map((s) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _select(s),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.trottleMidGray,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            s,
                            style: style,
                            overflow: TextOverflow.ellipsis,
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
