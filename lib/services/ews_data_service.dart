import 'package:flutter/foundation.dart';
import '../models/station_model.dart';
import '../models/log_model.dart';
import '../models/user_model.dart';

class EwsDataService extends ChangeNotifier {
  // Singleton pattern for easy global access
  static final EwsDataService _instance = EwsDataService._internal();
  factory EwsDataService() => _instance;
  EwsDataService._internal();

  // User Presets
  final List<UserModel> userPresets = const [
    UserModel(
      id: 'DPU-OP-01',
      name: 'Alvin / Operator DPU',
      role: 'Operator Command Room',
      agency: 'Dinas Pekerjaan Umum Kota Semarang',
      initials: 'AP',
    ),
    UserModel(
      id: 'UPTD-RP-04',
      name: 'Pak Tedi / Petugas Pompa',
      role: 'Operator Rumah Pompa',
      agency: 'UPTD Drainase & Rumah Pompa Semarang',
      initials: 'PT',
    ),
    UserModel(
      id: 'DPU-STR-02',
      name: 'Pak Taufiq / Pak Fahmi',
      role: 'Kepala UPTD / Pejabat Struktural',
      agency: 'Dinas Pekerjaan Umum Kota Semarang',
      initials: 'TF',
    ),
  ];

  late UserModel currentUser = userPresets[0];

  // Base Stations (sama persis dengan EWS-WEB)
  final List<StationModel> _stations = [
    const StationModel(
      id: 'ST-BKB',
      name: 'Sungai Banjir Kanal Barat',
      area: 'Jembatan Lemah Gempal',
      height: 2.35,
      rain: 12.0,
      limit: 4.5,
      online: true,
    ),
    const StationModel(
      id: 'ST-BKT',
      name: 'Sungai Banjir Kanal Timur',
      area: 'Jembatan Citarum',
      height: 3.82,
      rain: 28.0,
      limit: 4.5,
      online: true,
    ),
    const StationModel(
      id: 'ST-GRG',
      name: 'Sungai Garang',
      area: 'Jembatan Tinjomoyo',
      height: 1.85,
      rain: 8.0,
      limit: 4.0,
      online: true,
    ),
    const StationModel(
      id: 'ST-KRE',
      name: 'Sungai Kreo',
      area: 'Jembatan Kalipancur',
      height: 1.42,
      rain: 5.0,
      limit: 3.5,
      online: true,
    ),
    const StationModel(
      id: 'ST-TGG',
      name: 'Sungai Tenggang',
      area: 'Jembatan Kaligawe',
      height: 2.68,
      rain: 18.0,
      limit: 3.5,
      online: true,
    ),
    const StationModel(
      id: 'ST-BBN',
      name: 'Sungai Babon',
      area: 'Jembatan Penggaron',
      height: 1.76,
      rain: 0.0,
      limit: 4.0,
      online: false,
    ),
  ];

  List<StationModel> get stations => _stations;

  // Hourly base series for trend chart
  final List<double> baseSeries = const [
    1.65, 1.72, 1.68, 1.78, 1.82, 1.76, 1.93, 2.08, 2.03, 2.17, 2.12, 2.23, 2.29, 2.22, 2.35,
  ];

  // Historical Logs (sama persis dengan EWS-WEB)
  final List<LogModel> historicalLogs = const [
    LogModel(
      id: 'LOG-8891',
      time: '05 Okt 2026, 10:00 WIB',
      stationIndex: 1,
      stationName: 'Sungai Banjir Kanal Timur',
      area: 'Jembatan Citarum',
      height: 3.82,
      delta: '+0,12 m',
      deltaType: 'up',
      rainHour: 14.2,
      rainTotal: 28.0,
      limit: 4.5,
      status: 'Mendekati batas',
      action: 'Notifikasi Alarm Siaga Dikirim • Pemantauan Diintensifkan',
    ),
    LogModel(
      id: 'LOG-8890',
      time: '05 Okt 2026, 09:00 WIB',
      stationIndex: 1,
      stationName: 'Sungai Banjir Kanal Timur',
      area: 'Jembatan Citarum',
      height: 3.70,
      delta: '+0,15 m',
      deltaType: 'up',
      rainHour: 18.0,
      rainTotal: 25.0,
      limit: 4.5,
      status: 'Mendekati batas',
      action: 'Pintu Air DPU Siaga • Petugas Standby',
    ),
    LogModel(
      id: 'LOG-8889',
      time: '05 Okt 2026, 08:30 WIB',
      stationIndex: 0,
      stationName: 'Sungai Banjir Kanal Barat',
      area: 'Jembatan Lemah Gempal',
      height: 2.35,
      delta: '+0,05 m',
      deltaType: 'up',
      rainHour: 6.0,
      rainTotal: 12.0,
      limit: 4.5,
      status: 'Aman',
      action: 'Normal • Aliran Terkendali',
    ),
    LogModel(
      id: 'LOG-8888',
      time: '05 Okt 2026, 08:00 WIB',
      stationIndex: 4,
      stationName: 'Sungai Tenggang',
      area: 'Jembatan Kaligawe',
      height: 2.68,
      delta: '+0,10 m',
      deltaType: 'up',
      rainHour: 8.5,
      rainTotal: 18.0,
      limit: 3.5,
      status: 'Aman',
      action: 'Pompa Drainase Rumah Pompa Standby',
    ),
    LogModel(
      id: 'LOG-8887',
      time: '05 Okt 2026, 07:00 WIB',
      stationIndex: 2,
      stationName: 'Sungai Garang',
      area: 'Jembatan Tinjomoyo',
      height: 1.85,
      delta: '+0,02 m',
      deltaType: 'up',
      rainHour: 4.0,
      rainTotal: 8.0,
      limit: 4.0,
      status: 'Aman',
      action: 'Normal • Pengukuran Rutin',
    ),
    LogModel(
      id: 'LOG-8886',
      time: '05 Okt 2026, 06:00 WIB',
      stationIndex: 3,
      stationName: 'Sungai Kreo',
      area: 'Jembatan Kalipancur',
      height: 1.42,
      delta: '-0,03 m',
      deltaType: 'down',
      rainHour: 2.0,
      rainTotal: 5.0,
      limit: 3.5,
      status: 'Aman',
      action: 'Normal • Muka Air Surut',
    ),
    LogModel(
      id: 'LOG-8885',
      time: '05 Okt 2026, 05:00 WIB',
      stationIndex: 5,
      stationName: 'Sungai Babon',
      area: 'Jembatan Penggaron',
      height: 1.76,
      delta: '0,00 m',
      deltaType: 'steady',
      rainHour: 0.0,
      rainTotal: 0.0,
      limit: 4.0,
      status: 'Data terputus',
      action: 'Periksa Gateway Lapangan • Sinyal Hilang',
    ),
    LogModel(
      id: 'LOG-8884',
      time: '05 Okt 2026, 04:00 WIB',
      stationIndex: 1,
      stationName: 'Sungai Banjir Kanal Timur',
      area: 'Jembatan Citarum',
      height: 3.55,
      delta: '+0,20 m',
      deltaType: 'up',
      rainHour: 22.5,
      rainTotal: 20.0,
      limit: 4.5,
      status: 'Aman',
      action: 'Hujan Intensitas Lebat Terdeteksi',
    ),
  ];

  // Helper getters
  int get dangerCount => _stations.where((s) => s.computedStatus == 'Bahaya').length;
  int get warningCount => _stations.where((s) => s.computedStatus == 'Mendekati batas').length;
  int get safeCount => _stations.where((s) => s.computedStatus == 'Aman').length;
  int get offlineCount => _stations.where((s) => !s.online).length;
  int get onlineCount => _stations.where((s) => s.online).length;

  List<StationModel> get alertStations =>
      _stations.where((s) => s.computedStatus == 'Bahaya' || s.computedStatus == 'Mendekati batas').toList();

  // Methods
  void updateStationLimit(int index, double newLimit) {
    if (index >= 0 && index < _stations.length) {
      _stations[index] = _stations[index].copyWith(limit: newLimit);
      notifyListeners();
    }
  }

  void switchUser(UserModel user) {
    currentUser = user;
    notifyListeners();
  }

  void refreshData() {
    // In actual deployment, this fetches from HTTP/REST or MQTT broker
    notifyListeners();
  }

  // Generate chart data series based on station
  List<Map<String, dynamic>> getChartDataForStation(StationModel station, String range) {
    return List.generate(baseSeries.length, (index) {
      final hour = range == '6 jam' ? (4 + index / 3).floor() : (index * 1.6).floor();
      final timeStr = '${hour.toString().padLeft(2, '0')}:00';
      final val = double.parse((baseSeries[index] + station.height - 2.35).toStringAsFixed(2));
      return {
        'time': timeStr,
        'water': val < 0.2 ? 0.2 : val,
      };
    });
  }
}
