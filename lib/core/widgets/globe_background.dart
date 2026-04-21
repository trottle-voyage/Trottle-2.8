import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';

/// Fond décoratif :
///   • Dégradé linéaire haut-gauche (clair) → bas-droite (sombre)
///   • Quart de globe animé en filigrane dans le coin bas-droite.
///     Inclut les contours simplifiés des continents.
class GlobeBackground extends StatefulWidget {
  const GlobeBackground({
    super.key,
    this.arcStartFraction = 0.62,
  });

  final double arcStartFraction;

  @override
  State<GlobeBackground> createState() => _GlobeBackgroundState();
}

class _GlobeBackgroundState extends State<GlobeBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(decoration: AppDecorations.bgGradient),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            painter: _GlobePainter(
              // Inverse le sens d’animation : la carte défile vers l’est.
              rotation: -_controller.value * 2 * math.pi,
              arcStartFraction: widget.arcStartFraction,
            ),
            size: Size.infinite,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Données géographiques : contours simplifiés des continents
// Chaque polygone = liste de [latitude°, longitude°], tracé dans le sens horaire
// ─────────────────────────────────────────────────────────────────────────────

const _kContinents = <List<List<double>>>[

  // ── Afrique ───────────────────────────────────────────────────────────────
  [
    [35.9,-5.7],  [36.9,3.0],   [37.2,9.5],   [33.5,11.6],  [30.9,25.2],
    [30.9,32.2],  [27.5,34.2],  [22.0,37.5],  [15.0,42.0],  [11.8,43.5],
    [4.9,42.0],   [1.5,42.0],   [-1.7,41.0],  [-4.0,39.8],  [-11.0,40.5],
    [-17.0,35.8], [-25.9,32.8], [-34.8,19.9], [-34.4,18.5], [-29.0,17.1],
    [-23.0,14.5], [-17.0,11.6], [-11.5,9.7],  [-4.7,9.5],   [0.7,9.8],
    [4.3,3.4],    [5.0,-1.5],   [5.3,-4.9],   [4.8,-7.6],   [6.9,-11.5],
    [9.5,-14.7],  [12.7,-16.8], [14.7,-17.3], [21.0,-17.1], [27.0,-13.2],
    [30.5,-9.5],  [35.9,-5.7],
  ],

  // ── Europe (péninsule principale + Scandinavie simplifiée) ────────────────
  [
    [36.0,-8.9],  [38.6,-9.5],  [43.2,-9.0],  [44.2,-8.5],  [43.5,-2.0],
    [44.0,1.5],   [43.3,3.2],   [43.5,5.4],   [44.0,8.2],   [43.8,7.8],
    [41.8,12.5],  [40.7,14.1],  [37.9,15.7],  [37.5,15.6],  [38.1,13.4],
    [39.7,16.1],  [40.6,19.0],  [40.5,22.0],  [37.0,22.4],  [36.7,26.4],
    [39.0,26.0],  [41.5,29.0],  [47.5,37.5],  [46.5,32.0],  [46.5,30.0],
    [45.0,28.7],  [44.8,34.0],  [46.5,37.0],  [47.5,39.0],  [51.0,37.5],
    [55.5,22.0],  [54.5,18.5],  [54.1,13.9],
    // Scandinavie
    [55.0,9.5],   [57.2,8.0],   [57.5,5.0],   [62.0,5.0],   [64.0,14.0],
    [70.0,18.0],  [71.0,25.5],  [70.6,28.5],  [65.0,30.0],  [60.0,25.0],
    [58.0,22.0],  [56.0,21.0],  [54.5,18.5],  [54.1,13.9],  [55.0,9.5],
    // Retour façade atlantique
    [51.4,2.0],   [51.5,-0.1],  [50.5,-1.0],  [48.5,-5.0],  [47.5,-3.0],
    [43.5,-2.0],  [36.0,-5.5],  [36.0,-8.9],
  ],

  // ── Asie (continent principal, côtes simplifiées) ─────────────────────────
  [
    [41.5,29.0],  [40.8,36.0],  [36.5,36.5],  [36.8,36.1],
    [32.5,35.0],  [29.5,34.9],  [22.0,37.0],  [12.5,45.0],
    [21.0,59.0],  [22.5,59.8],  [24.5,56.5],  [24.5,67.0],
    [8.4,77.5],   [7.9,77.4],   [22.0,88.5],  [22.5,91.5],
    [20.8,92.3],  [14.0,100.0], [1.4,104.0],  [2.5,102.0],
    [5.4,100.5],  [6.5,99.5],   [17.0,107.5], [21.5,109.8],
    [22.0,114.0], [35.0,120.5], [38.0,121.5], [41.8,121.5],
    [42.0,130.0], [43.0,131.0], [53.0,141.0], [60.0,150.0],
    [63.0,164.0], [67.0,175.5], [70.0,170.0], [66.0,162.0],
    [65.0,143.0], [70.0,142.0], [73.0,141.0], [72.0,130.0],
    [73.5,118.0], [77.0,104.0], [78.0,77.0],  [73.5,57.0],
    [69.0,33.5],  [68.5,40.0],  [55.0,38.0],  [52.5,58.0],
    [47.5,58.5],  [42.0,50.5],  [43.5,47.0],  [43.0,45.5],
    [41.5,41.5],  [41.5,36.5],  [41.5,29.0],
  ],

  // ── Amérique du Nord ──────────────────────────────────────────────────────
  [
    [71.4,-156.5], [66.0,-168.0], [60.0,-165.0], [55.0,-160.0],
    [55.0,-132.0], [50.0,-127.5], [48.5,-124.5], [42.0,-124.5],
    [35.0,-121.0], [30.0,-116.0], [28.0,-111.0], [22.9,-110.0],
    [22.0,-106.0], [19.0,-105.0], [15.5,-92.5],  [15.7,-88.7],
    [9.0,-83.0],   [8.5,-77.0],   [10.5,-75.0],  [20.5,-86.5],
    [21.5,-87.5],  [23.5,-97.0],  [26.0,-97.5],  [29.5,-93.5],
    [30.0,-89.5],  [30.0,-84.0],  [25.0,-80.5],  [25.5,-80.5],
    [28.0,-82.0],  [30.0,-81.5],  [35.0,-76.0],  [41.5,-71.5],
    [44.0,-70.0],  [47.0,-53.5],  [52.0,-55.5],  [57.5,-61.5],
    [60.0,-63.5],  [63.0,-63.0],  [63.0,-72.0],  [59.0,-77.0],
    [55.5,-76.5],  [63.0,-90.0],  [67.0,-97.0],  [70.0,-109.0],
    [72.0,-120.5], [70.0,-135.0], [71.5,-140.0], [71.4,-156.5],
  ],

  // ── Groenland ─────────────────────────────────────────────────────────────
  [
    [76.5,-68.0], [83.5,-25.0], [83.5,-18.5], [76.5,-18.5],
    [60.5,-45.0], [65.0,-52.5], [70.0,-52.0], [76.5,-68.0],
  ],

  // ── Amérique du Sud ───────────────────────────────────────────────────────
  [
    [12.0,-71.5],  [10.7,-63.0],  [8.4,-60.5],   [6.0,-61.0],
    [5.0,-52.5],   [4.0,-51.5],   [1.0,-50.0],   [-3.5,-44.0],
    [-7.5,-35.0],  [-12.5,-38.0], [-23.0,-43.5], [-32.0,-52.0],
    [-34.5,-58.5], [-38.0,-57.5], [-42.5,-63.5], [-53.0,-68.0],
    [-55.5,-66.5], [-55.5,-65.0], [-53.0,-70.5], [-43.5,-74.0],
    [-30.5,-71.5], [-18.0,-70.5], [-3.5,-80.5],  [0.0,-78.5],
    [3.5,-77.5],   [8.5,-77.0],   [10.5,-75.0],  [12.0,-71.5],
  ],

  // ── Australie ─────────────────────────────────────────────────────────────
  [
    [-17.5,122.0], [-22.0,114.0], [-26.5,113.5], [-33.5,115.0],
    [-35.0,117.5], [-35.5,136.5], [-38.0,140.0], [-38.5,145.5],
    [-39.5,147.5], [-38.5,148.0], [-28.0,153.5], [-18.0,147.0],
    [-16.5,145.5], [-15.0,137.0], [-12.0,136.5], [-14.0,131.5],
    [-17.5,122.0],
  ],

  // ── Nouvelle-Zélande ──────────────────────────────────────────────────────
  [
    [-34.5,173.0], [-37.0,175.5], [-41.5,174.5], [-46.5,168.5],
    [-44.5,171.0], [-42.5,172.0], [-39.0,175.5], [-34.5,173.0],
  ],

  // ── Japon (île principale Honshū) ─────────────────────────────────────────
  [
    [31.5,130.5], [33.5,131.5], [34.0,132.5], [34.5,133.0],
    [34.7,136.5], [35.0,137.0], [35.5,136.5], [37.5,137.5],
    [38.5,141.5], [41.5,141.5], [44.5,141.5], [45.5,141.7],
    [45.5,141.8], [42.0,140.5], [40.0,141.0], [35.7,140.9],
    [33.5,135.5], [32.5,131.0], [31.5,130.5],
  ],

  // ── Grande-Bretagne (simplifiée) ──────────────────────────────────────────
  [
    [50.0,-5.7], [51.5,-5.2], [53.5,-4.5], [55.0,-5.5],
    [58.5,-3.5], [58.6,-3.0], [57.5,-2.0], [55.0,-1.5],
    [51.5,-0.1], [50.8,0.6],  [50.0,-5.7],
  ],

  // ── Irlande (simplifiée) ──────────────────────────────────────────────────
  [
    [51.5,-10.0], [54.0,-10.2], [55.3,-7.2], [54.5,-5.5],
    [52.0,-6.0],  [51.5,-10.0],
  ],

  // ── Madagascar ────────────────────────────────────────────────────────────
  [
    [-12.0,49.3], [-16.0,50.0], [-20.0,48.5], [-25.5,47.0],
    [-25.0,44.0], [-20.5,43.5], [-13.0,48.5], [-12.0,49.3],
  ],

];

// ─────────────────────────────────────────────────────────────────────────────

class _GlobePainter extends CustomPainter {
  final double rotation;
  final double arcStartFraction;

  const _GlobePainter({
    required this.rotation,
    required this.arcStartFraction,
  });

  static const _lats  = [-60.0, -30.0, 0.0, 30.0, 60.0];
  static const _nMer  = 6;
  static const _persp = 0.26;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width  + 120.0;
    final cy = size.height - 150.0;
    final r  = size.height * (1.0 - arcStartFraction);

    // ── Clip circulaire ───────────────────────────────────────────────────
    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r)),
    );

    // ── Pinceaux ──────────────────────────────────────────────────────────
    final linePaint = Paint()
      ..color = AppColors.trottleMain.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;

    final dotPaint = Paint()
      ..color = AppColors.trottleMain.withValues(alpha: 0.60)
      ..style = PaintingStyle.fill;

    final mapPaint = Paint()
      ..color = AppColors.trottleMain.withValues(alpha: 0.13)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    // ── Carte : contours des continents ───────────────────────────────────
    for (final polygon in _kContinents) {
      _drawContinent(canvas, mapPaint, polygon, cx, cy, r);
    }

    // ── Grille : cercle extérieur ──────────────────────────────────────────
    canvas.drawCircle(Offset(cx, cy), r, linePaint);

    // ── Parallèles ────────────────────────────────────────────────────────
    for (final latDeg in _lats) {
      final phi  = latDeg * math.pi / 180;
      final latR = r * math.cos(phi);
      // Écran Y vers le bas : soustraire sin(φ) pour nord en haut.
      final latY = cy - r * math.sin(phi);

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, latY),
          width:  latR * 2,
          height: latR * _persp * 2,
        ),
        linePaint,
      );

      _dot(canvas, dotPaint, cx - latR, latY, 2.2);
      _dot(canvas, dotPaint, cx + latR, latY, 2.2);
    }

    // ── Méridiens ─────────────────────────────────────────────────────────
    for (int i = 0; i < _nMer; i++) {
      final angle = rotation + i * math.pi / _nMer;
      final cosA  = math.cos(angle).abs();

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, cy),
          width:  r * cosA * 2,
          height: r * 2,
        ),
        linePaint,
      );
    }

    // ── Dots aux intersections ────────────────────────────────────────────
    for (final latDeg in _lats) {
      final phi = latDeg * math.pi / 180;
      for (int j = 0; j < _nMer * 2; j++) {
        final lam = rotation + j * math.pi / _nMer;
        if (math.cos(phi) * math.cos(lam) < 0) continue;

        final sx = cx + r * math.cos(phi) * math.sin(lam);
        final sy = cy - r * math.sin(phi)
                      + r * math.cos(phi) * math.cos(lam) * _persp;

        _dot(canvas, dotPaint, sx, sy, 1.8);
      }
    }

    _dot(canvas, dotPaint, cx, cy - r, 2.5);

    // ── Noms de pays ──────────────────────────────────────────────────────
    for (final entry in _kCountries) {
      final phi  = (entry[0] as double) * math.pi / 180;
      final lam  = (entry[1] as double) * math.pi / 180;
      final name = entry[2] as String;

      final lamR = lam + rotation;
      final z3d  = math.cos(phi) * math.cos(lamR);
      if (z3d < 0.05) continue;

      final sx = cx + r * math.cos(phi) * math.sin(lamR);
      final sy = cy - r * math.sin(phi)
                    + r * math.cos(phi) * math.cos(lamR) * _persp;

      final opacity = (z3d * 0.22).clamp(0.0, 0.18);
      _drawLabel(canvas, sx, sy, name, opacity);
    }

    canvas.restore();
  }

  /// Projette un polygone géographique et le dessine en gérant
  /// le passage face avant / face arrière (lever de plume si invisible).
  void _drawContinent(
    Canvas canvas,
    Paint paint,
    List<List<double>> coords,
    double cx,
    double cy,
    double r,
  ) {
    final path = Path();
    bool penDown = false;

    for (final pt in coords) {
      final phi  = pt[0] * math.pi / 180;
      final lamR = pt[1] * math.pi / 180 + rotation;

      final z3d = math.cos(phi) * math.cos(lamR);
      final sx  = cx + r * math.cos(phi) * math.sin(lamR);
      final sy  = cy - r * math.sin(phi)
                     + r * math.cos(phi) * math.cos(lamR) * _persp;

      if (z3d > -0.05) {
        if (!penDown) {
          path.moveTo(sx, sy);
          penDown = true;
        } else {
          path.lineTo(sx, sy);
        }
      } else {
        penDown = false;
      }
    }

    canvas.drawPath(path, paint);
  }

  void _dot(Canvas canvas, Paint p, double x, double y, double radius) =>
      canvas.drawCircle(Offset(x, y), radius, p);

  void _drawLabel(Canvas canvas, double x, double y, String text, double opacity) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: AppColors.trottleWhite.withValues(alpha: opacity),
          fontSize: 7.5,
          fontFamily: 'Montserrat',
          letterSpacing: 0.3,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
  }

  @override
  bool shouldRepaint(_GlobePainter old) => old.rotation != rotation;
}

// ─────────────────────────────────────────────────────────────────────────────
// Noms de pays : [latitude°, longitude°, nom]
// ─────────────────────────────────────────────────────────────────────────────

const _kCountries = <List<Object>>[
  [51.5,    0.0,    'Royaume-Uni'],
  [48.8,    2.3,    'France'],
  [52.5,   13.4,    'Allemagne'],
  [41.9,   12.5,    'Italie'],
  [40.4,   -3.7,    'Espagne'],
  [38.7,   -9.1,    'Portugal'],
  [59.3,   18.1,    'Suède'],
  [60.2,   24.9,    'Finlande'],
  [55.7,   37.6,    'Russie'],
  [50.4,   30.5,    'Ukraine'],
  [39.9,   32.9,    'Turquie'],
  [35.7,   51.4,    'Iran'],
  [24.7,   46.7,    'Arabie Saoudite'],
  [30.0,   31.2,    'Égypte'],
  [28.6,   77.2,    'Inde'],
  [39.9,  116.4,    'Chine'],
  [35.7,  139.7,    'Japon'],
  [37.6,  127.0,    'Corée du Sud'],
  [14.7,  101.0,    'Thaïlande'],
  [ 1.3,  103.8,    'Singapour'],
  [-6.2,  106.8,    'Indonésie'],
  [ 6.4,    3.4,    'Nigeria'],
  [-1.3,   36.8,    'Kenya'],
  [-25.7,  28.2,    'Afrique du Sud'],
  [15.3,   38.9,    'Éthiopie'],
  [37.8,  -96.9,    'États-Unis'],
  [45.4,  -75.7,    'Canada'],
  [19.4,  -99.1,    'Mexique'],
  [ 4.7,  -74.1,    'Colombie'],
  [-23.5,  -47.6,   'Brésil'],
  [-34.6,  -58.4,   'Argentine'],
  [-25.3,  131.0,   'Australie'],
  [-36.9,  174.8,   'Nouvelle-Zélande'],
  [64.1,  -21.9,    'Islande'],
  [33.9,   67.7,    'Afghanistan'],
  [41.7,   44.8,    'Géorgie'],
  [47.0,   28.9,    'Moldavie'],
  [-4.3,   15.3,    'Congo'],
  [17.6,    8.1,    'Niger'],
];
