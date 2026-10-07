import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Model representasi data stasiun titik pemantauan sungai EWS.
/// Menyimpan informasi telemetri radar air, curah hujan, ambang batas talut,
/// serta status operasional sensor online/offline.
class StationModel {
  /// Identifier unik stasiun (misal: 'st-1')
  final String id;

  /// Nama stasiun sungai / jembatan pantau
  final String name;

  /// Wilayah / kecamatan lokasi stasiun
  final String area;

  /// Ketinggian Tinggi Muka Air (TMA) saat ini dalam meter
  final double height;

  /// Intensitas curah hujan per jam dalam milimeter (mm)
  final double rain;

  /// Batas ambang talut sungai dalam meter
  final double limit;

  /// Status koneksi sensor IoT Gateway (true: online, false: terputus)
  final bool online;

  const StationModel({
    required this.id,
    required this.name,
    required this.area,
    required this.height,
    required this.rain,
    required this.limit,
    required this.online,
  });

  /// Status terhitung secara otomatis berdasarkan TMA vs Ambang Talut
  String get computedStatus {
    if (!online) return 'Data terputus';
    if (height > limit) return 'Bahaya';
    if (height >= limit * 0.8) return 'Mendekati batas';
    return 'Aman';
  }

  String get status => computedStatus;

  /// Warna representasi status untuk badge / teks indikator
  Color get statusColor {
    switch (computedStatus) {
      case 'Bahaya':
        return AppTheme.danger;
      case 'Mendekati batas':
        return AppTheme.warning;
      case 'Aman':
        return AppTheme.safe;
      case 'Data terputus':
      default:
        return AppTheme.offline;
    }
  }

  /// Warna latar belakang badge status
  Color get statusBackgroundColor {
    switch (computedStatus) {
      case 'Bahaya':
        return AppTheme.dangerBg;
      case 'Mendekati batas':
        return AppTheme.warningBg;
      case 'Aman':
        return AppTheme.safeBg;
      case 'Data terputus':
      default:
        return AppTheme.offlineBg;
    }
  }

  /// Warna garis batas badge status
  Color get statusBorderColor {
    switch (computedStatus) {
      case 'Bahaya':
        return AppTheme.dangerBorder;
      case 'Mendekati batas':
        return AppTheme.warningBorder;
      case 'Aman':
        return AppTheme.safeBorder;
      case 'Data terputus':
      default:
        return AppTheme.offlineBorder;
    }
  }

  /// Membuat salinan objek dengan modifikasi nilai tertentu
  StationModel copyWith({
    String? id,
    String? name,
    String? area,
    double? height,
    double? rain,
    double? limit,
    bool? online,
  }) {
    return StationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      area: area ?? this.area,
      height: height ?? this.height,
      rain: rain ?? this.rain,
      limit: limit ?? this.limit,
      online: online ?? this.online,
    );
  }
}
