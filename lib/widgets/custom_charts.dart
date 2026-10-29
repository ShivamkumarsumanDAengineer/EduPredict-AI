import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

/// Custom Painter for GPA Trajectory (Historical + ML Forecast)
class GpaTrajectoryChart extends StatelessWidget {
  final double currentGpa;

  const GpaTrajectoryChart({super.key, this.currentGpa = 3.84});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          width: double.infinity,
          child: CustomPaint(
            painter: _GpaTrajectoryPainter(targetGpa: currentGpa),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Sem 1', style: AppTypography.labelSm),
            Text('Sem 2', style: AppTypography.labelSm),
            Text('Sem 3', style: AppTypography.labelSm),
            Text('Sem 4', style: AppTypography.labelSm),
            Text(
              'Sem 5',
              style: TextStyle(
                fontFamily: AppTypography.fontBody,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            Text(
              'Sem 6 (AI)',
              style: TextStyle(
                fontFamily: AppTypography.fontBody,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GpaTrajectoryPainter extends CustomPainter {
  final double targetGpa;

  _GpaTrajectoryPainter({required this.targetGpa});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Draw horizontal dashed grid lines
    final gridPaint = Paint()
      ..color = AppColors.surfaceContainerHighest
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    for (double y in [h * 0.2, h * 0.5, h * 0.8]) {
      _drawDashedLine(canvas, Offset(0, y), Offset(w, y), gridPaint);
    }

    // Points definition:
    // Sem 1 (x: 0.05), Sem 2 (0.23), Sem 3 (0.42), Sem 4 (0.61)
    // Sem 5 (0.80), Sem 6 (0.95)
    final points = [
      Offset(w * 0.06, h * 0.80), // Sem 1: 3.2
      Offset(w * 0.24, h * 0.68), // Sem 2: 3.4
      Offset(w * 0.42, h * 0.55), // Sem 3: 3.6
      Offset(w * 0.60, h * 0.40), // Sem 4: 3.72
      Offset(w * 0.78, h * 0.32), // Sem 5: 3.78
      Offset(w * 0.94, h * 0.20), // Sem 6: targetGpa (3.84)
    ];

    // 1. Historical Area Gradient (Sem 1 -> Sem 4)
    final historicPath = Path();
    historicPath.moveTo(points[0].dx, h * 0.95);
    historicPath.lineTo(points[0].dx, points[0].dy);
    for (int i = 1; i <= 3; i++) {
      historicPath.lineTo(points[i].dx, points[i].dy);
    }
    historicPath.lineTo(points[3].dx, h * 0.95);
    historicPath.close();

    final historicAreaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.tertiaryContainer.withOpacity(0.22),
          AppColors.tertiaryContainer.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(historicPath, historicAreaPaint);

    // 2. Projected Area Gradient (Sem 4 -> Sem 6)
    final projectPath = Path();
    projectPath.moveTo(points[3].dx, h * 0.95);
    projectPath.lineTo(points[3].dx, points[3].dy);
    projectPath.lineTo(points[4].dx, points[4].dy);
    projectPath.lineTo(points[5].dx, points[5].dy);
    projectPath.lineTo(points[5].dx, h * 0.95);
    projectPath.close();

    final projectAreaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withOpacity(0.22),
          AppColors.primary.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(projectPath, projectAreaPaint);

    // 3. Historical Stroke Line (Sem 1 -> Sem 4)
    final historicLinePaint = Paint()
      ..color = AppColors.tertiary
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final linePath = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i <= 3; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, historicLinePaint);

    // 4. ML Projected Dashed Line (Sem 4 -> Sem 6)
    final projectLinePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    _drawDashedLine(canvas, points[3], points[4], projectLinePaint);
    _drawDashedLine(canvas, points[4], points[5], projectLinePaint);

    // 5. Draw data points
    final dotPaintHistoric = Paint()..color = AppColors.tertiary;
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(points[i], 3.8, dotPaintHistoric);
    }

    // Sem 4 transition node (ring)
    final ringPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final ringBorderPaint = Paint()
      ..color = AppColors.tertiary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(points[3], 5.0, ringPaint);
    canvas.drawCircle(points[3], 5.0, ringBorderPaint);

    // Sem 5 node
    final dotPaintProject = Paint()..color = AppColors.primary;
    canvas.drawCircle(points[4], 3.8, dotPaintProject);

    // Sem 6 target node with outer pulse aura
    final auraPaint = Paint()..color = AppColors.primary.withOpacity(0.25);
    canvas.drawCircle(points[5], 9.0, auraPaint);
    canvas.drawCircle(points[5], 5.2, dotPaintProject);

    // Draw GPA Text Badge above Sem 6
    final textSpan = TextSpan(
      text: targetGpa.toStringAsFixed(2),
      style: const TextStyle(
        fontFamily: AppTypography.fontHeading,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(points[5].dx - textPainter.width - 2, points[5].dy - 18),
    );
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const double dashWidth = 5.0;
    const double dashSpace = 4.0;
    final double dx = p2.dx - p1.dx;
    final double dy = p2.dy - p1.dy;
    final double distance = math.sqrt(dx * dx + dy * dy);
    final double unitX = dx / distance;
    final double unitY = dy / distance;

    double currentDist = 0.0;
    while (currentDist < distance) {
      final double nextDist = math.min(currentDist + dashWidth, distance);
      canvas.drawLine(
        Offset(p1.dx + unitX * currentDist, p1.dy + unitY * currentDist),
        Offset(p1.dx + unitX * nextDist, p1.dy + unitY * nextDist),
        paint,
      );
      currentDist += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _GpaTrajectoryPainter oldDelegate) =>
      oldDelegate.targetGpa != targetGpa;
}

/// Circular Radial Gauge for Attendance Diagnostics
class AttendanceRadialGauge extends StatelessWidget {
  final double percentage; // e.g. 91.5
  final double size;

  const AttendanceRadialGauge({
    super.key,
    required this.percentage,
    this.size = 110,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _AttendanceGaugePainter(percentage: percentage),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: AppTypography.headlineSm.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                  height: 1.1,
                ),
              ),
              const Text(
                'Ratio',
                style: AppTypography.labelSm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AttendanceGaugePainter extends CustomPainter {
  final double percentage;

  _AttendanceGaugePainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 8;

    // Track
    final trackPaint = Paint()
      ..color = AppColors.surfaceContainer
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Active Arc (-90 deg start)
    final sweepAngle = (percentage / 100.0) * 2 * math.pi;
    final progressPaint = Paint()
      ..color = AppColors.primaryContainer
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _AttendanceGaugePainter oldDelegate) =>
      oldDelegate.percentage != percentage;
}

/// Weekly Study Hours Bar Chart
class WeeklyStudyBarChart extends StatelessWidget {
  final List<double> dailyHours; // [M, T, W, T, F, S, S] e.g. [4.0, 3.5, 5.0, 4.0, 4.5, 3.0, 2.5]

  const WeeklyStudyBarChart({
    super.key,
    required this.dailyHours,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    const double maxHour = 5.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(7, (index) {
        final hours = dailyHours[index];
        final ratio = (hours / maxHour).clamp(0.1, 1.0);
        final bool isPeak = hours >= 5.0;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${hours.toStringAsFixed(hours % 1 == 0 ? 0 : 1)}h',
                  style: TextStyle(
                    fontFamily: AppTypography.fontBody,
                    fontSize: 11,
                    fontWeight: isPeak ? FontWeight.w700 : FontWeight.w500,
                    color: isPeak ? AppColors.tertiary : AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 90 * ratio,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isPeak
                        ? AppColors.tertiaryContainer
                        : AppColors.primaryContainer,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  days[index],
                  style: TextStyle(
                    fontFamily: AppTypography.fontBody,
                    fontSize: 12,
                    fontWeight: isPeak ? FontWeight.w700 : FontWeight.w500,
                    color: isPeak ? AppColors.tertiary : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

