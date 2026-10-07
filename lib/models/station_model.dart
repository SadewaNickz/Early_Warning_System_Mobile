import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StationModel {
  final String id;
  final String name;
  final String area;
  final double height;
  final double rain;
  final double limit;
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

  String get computedStatus {
    if (!online) return 'Data terputus';
    if (height > limit) return 'Bahaya';
    if (height >= limit * 0.8) return 'Mendekati batas';
    return 'Aman';
  }

  String get status => computedStatus;

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
