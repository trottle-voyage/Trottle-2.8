import 'dart:ui';
import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Card : top aligné sous le papillon, étirée jusqu'au footer
          Positioned(
            top: MediaQuery.of(context).size.height * 0.36,
            left: 20,
            right: 20,
            bottom: 36,
            child: _buildCard(context),
          ),
          // Footer en bas
          const Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Text(
              'Trottle 2018-2026 • v2.8.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28.46),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0095FF).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(28.46),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 0.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Titre
              const Text(
                'Connexion',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),

              // E-mail
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _label('E-mail ou utilisateur'),
                  const SizedBox(height: 5),
                  _field(
                    controller: _emailController,
                    hint: 'utilisateur@mail.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),

              // Mot de passe
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _label('Mot de passe'),
                  const SizedBox(height: 5),
                  _field(
                    controller: _passwordController,
                    hint: 'mot de passe',
                    obscure: _obscurePassword,
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Mot de passe oublié
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => _showForgotPassword(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Mot de passe oublié ?',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),

              // Bouton Se connecter
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0099FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Se connecter',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),

              // ou continuer avec + sociaux
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                            color: Colors.white.withValues(alpha: 0.35),
                            thickness: 0.5),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'ou continuer avec :',
                          style: TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                            color: Colors.white.withValues(alpha: 0.35),
                            thickness: 0.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialBtn(icon: Icons.facebook, color: const Color(0xFF1877F2)),
                      const SizedBox(width: 16),
                      _socialBtn(icon: Icons.apple, color: Colors.white),
                      const SizedBox(width: 16),
                      _socialBtn(label: 'G', color: const Color(0xFFDB4437)),
                    ],
                  ),
                ],
              ),

              // Pas encore de compte
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Pas encore de compte ? ',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  GestureDetector(
                    onTap: () => _showRegister(context),
                    child: const Text(
                      'Créez-le gratuitement',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      );

  Widget _field({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Color(0xFF222222), fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.88),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: suffixIcon,
              )
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        isDense: true,
      ),
    );
  }

  Widget _socialBtn({IconData? icon, String? label, required Color color}) {
    return Container(
      width: 52,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white30, width: 0.5),
      ),
      child: Center(
        child: icon != null
            ? Icon(icon, color: color, size: 26)
            : Text(
                label!,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  void _showForgotPassword(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black38,
      builder: (_) => const ForgotPasswordScreen(),
    );
  }

  void _showRegister(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black38,
      builder: (_) => const RegisterScreen(),
    );
  }
}
