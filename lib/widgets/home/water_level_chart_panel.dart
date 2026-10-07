import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/station_model.dart';
import '../../theme/app_theme.dart';
import '../bouncing_button.dart';

/// Panel grafik interaktif fl_chart untuk menampilkan fluktuasi
/// Tinggi Muka Air (TMA) terhadap ambang batas talut secara temporal (6 jam / 24 jam).
class WaterLevelChartPanel extends StatelessWidget {
  final List<StationModel> stations;
  final int selectedStationIndex;
  final String selectedRange;
  final List<Map<String, dynamic>> chartPoints;
  final ValueChanged<int> onStationChanged;
  final ValueChanged<String> onRangeChanged;

  const WaterLevelChartPanel({
    super.key,
    required this.stations,
    required this.selectedStationIndex,
    required this.selectedRange,
    required this.chartPoints,
    required this.onStationChanged,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedStation = stations[selectedStationIndex];
    final spots = chartPoints.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), (e.value['water'] as double));
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Segmented Buttons (6 jam / 24 jam)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tren Tinggi Muka Air',
                    style: GoogleFonts.manrope(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Text(
                    'Sensor radar telemetry',
                    style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
                  ),
                ],
              ),
              // Segmented Range Switcher
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7F5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: ['6 jam', '24 jam'].map((r) {
                    final isSel = selectedRange == r;
                    return BouncingButton(
                      scaleFactor: 0.92,
                      onTap: () => onRangeChanged(r),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSel ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: isSel
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  )
                                ]
                              : null,
                        ),
                        child: Text(
                          r,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                            color: isSel ? AppTheme.brandGreen : AppTheme.textMuted,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Station Selector Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: selectedStationIndex,
                isExpanded: true,
                dropdownColor: Colors.white,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppTheme.textMuted,
                  size: 20,
                ),
                items: stations.asMap().entries.map((entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(
                      entry.value.name,
                      style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                    ),
                  );
                }).toList(),
                onChanged: (newIdx) {
                  if (newIdx != null) {
                    onStationChanged(newIdx);
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Large Water Value display (matching web .water-value)
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${selectedStation.height}',
                style: GoogleFonts.manrope(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'm',
                style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.safeBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_upward_rounded, size: 11, color: AppTheme.safe),
                    SizedBox(width: 2),
                    Text(
                      '+0,05 m',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.safe,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: selectedStation.statusBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: selectedStation.statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      selectedStation.computedStatus,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: selectedStation.statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Line Chart Area
          SizedBox(
            height: 175,
            child: LineChart(
              LineChartData(
                minY: 0.5,
                maxY: 5.0,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => const FlLine(
                    color: AppTheme.borderSubtle,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (val, meta) {
                        if (val == 1.0 || val == 2.5 || val == 4.0) {
                          return Text(
                            '${val.toStringAsFixed(1)}m',
                            style: const TextStyle(fontSize: 9, color: AppTheme.textSubtle),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      interval: 3,
                      getTitlesWidget: (val, meta) {
                        final idx = val.toInt();
                        if (idx >= 0 && idx < chartPoints.length) {
                          return Text(
                            chartPoints[idx]['time'] as String,
                            style: const TextStyle(fontSize: 9, color: AppTheme.textSubtle),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppTheme.brandGreen,
                    barWidth: 2.2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.brandGreen.withOpacity(0.18),
                          AppTheme.brandGreen.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                  // Dashed threshold line (Batas Talut)
                  LineChartBarData(
                    spots: [
                      FlSpot(0, selectedStation.limit),
                      FlSpot(spots.length.toDouble() - 1, selectedStation.limit),
                    ],
                    isCurved: false,
                    color: const Color(0xFFD69F42),
                    barWidth: 1.5,
                    dashArray: const [5, 4],
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Chart Footer Legend
          Row(
            children: [
              Row(
                children: [
                  Container(width: 12, height: 2, color: AppTheme.brandGreen),
                  const SizedBox(width: 5),
                  const Text(
                    'Tinggi Muka Air',
                    style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Container(width: 12, height: 2, color: const Color(0xFFD69F42)),
                  const SizedBox(width: 5),
                  Text(
                    'Ambang Batas (${selectedStation.limit} m)',
                    style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
