import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

/// Grid ringkasan indikator performa utama (KPI) yang terdiri dari 4 kartu:
/// 1. Total Stasiun
/// 2. Status Bahaya
/// 3. Mendekati Batas
/// 4. Sensor Aktif / IoT Gateway
class KpiStatsGrid extends StatelessWidget {
  final int totalStations;
  final int dangerCount;
  final int warningCount;
  final int onlineCount;

  const KpiStatsGrid({
    super.key,
    required this.totalStations,
    required this.dangerCount,
    required this.warningCount,
    required this.onlineCount,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _WebStatCard(
              width: cardWidth,
              label: 'Total stasiun',
              value: '$totalStations',
              note: '$totalStations titik pantau DPU',
              icon: Icons.pin_drop_outlined,
              isGreen: true,
            ),
            _WebStatCard(
              width: cardWidth,
              label: 'Status bahaya',
              value: '$dangerCount',
              note: dangerCount > 0 ? 'Perlu tindakan!' : 'Kondisi nihil',
              icon: Icons.crisis_alert_rounded,
              isDanger: dangerCount > 0,
            ),
            _WebStatCard(
              width: cardWidth,
              label: 'Mendekati batas',
              value: '$warningCount',
              note: 'Waspada peningkatan',
              icon: Icons.shield_outlined,
              isAmber: true,
            ),
            _WebStatCard(
              width: cardWidth,
              label: 'Sensor aktif',
              value: '$onlineCount/$totalStations',
              note: 'IoT gateway terhubung',
              icon: Icons.wifi_rounded,
              isGreen: true,
            ),
          ],
        );
      },
    );
  }
}

/// Kartu stat internal dengan indikator warna dan ikon
class _WebStatCard extends StatelessWidget {
  final double width;
  final String label;
  final String value;
  final String note;
  final IconData icon;
  final bool isGreen;
  final bool isAmber;
  final bool isDanger;

  const _WebStatCard({
    required this.width,
    required this.label,
    required this.value,
    required this.note,
    required this.icon,
    this.isGreen = false,
    this.isAmber = false,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    Color valueColor = AppTheme.textPrimary;
    Color dotColor = AppTheme.brandGreen;
    if (isDanger) {
      valueColor = AppTheme.danger;
      dotColor = AppTheme.danger;
    } else if (isAmber) {
      valueColor = const Color(0xFFB17B1F);
      dotColor = const Color(0xFFC99330);
    } else if (isGreen) {
      valueColor = AppTheme.brandGreen;
      dotColor = AppTheme.brandGreen;
    }

    return Container(
      width: width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDanger ? AppTheme.dangerBorder : AppTheme.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                icon,
                size: 16,
                color: isDanger ? AppTheme.danger : const Color(0xFF87968D),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                width: 5,
                height: 5,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  note,
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: AppTheme.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
