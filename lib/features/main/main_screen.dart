import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/services/gps_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_text_styles.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GpsService      _gps           = GpsService.instance;
  final MapController   _mapController = MapController();
  List<String> _imageUrls    = [];
  bool         _imagesLoading = false;
  String?      _storageError;
  bool         _menuOpen      = false;

  @override
  void initState() {
    super.initState();
    _gps.addListener(_onGpsChanged);
    _gps.fetchCurrentPosition();
    _loadImages();
  }

  @override
  void dispose() {
    _gps.removeListener(_onGpsChanged);
    super.dispose();
  }

  Future<void> _loadImages() async {
    setState(() => _imagesLoading = true);
    try {
      final urls = await StorageService.instance
          .listLastImages('64x64', count: 10);
      if (mounted) setState(() => _imageUrls = urls);
    } catch (e) {
      debugPrint('StorageService error: $e');
      if (mounted) setState(() => _storageError = e.toString());
    } finally {
      if (mounted) setState(() => _imagesLoading = false);
    }
  }

  // ── Helpers menu ─────────────────────────────────────────────────────────

  static const double _bandeauH  = 152;
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

  Widget _menuCircle(double size, {String? icon}) => ClipOval(
        child: BackdropFilter(
          filter: AppDecorations.bgBlur,
          child: Container(
            width: size, height: size,
            decoration: BoxDecoration(
              color: AppColors.trottleBgDark.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: icon != null
                ? Center(
                    child: Image.asset(icon,
                        width: size * 0.6, height: size * 0.6),
                  )
                : null,
          ),
        ),
      );

  // Rangée horizontale : menuButtH01, H02, H03
  List<Widget> _buildMenuHRow() {
    return List.generate(3, (i) {
      final double openBottom = _mainCenterB - _buttSize / 2; // 165
      final double openRight  = _rightEdge + _mainSize + _gap + i * (_buttSize + _gap);
      return AnimatedPositioned(
        duration: _animDuration,
        curve: _animCurve,
        bottom: _menuOpen ? openBottom : _closedBottom,
        right:  _menuOpen ? openRight  : _closedRight,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _menuOpen ? 1.0 : 0.0,
          child: _menuCircle(_buttSize),
        ),
      );
    });
  }

  // Colonne verticale : menuButtV01, V02, V03, V04
  List<Widget> _buildMenuVCol() {
    return List.generate(4, (i) {
      final double openRight  = _mainCenterR - _buttSize / 2; // 13
      final double openBottom = _mainBottom + _mainSize + _gap + i * (_buttSize + _gap);
      return AnimatedPositioned(
        duration: _animDuration,
        curve: _animCurve,
        bottom: _menuOpen ? openBottom : _closedBottom,
        right:  _menuOpen ? openRight  : _closedRight,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _menuOpen ? 1.0 : 0.0,
          child: _menuCircle(_buttSize),
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

          // ── Bandeau images ───────────────────────────────────────────────
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: AppDecorations.bgBlur,
                child: Container(
                  color: AppColors.trottleBgDark.withOpacity(0.9),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  height: 128 + 24,
                  child: _imagesLoading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.trottleMain))
                      : _storageError != null
                          ? Center(child: Text(_storageError!,
                              style: AppTextStyles.subTitleMedium
                                  .copyWith(color: AppColors.trottleFerrari),
                              textAlign: TextAlign.center))
                          : _imageUrls.isEmpty
                              ? const SizedBox.shrink()
                              : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  itemCount: _imageUrls.length,
                                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                                  itemBuilder: (_, i) => ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      _imageUrls[i],
                                      width: 128, height: 128, fit: BoxFit.cover,
                                      loadingBuilder: (_, child, progress) =>
                                          progress == null ? child
                                              : Container(
                                                  width: 128, height: 128,
                                                  color: AppColors.trottleDark,
                                                  child: const Center(child: CircularProgressIndicator(
                                                      color: AppColors.trottleMain, strokeWidth: 2))),
                                    ),
                                  ),
                                ),
                ),
              ),
            ),
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
              child: _menuCircle(_mainSize, icon: 'assets/icones/trottle_32.webp'),
            ),
          ),
        ],
      ),
    );
  }
}
