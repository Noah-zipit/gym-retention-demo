import 'dart:math';
import 'package:flutter/material.dart';
import '../theme.dart';

/// Code-built animated hero visual — pulsing energy rings and drifting
/// particles over a deep radial glow. Zero assets, 60fps-friendly.
class HeroArt extends StatefulWidget {
  const HeroArt({super.key, this.height = 220});

  final double height;

  @override
  State<HeroArt> createState() => _HeroArtState();
}

class _HeroArtState extends State<HeroArt>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final _rand = Random(7);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => CustomPaint(
          painter: _HeroPainter(_ctrl.value, _rand),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _HeroPainter extends CustomPainter {
  _HeroPainter(this.t, this.rand);

  final double t;
  final Random rand;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.52;

    // Deep radial glow
    final glow = RadialGradient(
      colors: [
        AppTheme.volt.withOpacity(0.20),
        AppTheme.volt.withOpacity(0.05),
        Colors.transparent,
      ],
      stops: const [0.0, 0.45, 1.0],
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = glow.createShader(
        Rect.fromCircle(center: Offset(cx, cy), radius: size.width * 0.7),
      ),
    );

    // Pulsing rings
    for (var i = 0; i < 3; i++) {
      final phase = (t + i / 3) % 1.0;
      final r = 24 + phase * size.width * 0.52;
      final alpha = (1 - phase) * 0.5;
      canvas.drawCircle(
        Offset(cx, cy),
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..color = AppTheme.volt.withOpacity(alpha),
      );
    }

    // Core orb
    canvas.drawCircle(
      Offset(cx, cy),
      15 + sin(t * 2 * pi) * 2.5,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFE9FF9E), AppTheme.volt, Colors.transparent],
          stops: [0.0, 0.55, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: 42)),
    );

    // Drifting particles (deterministic pseudo-random field)
    final p = Paint()..color = AppTheme.volt.withOpacity(0.55);
    for (var i = 0; i < 42; i++) {
      final fx = _hash(i * 3 + 1);
      final fy = _hash(i * 3 + 2);
      final fs = _hash(i * 3 + 3);
      final x = (fx * size.width + t * (14 + fs * 30)) % size.width;
      final y = (fy * size.height - t * (8 + fs * 18)) % size.height;
      final yy = y < 0 ? y + size.height : y;
      final r = 1 + fs * 2.2;
      p.color = AppTheme.volt.withOpacity(0.18 + fs * 0.4);
      canvas.drawCircle(Offset(x, yy), r, p);
    }
  }

  double _hash(int n) {
    var x = sin(n * 127.1) * 43758.5453;
    return x - x.floor();
  }

  @override
  bool shouldRepaint(covariant _HeroPainter old) => old.t != t;
}
