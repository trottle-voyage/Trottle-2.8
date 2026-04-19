import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/back_arrow_bar.dart';
import '../../core/widgets/menu_row.dart';
import '../../l10n/app_localizations.dart';

class MyRouteScreen extends StatefulWidget {
  const MyRouteScreen({super.key});

  @override
  State<MyRouteScreen> createState() => _MyRouteScreenState();
}

class _MyRouteScreenState extends State<MyRouteScreen> {
  bool _createdOpen = false;
  bool _addOpen = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
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
                l.txtMyRoutes,
                textAlign: TextAlign.center,
                style: AppTextStyles.title
                    .copyWith(color: AppColors.trottleWhite),
              ),
            ),

            // ── Sous-menus dépliables ──────────────────────────────────────
            MenuRow(
              icon: Icons.route_outlined,
              label: l.txtMyRoutesCreated,
              expandable: true,
              expanded: _createdOpen,
              onTap: () => setState(() => _createdOpen = !_createdOpen),
            ),
            MenuRow(
              icon: Icons.add_circle_outline,
              label: l.txtMyRoutesAdd,
              expandable: true,
              expanded: _addOpen,
              onTap: () => setState(() => _addOpen = !_addOpen),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
