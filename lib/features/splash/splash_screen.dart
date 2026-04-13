import 'dart:async';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
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

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
    _initBattery();
    _initConnectivity();
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

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}';
    final hasWifi = _connectivity.contains(ConnectivityResult.wifi);
    final hasMobile = _connectivity.contains(ConnectivityResult.mobile);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image de fond
          SizedBox.expand(
            child: Image.asset(
              'assets/images/main_logo.webp',
              fit: BoxFit.cover,
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
                  // Heure en haut à gauche
                  Text(
                    timeStr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Icônes en haut à droite
                  Row(
                    children: [
                      Icon(
                        hasWifi ? Icons.wifi : Icons.wifi_off,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        hasMobile
                            ? Icons.signal_cellular_alt
                            : Icons.signal_cellular_off,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        _batteryIcon(),
                        color: Colors.white,
                        size: 20,
                      ),
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
