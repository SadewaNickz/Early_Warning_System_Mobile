import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/station_model.dart';
import '../../theme/app_theme.dart';

/// Dialog modal untuk menampilkan daftar stasiun sungai yang sedang dalam status peringatan (Waspada / Bahaya).
class AlertsDialog {
  const AlertsDialog._();

  static void show(BuildContext context, List<StationModel> alertStations) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppTheme.warning),
            const SizedBox(width: 8),
            Text(
              'Peringatan Dini EWS',
              style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: alertStations.isEmpty
            ? const Text(
                'Semua stasiun sungai saat ini dalam batas aman.',
                style: TextStyle(fontSize: 13),
              )
            : SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: alertStations.length,
                  itemBuilder: (c, i) {
                    final item = alertStations[i];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.crisis_alert_rounded,
                        color: item.statusColor,
                      ),
                      title: Text(
                        item.name,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'TMA: ${item.height} m (Ambang: ${item.limit} m) • ${item.computedStatus}',
                        style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                      ),
                    );
                  },
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Tutup',
              style: TextStyle(color: AppTheme.brandGreen, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
