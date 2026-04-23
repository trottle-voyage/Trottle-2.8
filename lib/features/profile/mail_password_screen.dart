import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/back_arrow_bar.dart';
import '../../core/widgets/field_row.dart';
import '../../l10n/app_localizations.dart';

class MailPasswordScreen extends StatefulWidget {
  const MailPasswordScreen({super.key});

  @override
  State<MailPasswordScreen> createState() => _MailPasswordScreenState();
}

class _MailPasswordScreenState extends State<MailPasswordScreen> {
  // ── Contrôleurs e-mail ────────────────────────────────────────────────────
  String _newEmail        = '';
  String _confirmEmail    = '';

  // ── Contrôleurs mot de passe ──────────────────────────────────────────────
  final _currentPwdCtrl  = TextEditingController();
  final _newPwdCtrl      = TextEditingController();
  final _confirmPwdCtrl  = TextEditingController();

  bool _currentVisible   = false;
  bool _newVisible       = false;
  bool _confirmVisible   = false;

  @override
  void dispose() {
    _currentPwdCtrl.dispose();
    _newPwdCtrl.dispose();
    _confirmPwdCtrl.dispose();
    super.dispose();
  }

  // ── Validation rapide ─────────────────────────────────────────────────────
  bool get _emailsMatch =>
      _newEmail.isNotEmpty && _newEmail == _confirmEmail;

  bool get _passwordsMatch =>
      _newPwdCtrl.text.isNotEmpty &&
      _newPwdCtrl.text == _confirmPwdCtrl.text;

  bool get _passwordLongEnough => _newPwdCtrl.text.length >= 8;

  // ── Sauvegarde (placeholder) ──────────────────────────────────────────────
  void _save() {
    // TODO: appel API Firebase / backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.txtMailPwdSave,
          style: AppTextStyles.text.copyWith(color: AppColors.trottleWhite),
        ),
        backgroundColor: AppColors.trottleDark,
        behavior: SnackBarBehavior.floating,
      ),
    );
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

                // ── Titre ──────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Text(
                    l.txtSettingsMailPassword,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.title
                        .copyWith(color: AppColors.trottleWhite),
                  ),
                ),

                // ── Stroke ─────────────────────────────────────────────────
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 0.5,
                  color: AppColors.trottleDark,
                ),

                // ── Corps scrollable ───────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                        // ══ SECTION E-MAIL ══════════════════════════════════
                        _SectionLabel(text: l.txtMailPwdEmailSection),

                        FieldRow(
                          icon: Icons.alternate_email,
                          label: l.txtMailPwdNewEmail,
                          initialValue: '',
                          hintText: l.txtMailPwdNewEmailHint,
                          keyboardType: TextInputType.emailAddress,
                          divider: true,
                          onChanged: (v) => setState(() => _newEmail = v),
                        ),
                        FieldRow(
                          icon: Icons.alternate_email,
                          label: l.txtMailPwdConfirmEmail,
                          initialValue: '',
                          hintText: l.txtMailPwdNewEmailHint,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (v) => setState(() => _confirmEmail = v),
                        ),

                        // Indicateur de correspondance e-mail
                        if (_newEmail.isNotEmpty || _confirmEmail.isNotEmpty)
                          _MatchHint(match: _emailsMatch),

                        _InfoText(text: l.txtMailPwdInfoEmail),

                        const SizedBox(height: 20),
                        _Stroke(),
                        const SizedBox(height: 8),

                        // ══ SECTION MOT DE PASSE ════════════════════════════
                        _SectionLabel(text: l.txtMailPwdPasswordSection),

                        _PwdRow(
                          label: l.txtMailPwdCurrent,
                          hint: l.txtMailPwdHint,
                          controller: _currentPwdCtrl,
                          visible: _currentVisible,
                          onToggle: () => setState(
                              () => _currentVisible = !_currentVisible),
                          divider: true,
                        ),
                        _PwdRow(
                          label: l.txtMailPwdNew,
                          hint: l.txtMailPwdHint,
                          controller: _newPwdCtrl,
                          visible: _newVisible,
                          onToggle: () => setState(
                              () => _newVisible = !_newVisible),
                          divider: true,
                          onChanged: (_) => setState(() {}),
                        ),
                        _PwdRow(
                          label: l.txtMailPwdConfirmNew,
                          hint: l.txtMailPwdHint,
                          controller: _confirmPwdCtrl,
                          visible: _confirmVisible,
                          onToggle: () => setState(
                              () => _confirmVisible = !_confirmVisible),
                          onChanged: (_) => setState(() {}),
                        ),

                        // Indicateur de correspondance mot de passe
                        if (_newPwdCtrl.text.isNotEmpty ||
                            _confirmPwdCtrl.text.isNotEmpty)
                          _MatchHint(match: _passwordsMatch),

                        // Indicateur longueur minimum
                        if (_newPwdCtrl.text.isNotEmpty &&
                            !_passwordLongEnough)
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(44, 4, 20, 0),
                            child: Text(
                              '↑ Minimum 8 caractères',
                              style: AppTextStyles.text.copyWith(
                                  color: AppColors.trottleFerrari,
                                  fontSize: 11),
                            ),
                          ),

                        _InfoText(text: l.txtMailPwdInfoPassword),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // ── Bouton Enregistrer fixe ────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: Center(
                    child: GestureDetector(
                      onTap: _save,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.trottleLightBlue,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          l.txtMailPwdSave,
                          style: AppTextStyles.hashtag
                              .copyWith(color: AppColors.trottleWhite),
                        ),
                      ),
                    ),
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

// ── Widgets internes ──────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.text.copyWith(
          color: AppColors.trottleMidGray,
          letterSpacing: 1.2,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _InfoText extends StatelessWidget {
  const _InfoText({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(44, 8, 20, 0),
      child: Text(
        text,
        style: AppTextStyles.text.copyWith(
          color: AppColors.trottleGray,
          fontSize: 11,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class _MatchHint extends StatelessWidget {
  const _MatchHint({required this.match});
  final bool match;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(44, 4, 20, 0),
      child: Text(
        match ? '✓ Identiques' : '✗ Ne correspondent pas',
        style: AppTextStyles.text.copyWith(
          color: match ? AppColors.trottleMain : AppColors.trottleFerrari,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _Stroke extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 0.5,
      color: AppColors.trottleDark,
    );
  }
}

// ── Ligne mot de passe (obscure + œil) ───────────────────────────────────────

class _PwdRow extends StatelessWidget {
  const _PwdRow({
    required this.label,
    required this.hint,
    required this.controller,
    required this.visible,
    required this.onToggle,
    this.divider = false,
    this.onChanged,
  });

  final String                  label;
  final String                  hint;
  final TextEditingController   controller;
  final bool                    visible;
  final VoidCallback            onToggle;
  final bool                    divider;
  final ValueChanged<String>?   onChanged;

  static const double _h  = 48;
  static const double _hm = 20;
  static const double _is = 24;
  static const double _tw = 120;
  static const double _g  = 12;

  @override
  Widget build(BuildContext context) {
    final style =
        AppTextStyles.text.copyWith(color: AppColors.trottleWhite);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _hm),
      height: _h,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: divider ? 1 : 0,
            color: divider ? AppColors.trottleDark : Colors.transparent,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: _is,
            height: _is,
            child: Icon(Icons.lock_outline,
                color: AppColors.trottleMidGray, size: _is),
          ),
          const SizedBox(width: _g),
          SizedBox(
            width: _tw,
            child: Text(label, style: style),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: !visible,
              style: style,
              cursorColor: AppColors.trottleMain,
              onChanged: onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
                hintText: hint,
                hintStyle: AppTextStyles.text
                    .copyWith(color: AppColors.trottleWhite),
                suffixIcon: GestureDetector(
                  onTap: onToggle,
                  behavior: HitTestBehavior.opaque,
                  child: Icon(
                    visible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.trottleMidGray,
                    size: 18,
                  ),
                ),
                suffixIconConstraints:
                    const BoxConstraints(minWidth: 28, minHeight: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
