import 'package:flutter/material.dart';

/// Ombre "contours uniquement" pour un rectangle arrondi.
///
/// Contrairement à un `BoxShadow` classique (qui peut "baver" sous un fond
/// translucide), ce painter retire l'ombre à l'intérieur de la forme afin que
/// l'ombre ne soit visible qu'à l'extérieur du contour.
class OuterShadowRRect extends StatelessWidget {
  const OuterShadowRRect({
    super.key,
    required this.borderRadius,
    required this.shadowColor,
    required this.blurRadius,
    required this.offset,
    required this.child,
  });

  final double borderRadius;
  final Color shadowColor;
  final double blurRadius;
  final Offset offset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final sigma = Shadow.convertRadiusToSigma(blurRadius);
    final pad = blurRadius + offset.distance;

    return Padding(
      padding: EdgeInsets.all(pad),
      child: CustomPaint(
        painter: _OuterShadowRRectPainter(
          borderRadius: borderRadius,
          shadowColor: shadowColor,
          sigma: sigma,
          offset: offset,
        ),
        child: child,
      ),
    );
  }
}

class _OuterShadowRRectPainter extends CustomPainter {
  const _OuterShadowRRectPainter({
    required this.borderRadius,
    required this.shadowColor,
    required this.sigma,
    required this.offset,
  });

  final double borderRadius;
  final Color shadowColor;
  final double sigma;
  final Offset offset;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, sigma);

    final clearPaint = Paint()
      ..blendMode = BlendMode.dstOut
      ..color = const Color(0xFF000000);

    final bounds = rect.inflate(sigma * 2 + offset.distance);

    canvas.saveLayer(bounds, Paint());
    canvas.translate(offset.dx, offset.dy);

    // 1) Dessine l'ombre (floue) de la forme.
    canvas.drawRRect(rrect, shadowPaint);
    // 2) Retire tout ce qui est "à l'intérieur" de la forme.
    canvas.drawRRect(rrect, clearPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _OuterShadowRRectPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.shadowColor != shadowColor ||
        oldDelegate.sigma != sigma ||
        oldDelegate.offset != offset;
  }
}

