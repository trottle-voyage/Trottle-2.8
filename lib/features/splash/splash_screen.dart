import 'dart:async';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/gps_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/app_localizations.dart';
import '../main/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Heure
  late Timer _timer;
  late DateTime _now;

  // Batterie
  final Battery _battery = Battery();
  int _batteryLevel = 100;
  BatteryState _batteryState = BatteryState.unknown;

  // Connectivité
  List<ConnectivityResult> _connectivity = [ConnectivityResult.none];

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

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
    _instagramFocus = FocusNode()..addListener(_onInstagramFocus);
    GpsService.instance.addListener(_onGpsChanged);
    _initBattery();
    _initConnectivity();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _frameVisible = true);
    });
  }

  Future<void> _initBattery() async {
    _batteryLevel = await _battery.batteryLevel;
    _batteryState = await _battery.batteryState;
    setState(() {});
    _battery.onBatteryStateChanged.listen((state) {
      setState(() => _batteryState = state);
    });
  }

  Future<void> _initConnectivity() async {
    _connectivity = await Connectivity().checkConnectivity();
    setState(() {});
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() => _connectivity = result);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
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

  IconData _batteryIcon() {
    if (_batteryState == BatteryState.charging) return Icons.battery_charging_full;
    if (_batteryLevel >= 90) return Icons.battery_full;
    if (_batteryLevel >= 70) return Icons.battery_5_bar;
    if (_batteryLevel >= 50) return Icons.battery_4_bar;
    if (_batteryLevel >= 30) return Icons.battery_3_bar;
    if (_batteryLevel >= 15) return Icons.battery_2_bar;
    return Icons.battery_alert;
  }

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
          onTap: () => setState(() => _showForgotPassword = true),
          child: _label(l.txtLoginForgotPassword),
        ),
        const SizedBox(height: 20),
        _primaryButton(l.txtLoginButton,
            onTap: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const MainScreen()))),
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
          onTap: () => setState(() => _showRegister = true),
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
        _backArrow(() => setState(() => _showForgotPassword = false)),
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
        _backArrow(() => setState(() => _showRegister = false)),
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
            onTap: () => setState(() {
                  _showRegister = false;
                  _showWelcome  = true;
                  GpsService.instance.fetchCurrentPosition();
                })),
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
            _backArrow(() => setState(() {
                  _showWelcome  = false;
                  _showRegister = true;
                })),
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
                        .copyWith(color: AppColors.trottleWhite.withOpacity(0.7)),
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

            _primaryButton(l.txtWelcomeCreateButton,
                onTap: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const MainScreen()))),
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

    final timeStr =
        '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}';
    final hasWifi   = _connectivity.contains(ConnectivityResult.wifi);
    final hasMobile = _connectivity.contains(ConnectivityResult.mobile);

    Widget currentForm;
    double frameHeight;
    if (_showForgotPassword) {
      currentForm = _buildForgotContent(l);
      frameHeight = 260.0;
    } else if (_showWelcome) {
      currentForm = _buildWelcomeContent(l);
      frameHeight = 780.0;
    } else if (_showRegister) {
      currentForm = _buildRegisterContent(l);
      frameHeight = 460.0;
    } else {
      currentForm = _buildLoginContent(l);
      frameHeight = 460.0;
    }

    return Scaffold(
      backgroundColor: AppColors.trottleMain,
      body: Stack(
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: frameHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [AppDecorations.dropShadow],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: AppDecorations.bgBlur,
                        child: Container(
                          decoration: AppDecorations.trottleCadre,
                          child: Center(
                            child: SizedBox(
                              width: 250,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: currentForm,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IgnorePointer(
                      child: CustomPaint(painter: _GradientBorderPainter()),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(AppConstants.infoVersion,
                  style: AppTextStyles.subTitleMedium
                      .copyWith(color: AppColors.trottleWhite)),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(timeStr,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Row(children: [
                    Icon(hasWifi ? Icons.wifi : Icons.wifi_off,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 6),
                    Icon(hasMobile
                            ? Icons.signal_cellular_alt
                            : Icons.signal_cellular_off,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 6),
                    Icon(_batteryIcon(), color: Colors.white, size: 20),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
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
