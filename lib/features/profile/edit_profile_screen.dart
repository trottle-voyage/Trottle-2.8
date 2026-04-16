import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/back_arrow_bar.dart';
import '../../core/widgets/dropdown_field_row.dart';
import '../../core/widgets/field_row.dart';
import '../../core/widgets/location_field_row.dart';
import '../../core/widgets/menu_row.dart';
import '../../l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const double _avatarSize = 96;

  // Valeurs locales — à persister en DB plus tard.
  String? _pseudo;
  String? _instagram;
  String? _location;
  String? _language;
  DateTime? _birth;
  String? _gender;

  void _save() {
    // TODO : logique d'enregistrement — à brancher.
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birth ?? DateTime(now.year - 30, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.trottleMain,
              onPrimary: AppColors.trottleWhite,
              surface: AppColors.trottleBgDark,
              onSurface: AppColors.trottleWhite,
            ),
            dialogBackgroundColor: AppColors.trottleBgDark,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _birth = picked);
  }

  String _formatBirth(DateTime d) {
    const months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
    ];
    final dd = d.day.toString().padLeft(2, '0');
    return '$dd ${months[d.month - 1]} ${d.year}';
  }

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
            // ── Barre du haut : flèche retour + "Enregistrer" ─────────────
            BackArrowBar(
              trailing: GestureDetector(
                onTap: _save,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  l.txtEditProfileSave,
                  style: AppTextStyles.subTitleBig
                      .copyWith(color: AppColors.trottleMidGray),
                ),
              ),
            ),

            // ── Titre ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Text(
                l.txtEditProfile,
                textAlign: TextAlign.center,
                style: AppTextStyles.title
                    .copyWith(color: AppColors.trottleWhite),
              ),
            ),

            // ── Photo de profil alignée à gauche, avec icone caméra ────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: _avatarSize,
                  height: _avatarSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: _avatarSize,
                        height: _avatarSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1,
                            color: AppColors.trottleMain.withOpacity(0.4),
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/pp.webp',
                            width: _avatarSize,
                            height: _avatarSize,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.add_a_photo_outlined,
                        color: AppColors.trottleWhite,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Champs éditables ───────────────────────────────────────────
            FieldRow(
              icon: Icons.person_outline,
              label: l.txtEditProfilePseudo,
              initialValue: _pseudo ?? l.txtEditProfilePseudoHint,
              divider: true,
              onChanged: (v) => _pseudo = v,
            ),
            FieldRow(
              icon: Icons.camera_alt_outlined,
              label: l.txtEditProfileInsta,
              initialValue: _instagram ?? l.txtEditProfileInstaHint,
              onChanged: (v) => _instagram = v,
            ),
            LocationFieldRow(
              icon: Icons.location_on_outlined,
              label: l.txtEditProfileLocation,
              initialValue: _location ?? l.txtEditProfileLocationHint,
              onChanged: (v) => _location = v,
            ),
            FieldRow(
              icon: Icons.hiking_outlined,
              label: l.txtEditProfileProfil,
              initialValue: '',
            ),
            FieldRow(
              icon: Icons.tag,
              label: l.txtEditProfileHashtag,
              initialValue: '',
            ),
            FieldRow(
              icon: Icons.accessible_outlined,
              label: l.txtEditProfileAccess,
              initialValue: '',
            ),
            DropdownFieldRow(
              icon: Icons.translate,
              label: l.txtEditProfileLanguage,
              value: _language ?? l.txtEditProfileLanguageHint,
              options: const [
                'Français',
                'Anglais',
                'Allemand',
                'Japonais',
                'Espagnol',
              ],
              onChanged: (v) => setState(() => _language = v),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _pickBirthDate,
              child: IgnorePointer(
                child: FieldRow(
                  icon: Icons.calendar_today_outlined,
                  label: l.txtEditProfileBirth,
                  initialValue:
                      _birth != null ? _formatBirth(_birth!) : l.txtEditProfileBirthHint,
                  readOnly: true,
                ),
              ),
            ),
            DropdownFieldRow(
              icon: Icons.wc_outlined,
              label: l.txtEditProfileGender,
              value: _gender ?? l.txtEditProfileGenderHint,
              options: [
                l.txtWelcomeGenderOpt0,
                l.txtWelcomeGenderOpt1,
                l.txtWelcomeGenderOpt2,
              ],
              divider: true,
              onChanged: (v) => setState(() => _gender = v),
            ),
            MenuRow(
              icon: Icons.travel_explore_outlined,
              label: l.txtEditProfileGuide,
            ),
          ],
        ),
      ),
    );
  }
}
