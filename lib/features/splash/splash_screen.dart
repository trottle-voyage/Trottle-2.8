import 'dart:async';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_text_styles.dart';

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

  // Champs de saisie
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  // Fondu du cadre
  bool _frameVisible = false;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
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
    super.dispose();
  }

  IconData _batteryIcon() {
    if (_batteryState == BatteryState.charging) return Icons.battery_charging_full;
    if (_batteryLevel >= 90) return Icons.battery_full;
    if (_batteryLevel >= 70) return Icons.battery_5_bar;
    if (_batteryLevel >= 50) return Icons.battery_4_bar;
    if (_batteryLevel >= 30) return Icons.battery_3_bar;
    if (_batteryLevel >= 15) return Icons.battery_2_bar;
    return Icons.battery_alert;
  }

  // Cadre bouton social (72x35px, blanc, radius 7)
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

  // Champ de saisie avec bordure dégradée trottleStroke
  Widget _inputField({
    required String hint,
    TextEditingController? controller,
    bool obscure = false,
    bool showEye = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
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
        child: TextField(
          controller: controller,
          obscureText: obscure && !_passwordVisible,
          keyboardType: keyboardType,
          style: AppTextStyles.text.copyWith(color: AppColors.trottleLightGray),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.text.copyWith(color: AppColors.trottleLightGray),
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            suffixIcon: showEye
                ? IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      size: 16,
                      color: AppColors.trottleLightGray,
                    ),
                    onPressed: () =>
                        setState(() => _passwordVisible = !_passwordVisible),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 16,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}';
    final hasWifi = _connectivity.contains(ConnectivityResult.wifi);
    final hasMobile = _connectivity.contains(ConnectivityResult.mobile);

    return Scaffold(
      backgroundColor: AppColors.trottleMain,
      body: Stack(
        children: [
          // Image de fond
          SizedBox.expand(
            child: Image.asset(
              'assets/images/main_logo.webp',
              fit: BoxFit.cover,
            ),
          ),
          // Cadre de connexion
          Positioned(
            bottom: 70,
            left: 10,
            right: 10,
            height: 460,
            child: AnimatedOpacity(
              opacity: _frameVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 400),
              child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [AppDecorations.dropShadow],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Fill : blur + trottleCadre (fond semi-transparent)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: AppDecorations.bgBlur,
                      child: Container(
                        decoration: AppDecorations.trottleCadre,
                        child: Center(
                          child: SizedBox(
                            width: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Titre
                                Text(
                                  'Connexion', // txtLoginTitle
                                  style: AppTextStyles.title.copyWith(
                                    color: AppColors.trottleWhite,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Label e-mail
                                Text(
                                  'e-mail ou utilisateur', // txtLoginEmail
                                  style: AppTextStyles.text.copyWith(
                                    color: AppColors.trottleWhite,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Champ e-mail
                                _inputField(
                                  hint: 'utilisateur@mail.com', // txtLoginEmailHint
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 16),
                                // Label mot de passe
                                Text(
                                  'Mot de passe', // txtLoginPassword
                                  style: AppTextStyles.text.copyWith(
                                    color: AppColors.trottleWhite,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Champ mot de passe
                                _inputField(
                                  hint: 'mot de passe', // txtLoginPasswordHint
                                  controller: _passwordController,
                                  obscure: true,
                                  showEye: true,
                                ),
                                const SizedBox(height: 10),
                                // Mot de passe oublié
                                Text(
                                  'Mot de passe oublié ?', // txtLoginForgotPassword
                                  style: AppTextStyles.text.copyWith(
                                    color: AppColors.trottleWhite,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Bouton Se connecter
                                Container(
                                  width: double.infinity,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.trottleMain,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Se connecter', // txtLoginButton
                                      style: AppTextStyles.title.copyWith(
                                        color: AppColors.trottleWhite,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Ou continuer avec
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Ou continuer avec', // txtLoginOrContinueWith
                                    style: AppTextStyles.text.copyWith(
                                      color: AppColors.trottleWhite,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // 3 boutons sociaux
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _socialBox(
                                      icon: const Icon(Icons.facebook,
                                          color: Color(0xFF1877F2), size: 20),
                                    ),
                                    _socialBox(
                                      icon: const SizedBox.shrink(), // Apple — à ajouter plus tard
                                    ),
                                    _socialBox(
                                      icon: Text('G',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            foreground: Paint()
                                              ..shader = const LinearGradient(
                                                colors: [
                                                  Color(0xFF4285F4),
                                                  Color(0xFFEA4335),
                                                ],
                                              ).createShader(
                                                  const Rect.fromLTWH(0, 0, 20, 20)),
                                          )),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Pas encore de compte ?
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Pas encore de compte ?', // txtLoginCreateAccount1
                                    style: AppTextStyles.text.copyWith(
                                      color: AppColors.trottleWhite,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Créez-le gratuitement
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Créez-le gratuitement', // txtLoginCreateAccount2
                                    style: AppTextStyles.textBold.copyWith(
                                      color: AppColors.trottleWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Stroke : contour dégradé via CustomPainter (non interactif)
                  IgnorePointer(
                    child: CustomPaint(
                      painter: _GradientBorderPainter(),
                    ),
                  ),
                ],
              ),
            ),
            ),
          ),
          // Version en bas au centre
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                AppConstants.infoVersion,
                style: AppTextStyles.subTitleMedium.copyWith(
                  color: AppColors.trottleWhite,
                ),
              ),
            ),
          ),
          // Barre de statut
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    timeStr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(hasWifi ? Icons.wifi : Icons.wifi_off,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 6),
                      Icon(
                          hasMobile
                              ? Icons.signal_cellular_alt
                              : Icons.signal_cellular_off,
                          color: Colors.white,
                          size: 20),
                      const SizedBox(width: 6),
                      Icon(_batteryIcon(), color: Colors.white, size: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Peint uniquement le contour dégradé du cadre (trottleStroke)
class _GradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(24));
    final paint = Paint()
      ..shader = AppDecorations.trottleStroke.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.2;
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_GradientBorderPainter oldDelegate) => false;
}
