import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/gps_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/app_localizations.dart';
import '../infos/version_screen.dart';
import '../main/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Connexion
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  // Mot de passe oublié
  final TextEditingController _forgotEmailController = TextEditingController();

  // Inscription
  final TextEditingController _registerEmailController    = TextEditingController();
  final TextEditingController _registerPasswordController = TextEditingController();
  final TextEditingController _registerConfirmController  = TextEditingController();
  bool _registerPasswordVisible = false;
  bool _registerConfirmVisible  = false;

  // Bienvenue
  XFile? _profileImage;
  final TextEditingController _pseudoController    = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _cityController      = TextEditingController();
  late FocusNode _instagramFocus;
  DateTime? _birthDate;
  int _genderIndex = 0; // 0=Opt0, 1=Opt1, 2=Opt2
  int _profilIndex = 0; // 0=Opt1, 1=Opt2, 2=Opt3

  // Navigation
  bool _frameVisible       = false;
  bool _showForgotPassword = false;
  bool _showRegister       = false;
  bool _showWelcome        = false;

  // Slide
  late final AnimationController _slideController;
  Widget? _oldFrame;       // cadre sortant pendant le slide
  bool    _slideForward = true;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _oldFrame = null);
        }
      });
    _instagramFocus = FocusNode()..addListener(_onInstagramFocus);
    GpsService.instance.addListener(_onGpsChanged);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _frameVisible = true);
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _forgotEmailController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmController.dispose();
    _pseudoController.dispose();
    _instagramController.dispose();
    _cityController.dispose();
    _instagramFocus.dispose();
    GpsService.instance.removeListener(_onGpsChanged);
    super.dispose();
  }

  // ── GPS ───────────────────────────────────────────────────────────────────────

  void _onGpsChanged() {
    final city = GpsService.instance.valueCity;
    if (city != null && city.isNotEmpty && mounted) {
      setState(() => _cityController.text = city);
    }
  }

  // ── Instagram focus ──────────────────────────────────────────────────────────

  static const _igPrefix = 'Instagram.com/';

  void _onInstagramFocus() {
    if (_instagramFocus.hasFocus && _instagramController.text.isEmpty) {
      // Premier focus sur un champ vide : pose le préfixe et place le curseur
      _instagramController.value = const TextEditingValue(
        text: _igPrefix,
        selection: TextSelection.collapsed(offset: _igPrefix.length),
      );
    } else if (!_instagramFocus.hasFocus &&
        _instagramController.text == _igPrefix) {
      // Défocus sans avoir rien tapé après le préfixe : on vide pour réafficher le hint
      _instagramController.clear();
    }
  }

  // ── Image ─────────────────────────────────────────────────────────────────────

  Future<void> _pickImage() async {
    final XFile? img =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null && mounted) setState(() => _profileImage = img);
  }

  // ── Date ──────────────────────────────────────────────────────────────────────

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null && mounted) setState(() => _birthDate = date);
  }

  // ── Widgets réutilisables ─────────────────────────────────────────────────────

  Widget _fieldShell({required Widget child}) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        gradient: AppDecorations.trottleStroke,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(0.5),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.trottleWhite,
          borderRadius: BorderRadius.circular(4.5),
        ),
        child: child,
      ),
    );
  }

  Widget _inputField({
    required String hint,
    TextEditingController? controller,
    FocusNode? focusNode,
    bool obscureText = false,
    bool showEye = false,
    VoidCallback? onEyeTap,
    TextInputType keyboardType = TextInputType.text,
    String? prefixText,
    bool readOnly = false,
    Widget? suffixIconOverride,
  }) {
    Widget? suffix;
    if (showEye) {
      suffix = IconButton(
        icon: Icon(
          obscureText ? Icons.visibility_off : Icons.visibility,
          size: 16,
          color: AppColors.trottleLightGray,
        ),
        onPressed: onEyeTap,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        splashRadius: 16,
      );
    } else if (suffixIconOverride != null) {
      suffix = suffixIconOverride;
    }

    // prefix Widget (toujours affiché, même sans focus)
    final Widget? prefixWidget = prefixText != null
        ? Text(prefixText,
            style: AppTextStyles.text.copyWith(color: AppColors.trottleGray))
        : null;

    return _fieldShell(
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        readOnly: readOnly,
        style: AppTextStyles.text.copyWith(color: AppColors.trottleLightGray),
        decoration: InputDecoration(
          hintText: hint,
          prefix: prefixWidget,
          hintStyle: AppTextStyles.text.copyWith(color: AppColors.trottleLightGray),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          suffixIcon: suffix,
        ),
      ),
    );
  }

  Widget _tapField({
    required String label,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: _fieldShell(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(label,
                    style: AppTextStyles.text
                        .copyWith(color: AppColors.trottleLightGray),
                    overflow: TextOverflow.ellipsis),
              ),
              Icon(icon, size: 14, color: AppColors.trottleLightGray),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownField({
    required String value,
    required List<String> options,
    required void Function(String?) onChanged,
  }) {
    return _fieldShell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            isDense: true,
            icon: const Icon(Icons.arrow_drop_down,
                color: AppColors.trottleLightGray, size: 18),
            style: AppTextStyles.text.copyWith(color: AppColors.trottleLightGray),
            items: options
                .map((o) => DropdownMenuItem(
                    value: o,
                    child: Text(o,
                        style: AppTextStyles.text
                            .copyWith(color: AppColors.trottleLightGray))))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _socialBox({required Widget icon}) {
    return Container(
      width: 72,
      height: 35,
      decoration: BoxDecoration(
        color: AppColors.trottleWhite,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(child: icon),
    );
  }

  Widget _primaryButton(String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.trottleMain,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child: Text(label,
              style: AppTextStyles.title.copyWith(color: AppColors.trottleWhite)),
        ),
      ),
    );
  }

  Widget _backArrow(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.arrow_back, color: AppColors.trottleWhite, size: 20),
    );
  }

  // ── Slide navigation ──────────────────────────────────────────────────────────

  Widget _currentFormWidget(AppLocalizations l) {
    if (_showForgotPassword) return _buildForgotContent(l);
    if (_showWelcome) return _buildWelcomeContent(l);
    if (_showRegister) return _buildRegisterContent(l);
    return _buildLoginContent(l);
  }

  void _goToMain() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const MainScreen(),
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        ),
      ),
    );
  }

  void _slideTo({required bool forward, required VoidCallback updateFlags}) {
    final l = AppLocalizations.of(context)!;
    // Capture le panneau actuel AVANT de changer les flags
    final oldContent = _currentFormWidget(l);
    setState(() {
      _oldFrame = _buildFrame(oldContent);
      _slideForward = forward;
      updateFlags();
    });
    _slideController.forward(from: 0);
  }

  Widget _buildSlide({required Widget oldFrame, required Widget newFrame}) {
    final enterBegin = _slideForward
        ? const Offset(1.0, 0)
        : const Offset(-1.0, 0);
    final exitEnd = _slideForward
        ? const Offset(-1.0, 0)
        : const Offset(1.0, 0);

    final curved = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    );

    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        SlideTransition(
          position: Tween(begin: Offset.zero, end: exitEnd).animate(curved),
          child: oldFrame,
        ),
        SlideTransition(
          position: Tween(begin: enterBegin, end: Offset.zero).animate(curved),
          child: newFrame,
        ),
      ],
    );
  }

  // ── Cadre glassmorphique complet ─────────────────────────────────────────────

  Widget _buildFrame(Widget content) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [AppDecorations.dropShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: AppDecorations.bgBlur,
          child: Stack(
            children: [
              Container(
                decoration: AppDecorations.trottleCadre,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: SizedBox(
                      width: 250,
                      child: content,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _GradientBorderPainter()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) =>
      Text(text, style: AppTextStyles.text.copyWith(color: AppColors.trottleWhite));

  Widget _titleLabel(String text) =>
      Text(text, style: AppTextStyles.title.copyWith(color: AppColors.trottleWhite));

  Widget _socialRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _socialBox(icon: Image.asset('assets/icones/facebook_32.webp', width: 16, height: 16)),
        _socialBox(icon: Image.asset('assets/icones/apple_32.webp',    width: 16, height: 16)),
        _socialBox(icon: Image.asset('assets/icones/google_32.webp',   width: 16, height: 16)),
      ],
    );
  }

  // ── Formulaire Connexion ──────────────────────────────────────────────────────

  Widget _buildLoginContent(AppLocalizations l) {
    return Column(
      key: const ValueKey('login'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _titleLabel(l.txtLoginTitle),
        const SizedBox(height: 24),
        _label(l.txtLoginEmail),
        const SizedBox(height: 6),
        _inputField(
          hint: l.txtLoginEmailHint,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _label(l.txtLoginPassword),
        const SizedBox(height: 6),
        _inputField(
          hint: l.txtLoginPasswordHint,
          controller: _passwordController,
          obscureText: !_passwordVisible,
          showEye: true,
          onEyeTap: () => setState(() => _passwordVisible = !_passwordVisible),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _slideTo(
            forward: true,
            updateFlags: () => _showForgotPassword = true,
          ),
          child: _label(l.txtLoginForgotPassword),
        ),
        const SizedBox(height: 20),
        _primaryButton(l.txtLoginButton, onTap: _goToMain),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.center,
          child: _label(l.txtLoginOrContinueWith),
        ),
        const SizedBox(height: 12),
        _socialRow(),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.center,
          child: _label(l.txtLoginCreateAccount1),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => _slideTo(
            forward: true,
            updateFlags: () => _showRegister = true,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(l.txtLoginCreateAccount2,
                style: AppTextStyles.textBold.copyWith(color: AppColors.trottleWhite)),
          ),
        ),
      ],
    );
  }

  // ── Formulaire Mot de passe oublié ────────────────────────────────────────────

  Widget _buildForgotContent(AppLocalizations l) {
    return Column(
      key: const ValueKey('forgot'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _backArrow(() => _slideTo(
          forward: false,
          updateFlags: () => _showForgotPassword = false,
        )),
        const SizedBox(height: 16),
        _titleLabel(l.txtForgotPasswordTitle),
        const SizedBox(height: 16),
        _label(l.txtForgotPasswordEmail),
        const SizedBox(height: 6),
        _inputField(
          hint: l.txtForgotPasswordEmailHint,
          controller: _forgotEmailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        _primaryButton(l.txtForgotPasswordButton),
      ],
    );
  }

  // ── Formulaire Inscription ────────────────────────────────────────────────────

  Widget _buildRegisterContent(AppLocalizations l) {
    return Column(
      key: const ValueKey('register'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _backArrow(() => _slideTo(
          forward: false,
          updateFlags: () => _showRegister = false,
        )),
        const SizedBox(height: 16),
        _titleLabel(l.txtRegisterTitle),
        const SizedBox(height: 24),
        _label(l.txtRegisterEmail),
        const SizedBox(height: 6),
        _inputField(
          hint: l.txtRegisterEmailHint,
          controller: _registerEmailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        _label(l.txtRegisterPassword),
        const SizedBox(height: 6),
        _inputField(
          hint: l.txtRegisterPasswordHint,
          controller: _registerPasswordController,
          obscureText: !_registerPasswordVisible,
          showEye: true,
          onEyeTap: () =>
              setState(() => _registerPasswordVisible = !_registerPasswordVisible),
        ),
        const SizedBox(height: 12),
        _label(l.txtRegisterConfirmPassword),
        const SizedBox(height: 6),
        _inputField(
          hint: l.txtRegisterConfirmPasswordHint,
          controller: _registerConfirmController,
          obscureText: !_registerConfirmVisible,
          showEye: true,
          onEyeTap: () =>
              setState(() => _registerConfirmVisible = !_registerConfirmVisible),
        ),
        const SizedBox(height: 20),
        _primaryButton(l.txtRegisterNextButton,
            onTap: () => _slideTo(
                  forward: true,
                  updateFlags: () {
                    _showRegister = false;
                    _showWelcome  = true;
                    GpsService.instance.fetchCurrentPosition();
                  },
                )),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.center,
          child: _label(l.txtRegisterConnectWith),
        ),
        const SizedBox(height: 12),
        _socialRow(),
      ],
    );
  }

  // ── Formulaire Bienvenue ──────────────────────────────────────────────────────

  Widget _buildWelcomeContent(AppLocalizations l) {
    final birthLabel = _birthDate != null
        ? '${_birthDate!.day.toString().padLeft(2, '0')}/'
            '${_birthDate!.month.toString().padLeft(2, '0')}/'
            '${_birthDate!.year}'
        : l.txtWelcomeBirthHint;

    final genderOptions = [
      l.txtWelcomeGenderOpt0,
      l.txtWelcomeGenderOpt1,
      l.txtWelcomeGenderOpt2,
    ];
    final profilOptions = [
      l.txtWelcomeProfilOpt0,
      l.txtWelcomeProfilOpt1,
      l.txtWelcomeProfilOpt2,
      l.txtWelcomeProfilOpt3,
    ];

    return SizedBox(
      key: const ValueKey('welcome'),
      height: 720,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _backArrow(() => _slideTo(
                  forward: false,
                  updateFlags: () {
                    _showWelcome  = false;
                    _showRegister = true;
                  },
                )),
            const SizedBox(height: 12),
            _titleLabel(l.txtWelcomeTitle),
            const SizedBox(height: 16),

            // Pseudo
            _label(l.txtWelcomePseudo),
            const SizedBox(height: 6),
            _inputField(
              hint: l.txtWelcomePseudoHint,
              controller: _pseudoController,
            ),
            const SizedBox(height: 12),

            // Instagram
            _label(l.txtWelcomeInstagram),
            const SizedBox(height: 6),
            _inputField(
              hint: l.txtWelcomeInstagramHint,
              controller: _instagramController,
              focusNode: _instagramFocus,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    l.txtWelcomeInstagramDisclaimer,
                    style: AppTextStyles.subTitleMedium
                        .copyWith(color: AppColors.trottleWhite.withValues(alpha: 0.7)),
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(l.txtWelcomeInstagramInfoTitle,
                          style: AppTextStyles.title
                              .copyWith(color: AppColors.trottleDark)),
                      content: Text(l.txtWelcomeInstagramInfoBody,
                          style: AppTextStyles.text
                              .copyWith(color: AppColors.trottleDark)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ),
                  child: const Icon(Icons.info_outline,
                      size: 16, color: AppColors.trottleWhite),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Photo de profil
            _label(l.txtWelcomePP),
            const SizedBox(height: 6),
            _tapField(
              label: _profileImage?.name ?? l.txtWelcomePPHint,
              onTap: _pickImage,
              icon: Icons.upload_file,
            ),
            const SizedBox(height: 12),

            // Date de naissance
            _label(l.txtWelcomeBirth),
            const SizedBox(height: 6),
            _tapField(
              label: birthLabel,
              onTap: _pickDate,
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 12),

            // Genre
            _label(l.txtWelcomeGender),
            const SizedBox(height: 6),
            _dropdownField(
              value: genderOptions[_genderIndex],
              options: genderOptions,
              onChanged: (v) =>
                  setState(() => _genderIndex = genderOptions.indexOf(v!)),
            ),
            const SizedBox(height: 12),

            // Profil
            _label(l.txtWelcomeProfil),
            const SizedBox(height: 6),
            _dropdownField(
              value: profilOptions[_profilIndex],
              options: profilOptions,
              onChanged: (v) =>
                  setState(() => _profilIndex = profilOptions.indexOf(v!)),
            ),
            const SizedBox(height: 12),

            // Ville
            _label(l.txtWelcomeCity),
            const SizedBox(height: 6),
            _inputField(
              hint: l.txtWelcomeCity,
              controller: _cityController,
              suffixIconOverride: IconButton(
                icon: const Icon(Icons.my_location,
                    size: 16, color: AppColors.trottleMain),
                onPressed: GpsService.instance.fetchCurrentPosition,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 16,
              ),
            ),
            const SizedBox(height: 12),

            const SizedBox(height: 12),
            _label(l.txtWelcomeSearch),
            const SizedBox(height: 20),

            _primaryButton(l.txtWelcomeCreateButton, onTap: _goToMain),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    final newFrame = _buildFrame(_currentFormWidget(l));

    return Scaffold(
      backgroundColor: AppColors.trottleMain,
      body: ClipRect(
        child: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/images/main_logo.webp', fit: BoxFit.cover),
          ),
          Positioned(
            bottom: 76,
            left: 16,
            right: 16,
            child: AnimatedOpacity(
              opacity: _frameVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 400),
              child: _oldFrame != null
                  ? _buildSlide(oldFrame: _oldFrame!, newFrame: newFrame)
                  : newFrame,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 400),
                    reverseTransitionDuration: const Duration(milliseconds: 400),
                    pageBuilder: (_, __, ___) => const VersionScreen(),
                    transitionsBuilder: (_, animation, __, child) =>
                        SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      )),
                      child: child,
                    ),
                  ),
                ),
                child: Text(AppConstants.infoVersion,
                    style: AppTextStyles.subTitleMedium
                        .copyWith(color: AppColors.trottleWhite)),
              ),
            ),
          ),
        ],
      ), // Stack
      ), // ClipRect
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect  = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(24));
    final paint = Paint()
      ..shader      = AppDecorations.trottleStroke.createShader(rect)
      ..style       = PaintingStyle.stroke
      ..strokeWidth = 0.2;
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_GradientBorderPainter oldDelegate) => false;
}
