import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/back_arrow_bar.dart';
import '../../core/widgets/menu_row.dart';
import '../../l10n/app_localizations.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  bool _routeOpen = false;
  bool _mapOpen = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.trottleBgDark,
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BackArrowBar(),

            // ── Titre ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                l.txtPurchase,
                textAlign: TextAlign.center,
                style: AppTextStyles.title
                    .copyWith(color: AppColors.trottleWhite),
              ),
            ),

            // ── Sous-menus dépliables ──────────────────────────────────────
            MenuRow(
              icon: Icons.route_outlined,
              label: l.txtPurchaseRoute,
              expandable: true,
              expanded: _routeOpen,
              onTap: () => setState(() => _routeOpen = !_routeOpen),
            ),
            MenuRow(
              icon: Icons.map_outlined,
              label: l.txtPurchaseMap,
              expandable: true,
              expanded: _mapOpen,
              onTap: () => setState(() => _mapOpen = !_mapOpen),
            ),
          ],
        ),
      ),
    );
  }
}
