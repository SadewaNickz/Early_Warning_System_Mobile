import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/station_model.dart';
import '../services/ews_data_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bouncing_button.dart';
import '../widgets/home/alerts_dialog.dart';
import '../widgets/home/home_alert_banner.dart';
import '../widgets/home/home_app_bar.dart';
import '../widgets/home/home_page_header.dart';
import '../widgets/home/kpi_stats_grid.dart';
import '../widgets/home/river_level_diagram.dart';
import '../widgets/home/station_preview_card.dart';
import '../widgets/home/water_level_chart_panel.dart';

/// Halaman Beranda (HomeScreen) aplikasi EWS Mobile.
/// Berperan sebagai koordinator utama untuk menampilkan metrik pemantauan sungai,
/// banner peringatan siaga, grafik tren ketinggian muka air, diagram talut sungai,
/// dan daftar stasiun pemantauan terdekat/unggulan.
class HomeScreen extends StatefulWidget {
  final Function(int) onNavigateTab;

  const HomeScreen({super.key, required this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EwsDataService _dataService = EwsDataService();
  int _selectedStationIndex = 0;
  String _selectedRange = '24 jam';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _dataService,
      builder: (context, _) {
        final stations = _dataService.stations;
        final selectedStation = stations.isNotEmpty && _selectedStationIndex < stations.length
            ? stations[_selectedStationIndex]
            : (stations.isNotEmpty ? stations.first : null);
        final alertStations = _dataService.alertStations;

        return Scaffold(
          backgroundColor: AppTheme.bgLight,
          appBar: HomeAppBar(
            alertCount: alertStations.length,
            currentUser: _dataService.currentUser,
            onAlertTap: () => AlertsDialog.show(context, alertStations),
            onProfileTap: () => widget.onNavigateTab(4),
          ),
          body: RefreshIndicator(
            color: AppTheme.brandGreen,
            backgroundColor: Colors.white,
            onRefresh: () async {
              _dataService.refreshData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul dan deskripsi halaman
                  const HomePageHeader(),

                  const SizedBox(height: 16),

                  // Banner peringatan siaga darurat (jika ada stasiun dalam status bahaya/waspada)
                  if (alertStations.isNotEmpty)
                    HomeAlertBanner(station: alertStations.first),

                  const SizedBox(height: 16),

                  // Grid 4 kartu ringkasan KPI (Total stasiun, Bahaya, Mendekati batas, Online)
                  KpiStatsGrid(
                    totalStations: stations.length,
                    dangerCount: _dataService.dangerCount,
                    warningCount: _dataService.warningCount,
                    onlineCount: _dataService.onlineCount,
                  ),

                  const SizedBox(height: 20),

                  // Panel grafik tren ketinggian air (FlChart)
                  if (selectedStation != null)
                    WaterLevelChartPanel(
                      stations: stations,
                      selectedStationIndex: _selectedStationIndex,
                      selectedRange: _selectedRange,
                      chartPoints: _dataService.getChartDataForStation(
                        selectedStation,
                        _selectedRange,
                      ),
                      onStationChanged: (newIdx) {
                        setState(() {
                          _selectedStationIndex = newIdx;
                        });
                      },
                      onRangeChanged: (newRange) {
                        setState(() {
                          _selectedRange = newRange;
                        });
                      },
                    ),

                  const SizedBox(height: 20),

                  // Diagram visual penampang talut sungai berbentuk U
                  if (selectedStation != null)
                    RiverLevelDiagram(station: selectedStation),

                  const SizedBox(height: 24),

                  // Header seksi titik pemantauan & tombol pintas 'Semua'
                  _buildSectionHeader(context),

                  const SizedBox(height: 10),

                  // 3 Kartu preview titik pemantauan sungai
                  ...stations.take(3).map((station) {
                    final originalIndex = stations.indexOf(station);
                    return StationPreviewCard(
                      station: station,
                      onTap: () => _onStationCardTap(station, originalIndex),
                    );
                  }),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lokasi Pemantauan Sungai',
              style: GoogleFonts.manrope(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const Text(
              'Kondisi sensor radar lapangan terkini',
              style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
            ),
          ],
        ),
        BouncingButton(
          scaleFactor: 0.90,
          onTap: () => widget.onNavigateTab(1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.brandGreenLight,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFC8E6D9)),
            ),
            child: const Row(
              children: [
                Text(
                  'Semua',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.brandGreen,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 10.5,
                  color: AppTheme.brandGreen,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onStationCardTap(StationModel station, int originalIndex) {
    setState(() {
      if (originalIndex >= 0) {
        _selectedStationIndex = originalIndex;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.water_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Memilih ${station.name} (${station.height} m)',
                style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF138568),
        duration: const Duration(milliseconds: 1400),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
