import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/station_model.dart';
import '../services/ews_data_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bouncing_button.dart';
import '../widgets/stations/station_card.dart';
import '../widgets/stations/station_detail_sheet.dart';

/// Halaman daftar titik pemantauan sungai (StationsScreen).
/// Menyediakan fitur pencarian nama stasiun/wilayah, penyaringan berdasarkan status
/// (Aman, Mendekati batas, Bahaya, Data terputus), serta modal detail lengkap stasiun.
class StationsScreen extends StatefulWidget {
  const StationsScreen({super.key});

  @override
  State<StationsScreen> createState() => _StationsScreenState();
}

class _StationsScreenState extends State<StationsScreen> {
  final EwsDataService _dataService = EwsDataService();
  String _searchQuery = '';
  String _selectedStatusFilter = 'Semua status';

  static const List<String> _statusFilters = [
    'Semua status',
    'Aman',
    'Mendekati batas',
    'Bahaya',
    'Data terputus',
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _dataService,
      builder: (context, _) {
        final stations = _dataService.stations;
        final filteredStations = stations.where((s) {
          final query = _searchQuery.toLowerCase();
          final matchesSearch = '${s.name} ${s.area}'.toLowerCase().contains(query);
          final matchesFilter =
              _selectedStatusFilter == 'Semua status' || s.computedStatus == _selectedStatusFilter;
          return matchesSearch && matchesFilter;
        }).toList();

        return Scaffold(
          backgroundColor: AppTheme.bgLight,
          appBar: _buildAppBar(context),
          body: Column(
            children: [
              // Kolom input pencarian stasiun
              _buildSearchInput(),

              // Filter status berbentuk pill horizontal
              _buildFilterChips(),

              const SizedBox(height: 10),

              // Daftar stasiun sungai hasil pencarian & filter
              Expanded(
                child: _buildStationsList(filteredStations),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppTheme.border, height: 1),
      ),
      title: Text(
        'Lokasi Pemantauan',
        style: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: AppTheme.brandGreen, size: 21),
          tooltip: 'Segarkan data',
          onPressed: () {
            _dataService.refreshData();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data sensor stasiun telah diperbarui'),
                duration: Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Cari nama sungai atau jembatan...',
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
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppTheme.brandGreen),
          ),
        ),
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _statusFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, idx) {
          final filterName = _statusFilters[idx];
          final isSelected = _selectedStatusFilter == filterName;
          return BouncingButton(
            scaleFactor: 0.90,
            onTap: () {
              setState(() {
                _selectedStatusFilter = filterName;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.brandGreenLight : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected ? const Color(0xFFC8E6D9) : AppTheme.border,
                  width: isSelected ? 1.5 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                filterName,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppTheme.brandGreen : AppTheme.textMuted,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStationsList(List<StationModel> filteredStations) {
    if (filteredStations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 40, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            const Text(
              'Tidak ada titik pantau yang cocok',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: filteredStations.length,
      itemBuilder: (context, index) {
        final station = filteredStations[index];
        return StationCard(
          station: station,
          onTap: () => StationDetailSheet.show(context, station),
        );
      },
    );
  }
}
