import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LogModel {
  final String id;
  final String time;
  final int stationIndex;
  final String stationName;
  final String area;
  final double height;
  final String delta;
  final String deltaType; // 'up', 'down', 'steady'
  final double rainHour;
  final double rainTotal;
  final double limit;
  final String status;
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
