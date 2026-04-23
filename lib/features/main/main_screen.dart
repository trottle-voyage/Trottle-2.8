import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/services/gps_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/models/photo_item.dart';
import '../../core/widgets/photo_card.dart';
import '../../core/widgets/photo_detail_sheet.dart';
import '../nav/route_screen.dart';
import '../profile/profile_screen.dart';
import 'search_popup.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GpsService      _gps           = GpsService.instance;
  final MapController   _mapController = MapController();
  bool _menuOpen   = false;
  bool _searchOpen = false;

  static final List<PhotoItem> _photos = [
    PhotoItem(
      imageAsset:  'assets/photos/img_01.webp',
      hashtag:     'Yoda',
      city:        'Dagobah',
      flag:        '🌿',
      title:       'La cabane de Yoda',
      keywords:    ['Statue', 'Insolite', 'Patrimoine'],
      dateLabel:   'Le 12 mai 2025',
      user:        'ObiWanKenobi',
      description: 'La cabane de Yoda, nichée dans les marécages de Dagobah, '
          'est un symbole de sagesse et d\'humilité. Ce maître Jedi légendaire '
          'y vécut ses dernières années en exil, loin des conflits de la galaxie.',
    ),
    PhotoItem(
      imageAsset:  'assets/photos/img_02.webp',
      hashtag:     'Dark Vador',
      city:        'Mustafar',
      flag:        '🔴',
      title:       'Château de Dark Vador',
      keywords:    ['Monument', 'Insolite'],
      dateLabel:   'Le 3 juin 2025',
      user:        'DarthSidious',
      description: 'Érigé sur la lave de Mustafar, le château de Vador '
          'est à la fois forteresse et lieu de méditation. Son architecture '
          'sombre reflète la dualité entre la Force et l\'Obscurité.',
    ),
    PhotoItem(
      imageAsset:  'assets/photos/img_03.webp',
      hashtag:     'Luke',
      city:        'Tatooine',
      flag:        '☀️',
      title:       'Ferme des Lars',
      keywords:    ['Lieu de tournage', 'Patrimoine'],
      dateLabel:   'Le 18 juillet 2025',
      user:        'LukeSkywalker',
      description: 'La ferme souterraine des Lars sur Tatooine, où Luke grandit, '
          'est devenue un lieu culte pour les fans du monde entier.',
    ),
    PhotoItem(
      imageAsset:  'assets/photos/img_04.webp',
      hashtag:     'Obi-Wan',
      city:        'Coruscant',
      flag:        '🌆',
      title:       'Temple Jedi',
      keywords:    ['Monument', 'Patrimoine', 'Randonnée'],
      dateLabel:   'Le 28 août 2025',
      user:        'ObiWanKenobi',
      description: 'Le Temple Jedi de Coruscant fut le siège de l\'Ordre pendant '
          'des millénaires. Aujourd\'hui classé, il témoigne de la grandeur '
          'd\'une civilisation disparue.',
    ),
    PhotoItem(
      imageAsset:  'assets/photos/img_05.webp',
      hashtag:     'R2-D2',
      city:        'Naboo',
      flag:        '💧',
      title:       'Palais Royal de Naboo',
      keywords:    ['Monument', 'Insolite'],
      dateLabel:   'Le 5 septembre 2025',
      user:        'AnakinSkywalker',
      description: 'Le palais royal de Naboo est l\'une des architectures '
          'les plus élégantes de la galaxie. Ses jardins aquatiques et ses '
          'coupoles dorées en font un joyau du patrimoine universel.',
    ),
    PhotoItem(
      imageAsset:  'assets/photos/img_06.webp',
      hashtag:     'Chewbacca',
      city:        'Kashyyyk',
      flag:        '🌲',
      title:       'Forêt de Kashyyyk',
      keywords:    ['Randonnée', 'Patrimoine'],
      dateLabel:   'Le 1 octobre 2025',
      user:        'HanSolo',
      description: 'Les gigantesques wroshyr de Kashyyyk s\'élèvent à '
          'plusieurs centaines de mètres. Une randonnée dans leurs cimes '
          'offre des panoramas à couper le souffle.',
    ),
    PhotoItem(
      imageAsset:  'assets/photos/img_07.webp',
      hashtag:     'Han Solo',
      city:        'Corellia',
      flag:        '🚀',
      title:       'Chantiers navals de Corellia',
      keywords:    ['Insolite', 'Lieu de tournage'],
      dateLabel:   'Le 15 octobre 2025',
      user:        'HanSolo',
      description: 'Les chantiers navals de Corellia, berceau du Faucon '
          'Millenium, sont un haut lieu de la culture spatiale. Visites '
          'guidées disponibles toute l\'année.',
    ),
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

  // Hauteur bandeau : padding ListView (12+42) + hauteur PhotoCard (voir PhotoCard.intrinsicHeight).
  static final double _bandeauH =
      12 + 42 + PhotoCard.intrinsicHeight(128);
  static const double _gap       = 10;
  static const double _mainSize  = 42;
  static const double _buttSize  = 36;
  static const double _rightEdge = 10;

  static final double _mainBottom  = _bandeauH + _gap;
  static const double _mainCenterR = _rightEdge + _mainSize / 2;            // 31 (depuis right)
  static final double _mainCenterB = _mainBottom + _mainSize / 2;

  // Position de repli : tous les cercles secondaires partent du centre de menuButt
  static final double _closedBottom = _mainBottom + (_mainSize - _buttSize) / 2;
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
              color: AppColors.trottleBgDark.withValues(alpha: 0.9),
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
      (child: const Icon(Icons.my_location,      color: AppColors.trottleWhite, size: 20) as Widget?,
       onTap: _recenterMap as VoidCallback?),
      // H02 — voiture
      (child: const Icon(Icons.directions_car_outlined, color: AppColors.trottleWhite, size: 20) as Widget?,
       onTap: null as VoidCallback?),
      // H01 — carte
      (child: const Icon(Icons.map_outlined,      color: AppColors.trottleWhite, size: 20) as Widget?,
       onTap: null as VoidCallback?),
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
      // V04 — loupe
      (child: const Icon(Icons.search,            color: AppColors.trottleWhite, size: 20) as Widget?,
       onTap: (() => setState(() => _searchOpen = !_searchOpen)) as VoidCallback?),
      // V03 — circuit
      (child: const Icon(Icons.route_outlined,    color: AppColors.trottleWhite, size: 20) as Widget?,
       onTap: _openRoute as VoidCallback?),
      // V02 — appareil photo +
      (child: const Icon(Icons.add_a_photo_outlined, color: AppColors.trottleWhite, size: 20) as Widget?,
       onTap: null as VoidCallback?),
      // V01 — profil
      (child: const Icon(Icons.person,            color: AppColors.trottleWhite, size: 20) as Widget?,
       onTap: _openProfile as VoidCallback?),
    ];

    return List.generate(configs.length, (i) {
      final cfg = configs[i];
      const double openRight  = _mainCenterR - _buttSize / 2;
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

          // ── Popup recherche ──────────────────────────────────────────────────
          Positioned(
            left:   8,
            right:  8,
            bottom: _bandeauH + _mainSize + _gap * 2,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _searchOpen ? 1.0 : 0.0,
              child: IgnorePointer(
                ignoring: !_searchOpen,
                child: SearchPopup(
                  onClose: () => setState(() => _searchOpen = false),
                ),
              ),
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
                    color: AppColors.trottleBgDark.withValues(alpha: 0.9),
                  ),
                  padding: const EdgeInsets.only(top: 12, bottom: 42),
                  height: _bandeauH,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    itemCount: _photos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => PhotoCard(
                      item:       _photos[i],
                      onImageTap: () =>
                          showPhotoDetail(context, _photos, i),
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
