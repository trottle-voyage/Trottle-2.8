import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/services/gps_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/models/photo_item.dart';
import '../../core/widgets/photo_card.dart';
import '../nav/route_screen.dart';
import '../profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GpsService      _gps           = GpsService.instance;
  final MapController   _mapController = MapController();
  bool _menuOpen = false;

  static final List<PhotoItem> _photos = [
    PhotoItem(imageAsset: 'assets/photos/img_01.webp', hashtag: 'Yoda',       city: 'Dagobah',   flag: '🌿'),
    PhotoItem(imageAsset: 'assets/photos/img_02.webp', hashtag: 'Dark Vador', city: 'Mustafar',  flag: '🔴'),
    PhotoItem(imageAsset: 'assets/photos/img_03.webp', hashtag: 'Luke',       city: 'Tatooine',  flag: '☀️'),
    PhotoItem(imageAsset: 'assets/photos/img_04.webp', hashtag: 'Obi-Wan',    city: 'Coruscant', flag: '🌆'),
    PhotoItem(imageAsset: 'assets/photos/img_05.webp', hashtag: 'R2-D2',      city: 'Naboo',     flag: '💧'),
    PhotoItem(imageAsset: 'assets/photos/img_06.webp', hashtag: 'Chewbacca',  city: 'Kashyyyk',  flag: '🌲'),
    PhotoItem(imageAsset: 'assets/photos/img_07.webp', hashtag: 'Han Solo',   city: 'Corellia',  flag: '🚀'),
  ];

  @override
  void initState() {
    super.initState();
    _gps.addListener(_onGpsChanged);
    _gps.fetchCurrentPosition();
  }

  @override
  void dispose() {
    _gps.removeListener(_onGpsChanged);
    super.dispose();
  }

  // ── Helpers menu ─────────────────────────────────────────────────────────

  static const double _bandeauH  = 226; // 120 photo + 52 info + 12 top + 42 bottom
  static const double _gap       = 10;
  static const double _mainSize  = 42;
  static const double _buttSize  = 36;
  static const double _rightEdge = 10;

  static const double _mainBottom  = _bandeauH + _gap;                      // 162
  static const double _mainCenterR = _rightEdge + _mainSize / 2;            // 31 (depuis right)
  static const double _mainCenterB = _mainBottom + _mainSize / 2;           // 183 (depuis bottom)

  // Position de repli : tous les cercles secondaires partent du centre de menuButt
  static const double _closedBottom = _mainBottom + (_mainSize - _buttSize) / 2; // 165
  static const double _closedRight  = _rightEdge + (_mainSize - _buttSize) / 2;  // 13

  static const Duration _animDuration = Duration(milliseconds: 350);
  static const Curve    _animCurve    = Curves.easeOutBack;

  Widget _menuCircle(double size, {Widget? child, VoidCallback? onTap}) {
    final circle = SizedBox(
      width: size, height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: BackdropFilter(
          filter: AppDecorations.bgBlur,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.trottleBgDark.withOpacity(0.9),
            ),
            child: child != null ? Center(child: child) : null,
          ),
        ),
      ),
    );
    return onTap != null
        ? GestureDetector(onTap: onTap, child: circle)
        : circle;
  }

  void _recenterMap() {
    if (_gps.valueGPS != null) {
      try { _mapController.moveAndRotate(_gps.valueGPS!, 17, 0); } catch (_) {}
    }
  }

  void _openProfile() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const ProfileScreen(),
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
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
    );
  }

  void _openRoute() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const RouteScreen(),
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
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
    );
  }

  // Rangée horizontale — index 0 = H03 (le plus à droite), index 2 = H01
  List<Widget> _buildMenuHRow() {
    final configs = [
      // H03 — recentrage carte
      (child: const Icon(Icons.my_location, color: AppColors.trottleWhite, size: 20),
       onTap: _recenterMap as VoidCallback?),
      // H02 — vide pour l'instant
      (child: null as Widget?, onTap: null as VoidCallback?),
      // H01 — vide pour l'instant
      (child: null as Widget?, onTap: null as VoidCallback?),
    ];

    return List.generate(configs.length, (i) {
      final cfg = configs[i];
      final double openBottom = _mainCenterB - _buttSize / 2;
      final double openRight  = _rightEdge + _mainSize + _gap + i * (_buttSize + _gap);
      return AnimatedPositioned(
        duration: _animDuration, curve: _animCurve,
        bottom: _menuOpen ? openBottom : _closedBottom,
        right:  _menuOpen ? openRight  : _closedRight,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _menuOpen ? 1.0 : 0.0,
          child: _menuCircle(_buttSize, child: cfg.child, onTap: cfg.onTap),
        ),
      );
    });
  }

  // Colonne verticale — index 0 = V04 (le plus bas), index 3 = V01 (le plus haut)
  List<Widget> _buildMenuVCol() {
    final configs = [
      // V04 — vide pour l'instant
      (child: null as Widget?, onTap: null as VoidCallback?),
      // V03 — vide pour l'instant
      (child: null as Widget?, onTap: null as VoidCallback?),
      // V02 — parcours
      (child: const Icon(Icons.route_outlined, color: AppColors.trottleWhite, size: 20),
       onTap: _openRoute as VoidCallback?),
      // V01 — profil
      (child: const Icon(Icons.person, color: AppColors.trottleWhite, size: 20),
       onTap: _openProfile as VoidCallback?),
    ];

    return List.generate(configs.length, (i) {
      final cfg = configs[i];
      final double openRight  = _mainCenterR - _buttSize / 2;
      final double openBottom = _mainBottom + _mainSize + _gap + i * (_buttSize + _gap);
      return AnimatedPositioned(
        duration: _animDuration, curve: _animCurve,
        bottom: _menuOpen ? openBottom : _closedBottom,
        right:  _menuOpen ? openRight  : _closedRight,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _menuOpen ? 1.0 : 0.0,
          child: _menuCircle(_buttSize, child: cfg.child, onTap: cfg.onTap),
        ),
      );
    });
  }

  void _onGpsChanged() {
    if (!mounted) return;
    setState(() {});
    if (_gps.valueGPS != null && !_gps.loading) {
      // Attend que la carte soit rendue avant de la déplacer
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          _mapController.move(_gps.valueGPS!, 17);
        } catch (_) {}
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_gps.loading) {
      return const Scaffold(
        backgroundColor: AppColors.trottleBgDark,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.trottleMain),
        ),
      );
    }

    if (_gps.error != null) {
      return Scaffold(
        backgroundColor: AppColors.trottleBgDark,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_off,
                  color: AppColors.trottleLightGray, size: 48),
              const SizedBox(height: 16),
              Text(_gps.error!,
                  style: AppTextStyles.text
                      .copyWith(color: AppColors.trottleWhite)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _gps.fetchCurrentPosition,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.trottleMain),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.trottleBgDark,
      body: Stack(
        children: [
          FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _gps.valueGPS ?? const LatLng(48.8566, 2.3522),
          initialZoom: 17,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.trottle.trottle',
          ),
          MarkerLayer(
            markers: [
              if (_gps.valueGPS != null)
                Marker(
                  point: _gps.valueGPS!,
                  child: const Icon(Icons.my_location,
                      color: AppColors.trottleMain, size: 28),
                ),
            ],
          ),
        ],
      ),


          // ── Menu ─────────────────────────────────────────────────────────
          // Constantes de positionnement
          // bandeauH = 152, espacement = 10, main = 42, butt = 36
          // Centre horizontal du menu : right=10, largeur=42 → centre à right=31
          // Centre vertical H-row : bottom = 152+10 + 21 = 183 → bottom butt36 = 183-18 = 165

          // menuButtH01 – H02 – H03 (rangée horizontale, 36px)
          ..._buildMenuHRow(),

          // menuButtV01 – V02 – V03 – V04 (colonne verticale, 36px)
          ..._buildMenuVCol(),

          // menuButt — bouton principal (42px)
          Positioned(
            bottom: _mainBottom, right: _rightEdge,
            child: GestureDetector(
              onTap: () => setState(() => _menuOpen = !_menuOpen),
              child: _menuCircle(_mainSize,
                  child: Image.asset('assets/icones/trottle_32.webp',
                      width: _mainSize * 0.6, height: _mainSize * 0.6)),
            ),
          ),

          // ── Bandeau carrousel ───────────────────────────────────────────────
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: AppDecorations.bgBlur,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.trottleBgDark.withOpacity(0.9),
                  ),
                  padding: const EdgeInsets.only(top: 12, bottom: 42),
                  height: _bandeauH,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    itemCount: _photos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => PhotoCard(
                      item:  _photos[i],
                      width: 120,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
