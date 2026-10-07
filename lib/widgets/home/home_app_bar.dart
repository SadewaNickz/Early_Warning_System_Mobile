import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_model.dart';
import '../../theme/app_theme.dart';
import '../bouncing_button.dart';

/// App bar khusus untuk halaman utama (HomeScreen) yang menampilkan
/// identitas sistem EWS, indikator status online, notifikasi peringatan,
/// dan avatar profil pengguna.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int alertCount;
  final UserModel currentUser;
  final VoidCallback onAlertTap;
  final VoidCallback onProfileTap;

  const HomeAppBar({
    super.key,
    required this.alertCount,
    required this.currentUser,
    required this.onAlertTap,
    required this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppTheme.border, height: 1),
      ),
      title: Row(
        children: [
          // Green Brand Box Logo
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
        // Live dot badge 'Sistem aktif'
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

        // Tombol lonceng notifikasi alert dengan animasi bounce
        BouncingButton(
          scaleFactor: 0.88,
          onTap: onAlertTap,
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
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppTheme.textMuted,
                  size: 19,
                ),
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

        // Avatar profil pengguna dengan inisial nama
        BouncingButton(
          scaleFactor: 0.88,
          onTap: onProfileTap,
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
                currentUser.initials,
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
}
