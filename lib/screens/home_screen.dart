import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/station_model.dart';
import '../services/ews_data_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bouncing_button.dart';

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
        final selectedStation = stations[_selectedStationIndex];
        final alertStations = _dataService.alertStations;

        return Scaffold(
          backgroundColor: AppTheme.bgLight,
          appBar: _buildWebHeader(context, alertStations.length),
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
                  // Page Heading Eyebrow & Title
                  _buildPageTitle(),

                  const SizedBox(height: 16),

                  // Warning / Danger Banner (matching web warning-banner)
                  if (alertStations.isNotEmpty)
                    _buildWebAlertBanner(alertStations.first),

                  const SizedBox(height: 16),

                  // 4 KPI Stats Grid (Total, Bahaya, Mendekati Batas, Online)
                  _buildKpiStatsGrid(),

                  const SizedBox(height: 20),

                  // Panel Grafik Tren Air
                  _buildChartPanel(stations, selectedStation),

                  const SizedBox(height: 20),

                  // Mini Diagram Visual Ketinggian Talut Sungai
                  _buildRiverLevelDiagram(selectedStation),

                  const SizedBox(height: 24),

                  // Header Titik Pemantauan & Link Lihat Semua
                  Row(
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
                              Text('Semua', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppTheme.brandGreen)),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios_rounded, size: 10.5, color: AppTheme.brandGreen),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 3 Stasiun Preview dalam card putih bersih
                  ...stations.take(3).map((station) => _buildStationCard(station)),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildWebHeader(BuildContext context, int alertCount) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppTheme.border, height: 1),
      ),
      title: Row(
        children: [
          // Green Brand Box
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppTheme.brandGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.waves_rounded, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EWS',
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'KOTA SEMARANG',
                style: GoogleFonts.dmSans(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMuted,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Live dot badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.safeBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppTheme.safe,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                'Sistem aktif',
                style: TextStyle(
                  color: AppTheme.safe,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 6),

        // Bell button
        BouncingButton(
          scaleFactor: 0.88,
          onTap: () => _showAlertsDialog(context),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAF8),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Icon(Icons.notifications_none_rounded, color: AppTheme.textMuted, size: 19),
              ),
              if (alertCount > 0)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.warning,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // User Avatar Circle
        BouncingButton(
          scaleFactor: 0.88,
          onTap: () => widget.onNavigateTab(4),
          child: Container(
            width: 34,
            height: 34,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFEDF1E9),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD8E4DC)),
            ),
            child: Center(
              child: Text(
                _dataService.currentUser.initials,
                style: const TextStyle(
                  color: Color(0xFF647350),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'EARLY WARNING SYSTEM',
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: AppTheme.brandGreen,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'Ringkasan pemantauan',
          style: GoogleFonts.manrope(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.7,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Pantau kondisi sungai dan kesiapan sistem dalam satu tampilan.',
          style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
        ),
      ],
    );
  }

  Widget _buildWebAlertBanner(StationModel station) {
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

  Widget _buildKpiStatsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildWebStatCard(
              width: cardWidth,
              label: 'Total stasiun',
              value: '${_dataService.stations.length}',
              note: '6 titik pantau DPU',
              icon: Icons.pin_drop_outlined,
              isGreen: true,
            ),
            _buildWebStatCard(
              width: cardWidth,
              label: 'Status bahaya',
              value: '${_dataService.dangerCount}',
              note: _dataService.dangerCount > 0 ? 'Perlu tindakan!' : 'Kondisi nihil',
              icon: Icons.crisis_alert_rounded,
              isDanger: _dataService.dangerCount > 0,
            ),
            _buildWebStatCard(
              width: cardWidth,
              label: 'Mendekati batas',
              value: '${_dataService.warningCount}',
              note: 'Waspada peningkatan',
              icon: Icons.shield_outlined,
              isAmber: true,
            ),
            _buildWebStatCard(
              width: cardWidth,
              label: 'Sensor aktif',
              value: '${_dataService.onlineCount}/${_dataService.stations.length}',
              note: 'IoT gateway terhubung',
              icon: Icons.wifi_rounded,
              isGreen: true,
            ),
          ],
        );
      },
    );
  }

  Widget _buildWebStatCard({
    required double width,
    required String label,
    required String value,
    required String note,
    required IconData icon,
    bool isGreen = false,
    bool isAmber = false,
    bool isDanger = false,
  }) {
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
                style: const TextStyle(fontSize: 11, color: AppTheme.textMuted, fontWeight: FontWeight.w500),
              ),
              Icon(icon, size: 16, color: isDanger ? AppTheme.danger : const Color(0xFF87968D)),
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
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              Expanded(
                child: Text(
                  note,
                  style: const TextStyle(fontSize: 9.5, color: AppTheme.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartPanel(List<StationModel> stations, StationModel selectedStation) {
    final chartPoints = _dataService.getChartDataForStation(selectedStation, _selectedRange);
    final spots = chartPoints.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), (e.value['water'] as double));
    }).toList();

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
          // Header with Segmented Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tren Tinggi Muka Air',
                    style: GoogleFonts.manrope(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Text(
                    'Sensor radar telemetry',
                    style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
                  ),
                ],
              ),
              // Segmented Range Switcher
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7F5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: ['6 jam', '24 jam'].map((r) {
                    final isSel = _selectedRange == r;
                    return BouncingButton(
                      scaleFactor: 0.92,
                      onTap: () {
                        setState(() {
                          _selectedRange = r;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSel ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: isSel
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  )
                                ]
                              : null,
                        ),
                        child: Text(
                          r,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                            color: isSel ? AppTheme.brandGreen : AppTheme.textMuted,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Station selector dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedStationIndex,
                isExpanded: true,
                dropdownColor: Colors.white,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.textMuted, size: 20),
                items: stations.asMap().entries.map((entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(
                      entry.value.name,
                      style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                    ),
                  );
                }).toList(),
                onChanged: (newIdx) {
                  if (newIdx != null) {
                    setState(() {
                      _selectedStationIndex = newIdx;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Large Water Value display (matching web .water-value)
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${selectedStation.height}',
                style: GoogleFonts.manrope(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'm',
                style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.safeBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_upward_rounded, size: 11, color: AppTheme.safe),
                    SizedBox(width: 2),
                    Text(
                      '+0,05 m',
                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppTheme.safe),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: selectedStation.statusBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(color: selectedStation.statusColor, shape: BoxShape.circle),
                    ),
                    Text(
                      selectedStation.computedStatus,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: selectedStation.statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Line Chart
          SizedBox(
            height: 175,
            child: LineChart(
              LineChartData(
                minY: 0.5,
                maxY: 5.0,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => const FlLine(
                    color: AppTheme.borderSubtle,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (val, meta) {
                        if (val == 1.0 || val == 2.5 || val == 4.0) {
                          return Text(
                            '${val.toStringAsFixed(1)}m',
                            style: const TextStyle(fontSize: 9, color: AppTheme.textSubtle),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      interval: 3,
                      getTitlesWidget: (val, meta) {
                        final idx = val.toInt();
                        if (idx >= 0 && idx < chartPoints.length) {
                          return Text(
                            chartPoints[idx]['time'] as String,
                            style: const TextStyle(fontSize: 9, color: AppTheme.textSubtle),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppTheme.brandGreen,
                    barWidth: 2.2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.brandGreen.withOpacity(0.18),
                          AppTheme.brandGreen.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                  // Dashed threshold line (Batas Talut)
                  LineChartBarData(
                    spots: [
                      FlSpot(0, selectedStation.limit),
                      FlSpot(spots.length.toDouble() - 1, selectedStation.limit),
                    ],
                    isCurved: false,
                    color: const Color(0xFFD69F42),
                    barWidth: 1.5,
                    dashArray: const [5, 4],
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Chart Footer Legend
          Row(
            children: [
              Row(
                children: [
                  Container(width: 12, height: 2, color: AppTheme.brandGreen),
                  const SizedBox(width: 5),
                  const Text('Tinggi Muka Air', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Container(width: 12, height: 2, color: const Color(0xFFD69F42)),
                  const SizedBox(width: 5),
                  Text('Ambang Batas (${selectedStation.limit} m)', style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiverLevelDiagram(StationModel station) {
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
                      Text('Batas Talut', style: TextStyle(fontSize: 8, color: Colors.grey.shade500)),
                      Text('${station.limit} m', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
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
                            Text('Muka Air', style: TextStyle(fontSize: 9, color: AppTheme.riverText, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Text(
                          '${station.height} m',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.riverText),
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
                        const Text('Curah Hujan', style: TextStyle(fontSize: 9.5, color: AppTheme.textMuted)),
                        Text('${station.rain.toInt()} mm', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
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
                        const Text('IoT Gateway', style: TextStyle(fontSize: 9.5, color: AppTheme.textMuted)),
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

  Widget _buildStationCard(StationModel station) {
    final originalIndex = _dataService.stations.indexOf(station);
    return BouncingButton(
      scaleFactor: 0.96,
      onTap: () {
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
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      child: Row(
        children: [
          // River wave icon in soft square (table-location .river-icon dari web)
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FBF9),
              border: Border.all(color: const Color(0xFFE8EEEA)),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Center(
              child: Icon(Icons.waves_rounded, color: Color(0xFF6A9681), size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  station.name,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  station.area,
                  style: const TextStyle(fontSize: 10.5, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${station.height} m',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: station.statusBackgroundColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(color: station.statusColor, shape: BoxShape.circle),
                    ),
                    Text(
                      station.computedStatus,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: station.statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  void _showAlertsDialog(BuildContext context) {
    final alerts = _dataService.alertStations;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppTheme.warning),
            const SizedBox(width: 8),
            Text('Peringatan Dini EWS', style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        content: alerts.isEmpty
            ? const Text('Semua stasiun sungai saat ini dalam batas aman.', style: TextStyle(fontSize: 13))
            : SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: alerts.length,
                  itemBuilder: (c, i) {
                    final item = alerts[i];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.crisis_alert_rounded,
                        color: item.statusColor,
                      ),
                      title: Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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
            child: const Text('Tutup', style: TextStyle(color: AppTheme.brandGreen, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
