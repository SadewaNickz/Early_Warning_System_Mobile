import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedRiverWaterGauge extends StatefulWidget {
  final double currentHeight;
  final double limit;
  final String status;
  final bool isOnline;
  final double gaugeHeight;

  const AnimatedRiverWaterGauge({
    super.key,
    required this.currentHeight,
    required this.limit,
    required this.status,
    this.isOnline = true,
    this.gaugeHeight = 125.0,
  });

  @override
  State<AnimatedRiverWaterGauge> createState() => _AnimatedRiverWaterGaugeState();
}

class _AnimatedRiverWaterGaugeState extends State<AnimatedRiverWaterGauge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  Color get _waterTopColor {
    if (!widget.isOnline) return const Color(0xFF9EACA3);
    if (widget.status == 'Bahaya') return const Color(0xFFF05159);
    if (widget.status == 'Mendekati batas') return const Color(0xFFF5B23E);
    return const Color(0xFF26B48F);
  }

  Color get _waterBottomColor {
    if (!widget.isOnline) return const Color(0xFF75857C);
    if (widget.status == 'Bahaya') return const Color(0xFFB52D35);
    if (widget.status == 'Mendekati batas') return const Color(0xFFB87814);
    return const Color(0xFF0F6E54);
  }

  @override
  Widget build(BuildContext context) {
    final validLimit = widget.limit > 0 ? widget.limit : 4.5;
    final targetPercent = (widget.currentHeight / validLimit).clamp(0.10, 0.96);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.15, end: targetPercent),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, animatedPercent, _) {
        return Container(
          height: widget.gaugeHeight,
          decoration: const BoxDecoration(
            color: Color(0xFFF3F7F5),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
            border: Border(
              left: BorderSide(color: Color(0xFFBDCCC3), width: 5.5),
              right: BorderSide(color: Color(0xFFBDCCC3), width: 5.5),
              bottom: BorderSide(color: Color(0xFF9EACA4), width: 6.5),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Dashed line & Threshold Header (Batas Talut)
              Positioned(
                top: 8,
                left: 8,
                right: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7E6),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFE8C88B)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.warning_amber_rounded, size: 12, color: Color(0xFF9B6916)),
                          const SizedBox(width: 4),
                          Text(
                            'Batas Ambang Talut',
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF9B6916),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${widget.limit.toStringAsFixed(2)} m',
                      style: GoogleFonts.robotoMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF9B6916),
                      ),
                    ),
                  ],
                ),
              ),

              // Animated Water Canvas (Waves)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(3)),
                  child: AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _RiverWavePainter(
                          wavePhase: _waveController.value,
                          percent: animatedPercent,
                          topColor: _waterTopColor,
                          bottomColor: _waterBottomColor,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Floating Real-time TMA Pill
              Positioned(
                bottom: 8,
                left: 10,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.94),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.waves_rounded,
                            size: 14,
                            color: _waterBottomColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Muka Air Lapangan',
                            style: GoogleFonts.dmSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E362D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.96),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: _waterBottomColor.withOpacity(0.4)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${widget.currentHeight.toStringAsFixed(2)} m',
                        style: GoogleFonts.robotoMono(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: _waterBottomColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RiverWavePainter extends CustomPainter {
  final double wavePhase;
  final double percent;
  final Color topColor;
  final Color bottomColor;

  _RiverWavePainter({
    required this.wavePhase,
    required this.percent,
    required this.topColor,
    required this.bottomColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    if (width <= 0 || height <= 0) return;

    // Available depth for water (leave top margin for limit threshold)
    const topMargin = 28.0;
    final usableHeight = math.max(10.0, height - topMargin);
    final waterHeight = (usableHeight * percent.clamp(0.12, 0.95));
    final baseWaterY = height - waterHeight;

    const waveAmplitude = 5.5;

    // 1. Back Wave (secondary wave with soft opacity for depth)
    final backPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          topColor.withOpacity(0.45),
          bottomColor.withOpacity(0.35),
        ],
      ).createShader(Rect.fromLTWH(0, math.max(0.0, baseWaterY - waveAmplitude), width, waterHeight + waveAmplitude))
      ..style = PaintingStyle.fill;

    final backPath = Path();
    backPath.moveTo(0, height);
    backPath.lineTo(0, baseWaterY);
    for (double x = 0; x <= width; x += 5) {
      final y = baseWaterY +
          (waveAmplitude * 0.8) *
              math.sin((x / width * 2 * math.pi) - (wavePhase * 2 * math.pi) + math.pi / 2);
      backPath.lineTo(x, y);
    }
    backPath.lineTo(width, height);
    backPath.close();
    canvas.drawPath(backPath, backPaint);

    // 2. Front Wave (primary wave with rich gradient fill)
    final frontPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          topColor.withOpacity(0.85),
          bottomColor.withOpacity(0.80),
          bottomColor.withOpacity(0.95),
        ],
      ).createShader(Rect.fromLTWH(0, math.max(0.0, baseWaterY - waveAmplitude), width, waterHeight + waveAmplitude))
      ..style = PaintingStyle.fill;

    final frontPath = Path();
    frontPath.moveTo(0, height);
    frontPath.lineTo(0, baseWaterY);
    for (double x = 0; x <= width; x += 5) {
      final y = baseWaterY +
          waveAmplitude * math.sin((x / width * 2 * math.pi) + (wavePhase * 2 * math.pi));
      frontPath.lineTo(x, y);
    }
    frontPath.lineTo(width, height);
    frontPath.close();
    canvas.drawPath(frontPath, frontPaint);

    // 3. Crisp Glowing Crest Line along the front wave
    final crestPaint = Paint()
      ..color = Colors.white.withOpacity(0.80)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    final crestPath = Path();
    crestPath.moveTo(0, baseWaterY + waveAmplitude * math.sin(wavePhase * 2 * math.pi));
    for (double x = 0; x <= width; x += 5) {
      final y = baseWaterY +
          waveAmplitude * math.sin((x / width * 2 * math.pi) + (wavePhase * 2 * math.pi));
      crestPath.lineTo(x, y);
    }
    canvas.drawPath(crestPath, crestPaint);
  }

  @override
  bool shouldRepaint(covariant _RiverWavePainter oldDelegate) {
    return oldDelegate.wavePhase != wavePhase ||
        oldDelegate.percent != percent ||
        oldDelegate.topColor != topColor ||
        oldDelegate.bottomColor != bottomColor;
  }
}
