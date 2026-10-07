import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/station_model.dart';
import '../../theme/app_theme.dart';

/// Diagram visual penampang talut sungai berbentuk U (U-shaped cross-section)
/// yang menampilkan perbandingan tinggi muka air terhadap batas ambang talut,
/// persentase kapasitas, intensitas curah hujan, serta status IoT Gateway.
class RiverLevelDiagram extends StatelessWidget {
  final StationModel station;

  const RiverLevelDiagram({
    super.key,
    required this.station,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (station.height / station.limit).clamp(0.0, 1.0);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status Ketinggian Talut',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '${(percent * 100).toStringAsFixed(0)}% Kapasitas',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: station.statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // U-shaped river cross section (level-diagram dari web)
          Container(
            height: 70,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey.shade300, width: 4),
                right: BorderSide(color: Colors.grey.shade300, width: 4),
                bottom: BorderSide(color: Colors.grey.shade300, width: 4),
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(4)),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Dashed line ambang batas
                Positioned(
                  top: 6,
                  left: 4,
                  right: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Batas Talut',
                        style: TextStyle(fontSize: 8, color: Colors.grey.shade500),
                      ),
                      Text(
                        '${station.limit} m',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                // River water box
                FractionallySizedBox(
                  heightFactor: (percent * 0.85).clamp(0.2, 0.95),
                  widthFactor: 1.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppTheme.riverWater,
                      border: Border(
                        top: BorderSide(color: AppTheme.riverBorder, width: 2),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.waves_rounded, size: 14, color: AppTheme.riverText),
                            SizedBox(width: 4),
                            Text(
                              'Muka Air',
                              style: TextStyle(
                                fontSize: 9,
                                color: AppTheme.riverText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${station.height} m',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.riverText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Metrics: Curah Hujan & Status Gateway
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.cloud_outlined, size: 16, color: Color(0xFF6B8074)),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Curah Hujan',
                          style: TextStyle(fontSize: 9.5, color: AppTheme.textMuted),
                        ),
                        Text(
                          '${station.rain.toInt()} mm',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(height: 24, width: 1, color: AppTheme.border),
              const SizedBox(width: 14),
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      station.online ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                      size: 16,
                      color: station.online ? AppTheme.safe : AppTheme.offline,
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'IoT Gateway',
                          style: TextStyle(fontSize: 9.5, color: AppTheme.textMuted),
                        ),
                        Text(
                          station.online ? 'Online' : 'Offline',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: station.online ? AppTheme.safe : AppTheme.offline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
