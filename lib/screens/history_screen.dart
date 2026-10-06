import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/ews_data_service.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final EwsDataService _dataService = EwsDataService();
  String _searchFilter = '';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _dataService,
      builder: (context, _) {
        final logs = _dataService.historicalLogs.where((l) {
          final query = _searchFilter.toLowerCase();
          return l.stationName.toLowerCase().contains(query) ||
              l.area.toLowerCase().contains(query) ||
              l.action.toLowerCase().contains(query);
        }).toList();

        return Scaffold(
          backgroundColor: AppTheme.bgLight,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: AppTheme.border, height: 1),
            ),
            title: Text(
              'Riwayat & Laporan',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          body: Column(
            children: [
              // Search field
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: TextField(
                  style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Cari riwayat telemetri / tindakan...',
                    hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textMuted, size: 20),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchFilter = val;
                    });
                  },
                ),
              ),

              // Summary banner
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.brandGreenLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFC8E6D9)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.history_rounded, color: AppTheme.brandGreen, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Pencatatan telemetri otomatis per jam sinkron dengan server DPU Semarang.',
                        style: TextStyle(fontSize: 11, color: AppTheme.brandGreenDark, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // List of logs
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                log.id,
                                style: const TextStyle(
                                  color: AppTheme.brandGreen,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                log.time,
                                style: const TextStyle(color: AppTheme.textMuted, fontSize: 10.5),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            log.stationName,
                            style: GoogleFonts.manrope(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                          ),
                          Text(
                            log.area,
                            style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7FAF8),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppTheme.borderSubtle),
                                ),
                                child: Row(
                                  children: [
                                    const Text('TMA: ', style: TextStyle(fontSize: 10.5, color: AppTheme.textMuted)),
                                    Text(
                                      '${log.height} m',
                                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon(log.deltaIcon, size: 12, color: log.deltaColor),
                                    Text(
                                      log.delta,
                                      style: TextStyle(fontSize: 10.5, color: log.deltaColor, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7FAF8),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppTheme.borderSubtle),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.cloud_outlined, size: 13, color: Color(0xFF6B8074)),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${log.rainTotal.toInt()} mm',
                                      style: const TextStyle(fontSize: 11, color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFBFB),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppTheme.borderSubtle),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.shield_outlined, size: 14, color: Color(0xFF87968D)),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    log.action,
                                    style: const TextStyle(fontSize: 10.5, color: AppTheme.textPrimary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
