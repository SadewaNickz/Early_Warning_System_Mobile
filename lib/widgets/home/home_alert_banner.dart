import 'package:flutter/material.dart';
import '../../models/station_model.dart';
import '../../theme/app_theme.dart';

/// Banner peringatan siaga darurat jika terdapat stasiun sungai yang mendekati batas talut atau berstatus bahaya.
class HomeAlertBanner extends StatelessWidget {
  final StationModel station;

  const HomeAlertBanner({
    super.key,
    required this.station,
  });

  @override
  Widget build(BuildContext context) {
    final isDanger = station.computedStatus == 'Bahaya';
    final bgColor = isDanger ? AppTheme.dangerBg : AppTheme.warningBg;
    final borderColor = isDanger ? AppTheme.dangerBorder : AppTheme.warningBorder;
    final symbolBg = isDanger ? AppTheme.dangerSymbol : AppTheme.warningSymbol;
    final textColor = isDanger ? const Color(0xFFA72630) : const Color(0xFF805D1E);
    final subColor = isDanger ? const Color(0xFF964B50) : const Color(0xFF987C43);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: symbolBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                isDanger ? Icons.priority_high_rounded : Icons.warning_amber_rounded,
                color: textColor,
                size: 17,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Siaga: ${station.name}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Tinggi air ${station.height} m mendekati batas talut ${station.limit} m. Pantau intensitas curah hujan (${station.rain.toInt()} mm).',
                  style: TextStyle(color: subColor, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
