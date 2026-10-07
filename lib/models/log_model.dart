import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Model representasi data riwayat log telemetri pemantauan sungai.
/// Digunakan pada halaman HistoryScreen untuk mencatat perubahan tinggi air dan aksi mitigasi.
class LogModel {
  /// Identifier unik entri log
  final String id;

  /// Waktu pencatatan log (misal: '14:20 WIB')
  final String time;

  /// Indeks stasiun terkait dalam daftar stasiun
  final int stationIndex;

  /// Nama stasiun pantau
  final String stationName;

  /// Wilayah sungai
  final String area;

  /// Ketinggian Muka Air (TMA) pada saat log dicatat
  final double height;

  /// Perubahan tinggi air dibanding pembacaan sebelumnya (misal: '+0,10 m')
  final String delta;

  /// Tipe fluktuasi air: 'up', 'down', atau 'steady'
  final String deltaType;

  /// Curah hujan 1 jam terakhir dalam mm
  final double rainHour;

  /// Total akumulasi curah hujan harian dalam mm
  final double rainTotal;

  /// Ambang batas talut sungai dalam meter
  final double limit;

  /// Status pada saat log dicatat ('Aman', 'Mendekati batas', 'Bahaya')
  final String status;

  /// Tindakan mitigasi yang diambil / direkomendasikan
  final String action;

  const LogModel({
    required this.id,
    required this.time,
    required this.stationIndex,
    required this.stationName,
    required this.area,
    required this.height,
    required this.delta,
    required this.deltaType,
    required this.rainHour,
    required this.rainTotal,
    required this.limit,
    required this.status,
    required this.action,
  });

  /// Warna teks dan ikon status
  Color get statusColor {
    switch (status) {
      case 'Bahaya':
        return AppTheme.danger;
      case 'Mendekati batas':
        return AppTheme.warning;
      case 'Aman':
        return AppTheme.safe;
      default:
        return AppTheme.offline;
    }
  }

  /// Warna latar belakang badge status
  Color get statusBackgroundColor {
    switch (status) {
      case 'Bahaya':
        return AppTheme.dangerBg;
      case 'Mendekati batas':
        return AppTheme.warningBg;
      case 'Aman':
        return AppTheme.safeBg;
      default:
        return AppTheme.offlineBg;
    }
  }

  /// Warna border badge status
  Color get statusBorderColor {
    switch (status) {
      case 'Bahaya':
        return AppTheme.dangerBorder;
      case 'Mendekati batas':
        return AppTheme.warningBorder;
      case 'Aman':
        return AppTheme.safeBorder;
      default:
        return AppTheme.offlineBorder;
    }
  }

  /// Ikon representasi arah fluktuasi air (naik, turun, stabil)
  IconData get deltaIcon {
    switch (deltaType) {
      case 'up':
        return Icons.arrow_upward_rounded;
      case 'down':
        return Icons.arrow_downward_rounded;
      default:
        return Icons.remove_rounded;
    }
  }

  /// Warna representasi arah fluktuasi air
  Color get deltaColor {
    switch (deltaType) {
      case 'up':
        return AppTheme.danger;
      case 'down':
        return AppTheme.safe;
      default:
        return AppTheme.textMuted;
    }
  }
}
