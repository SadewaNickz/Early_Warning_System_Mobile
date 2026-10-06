import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/ews_data_service.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final EwsDataService _dataService = EwsDataService();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _dataService,
      builder: (context, _) {
        final currentUser = _dataService.currentUser;
        final stations = _dataService.stations;

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
              'Profil & Pengaturan Sistem',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Card (matching web .profile)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEDF1E9),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            currentUser.initials,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF647350)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser.name,
                              style: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textPrimary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              currentUser.role,
                              style: const TextStyle(fontSize: 11.5, color: AppTheme.brandGreen, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              currentUser.agency,
                              style: const TextStyle(fontSize: 10.5, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Switch Role
                Text(
                  'Ganti Profil Petugas',
                  style: GoogleFonts.manrope(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 8),

                ..._dataService.userPresets.map((preset) {
                  final isSelected = preset.id == currentUser.id;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.brandGreenLight : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFC8E6D9) : AppTheme.border,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.brandGreen : const Color(0xFFF0F4F1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            preset.initials,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppTheme.textMuted,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        preset.name,
                        style: GoogleFonts.manrope(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                      ),
                      subtitle: Text(
                        preset.role,
                        style: const TextStyle(fontSize: 10.5, color: AppTheme.textMuted),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded, color: AppTheme.brandGreen, size: 20)
                          : null,
                      onTap: () {
                        _dataService.switchUser(preset);
                      },
                    ),
                  );
                }),

                const SizedBox(height: 20),

                // Setting Ambang Batas
                Text(
                  'Pengaturan Ambang Batas Talut (m)',
                  style: GoogleFonts.manrope(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Tentukan batas tinggi muka air pemicu alarm peringatan siaga & bahaya.',
                  style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                ),
                const SizedBox(height: 10),

                ...stations.asMap().entries.map((entry) {
                  final index = entry.key;
                  final s = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            s.name,
                            style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, size: 19, color: AppTheme.textMuted),
                              onPressed: () {
                                if (s.limit > 1.0) {
                                  _dataService.updateStationLimit(index, s.limit - 0.25);
                                }
                              },
                            ),
                            Text(
                              '${s.limit.toStringAsFixed(2)} m',
                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppTheme.danger),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, size: 19, color: AppTheme.brandGreen),
                              onPressed: () {
                                _dataService.updateStationLimit(index, s.limit + 0.25);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // Footer branding
                const Center(
                  child: Column(
                    children: [
                      Text(
                        'EWS Kota Semarang Mobile v1.0.0',
                        style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                      ),
                      Text(
                        'Magang PT. RIES & DPU Kota Semarang',
                        style: TextStyle(fontSize: 10, color: AppTheme.textSubtle),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
