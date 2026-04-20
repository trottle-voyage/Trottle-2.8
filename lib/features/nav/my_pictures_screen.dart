import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/back_arrow_bar.dart';
import '../../core/widgets/menu_row.dart';
import '../../l10n/app_localizations.dart';

class MyPicturesScreen extends StatefulWidget {
  const MyPicturesScreen({super.key});

  @override
  State<MyPicturesScreen> createState() => _MyPicturesScreenState();
}

class _MyPicturesScreenState extends State<MyPicturesScreen> {
  bool _publishedOpen = false;
  bool _draftOpen = false;

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
                l.txtMyPictures,
                textAlign: TextAlign.center,
                style: AppTextStyles.title
                    .copyWith(color: AppColors.trottleWhite),
              ),
            ),

            // ── Sous-menus dépliables ──────────────────────────────────────
            MenuRow(
              icon: Icons.file_upload_outlined,
              label: l.txtMyPicturesPublished,
              expandable: true,
              expanded: _publishedOpen,
              onTap: () =>
                  setState(() => _publishedOpen = !_publishedOpen),
            ),
            MenuRow(
              icon: Icons.edit_outlined,
              label: l.txtMyPicturesDraft,
              expandable: true,
              expanded: _draftOpen,
              onTap: () => setState(() => _draftOpen = !_draftOpen),
            ),
            MenuRow(
              icon: Icons.add_circle_outline,
              label: l.txtMyPicturesAdd,
            ),
            ],
          ),
        ),
      )),
    );
  }
}
