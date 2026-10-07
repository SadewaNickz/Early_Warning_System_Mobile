import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/ews_data_service.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final EwsDataService _dataService = EwsDataService();

  late final AnimationController _entryController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  late final AnimationController _waveController;

  bool _obscurePassword = true;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Entry animation (cards & header smoothly fade & slide in)
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    ));

    // Ambient water wave loop animation
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _waveController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    final error = _dataService.login(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
      _errorMessage = error;
    });

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Selamat datang, ${_dataService.currentUser.name}',
                  style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1C4939),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _selectPreset(String username) {
    _usernameController.text = username;
    _passwordController.text = '123456';
    setState(() {
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: Stack(
        children: [
          // Ambient soft glowing orbs in the background
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.brandGreen.withOpacity(0.12),
                    AppTheme.brandGreen.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF71B6AA).withOpacity(0.14),
                    const Color(0xFF71B6AA).withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          // Animated Subtle River Water Waves Background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _SubtleBackgroundWavePainter(
                    animationValue: _waveController.value,
                  ),
                );
              },
            ),
          ),

          // Main Content with Slide & Fade Transition
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated Glowing Logo & Brand Header
                          _buildBrandHeader(),
                          const SizedBox(height: 28),

                          // Glassmorphism Login Card
                          _buildGlassCard(context),
                          const SizedBox(height: 24),

                          // Footer Meta
                          _buildFooterMeta(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Soft breathing glow behind logo
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, _) {
                final scale = 1.0 + 0.08 * math.sin(_waveController.value * 2 * math.pi);
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppTheme.brandGreen.withOpacity(0.20),
                    ),
                  ),
                );
              },
            ),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF169A78),
                    Color(0xFF0F6E55),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.brandGreen.withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.waves_rounded, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'EWS',
          style: GoogleFonts.manrope(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A332A),
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Masuk ke Sistem Pemantauan Dini Sungai',
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: 13.5,
            color: AppTheme.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.88),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.85),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF138568).withOpacity(0.05),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Field: Nama Pengguna
              Text(
                'Nama pengguna',
                style: GoogleFonts.dmSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2B3E34),
                ),
              ),
              const SizedBox(height: 7),
              TextField(
                controller: _usernameController,
                style: GoogleFonts.dmSans(fontSize: 14.5, color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: 'NIP atau ID petugas',
                  hintStyle: GoogleFonts.dmSans(color: const Color(0xFFA4B0AA), fontSize: 13.5),
                  prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF81948B), size: 20),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.95),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(color: Color(0xFFE2E9E5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(color: AppTheme.brandGreen, width: 1.8),
                  ),
                ),
                onChanged: (_) {
                  if (_errorMessage != null) {
                    setState(() => _errorMessage = null);
                  }
                },
              ),
              const SizedBox(height: 18),

              // Field: Kata Sandi
              Text(
                'Kata sandi',
                style: GoogleFonts.dmSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2B3E34),
                ),
              ),
              const SizedBox(height: 7),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: GoogleFonts.dmSans(fontSize: 14.5, color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Masukkan kata sandi',
                  hintStyle: GoogleFonts.dmSans(color: const Color(0xFFA4B0AA), fontSize: 13.5),
                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF81948B), size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: const Color(0xFF81948B),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.95),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(color: Color(0xFFE2E9E5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(color: AppTheme.brandGreen, width: 1.8),
                  ),
                ),
                onChanged: (_) {
                  if (_errorMessage != null) {
                    setState(() => _errorMessage = null);
                  }
                },
                onSubmitted: (_) => _handleLogin(),
              ),

              // Error Banner
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.dangerBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.dangerBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, size: 16, color: AppTheme.danger),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: GoogleFonts.dmSans(
                            fontSize: 12.5,
                            color: AppTheme.danger,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 22),

              // Submit Button with Soft Emerald Gradient
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF138568),
                      Color(0xFF0F7057),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.brandGreen.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                        )
                      : Text(
                          'Masuk',
                          style: GoogleFonts.manrope(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),
              const Divider(color: Color(0xFFE8EFEA), height: 1),
              const SizedBox(height: 14),

              // Quick Presets
              Row(
                children: [
                  const Icon(Icons.flash_on_rounded, size: 14, color: AppTheme.brandGreen),
                  const SizedBox(width: 4),
                  Text(
                    'Pilihan Akun Demo (Cepat):',
                    style: GoogleFonts.dmSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  _buildPresetChip('Alvin / Operator DPU', 'DPU-OP-01', Icons.computer_rounded),
                  _buildPresetChip('Pak Tedi / Petugas Pompa', 'UPTD-RP-04', Icons.water_drop_outlined),
                  _buildPresetChip('Pak Taufiq / Pejabat', 'DPU-STR-02', Icons.verified_user_outlined),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPresetChip(String label, String id, IconData icon) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectPreset(id),
        borderRadius: BorderRadius.circular(7),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F6F2),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: const Color(0xFFD8E4DC)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13, color: AppTheme.brandGreen),
              const SizedBox(width: 5),
              Text(
                label.split('/')[0].trim(),
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E5B48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterMeta() {
    return Column(
      children: [
        Text(
          'Dinas Pekerjaan Umum Kota Semarang',
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: const Color(0xFF7D8C83),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'v1.0 • Magang PT. RIES',
          style: GoogleFonts.dmSans(
            fontSize: 11,
            color: const Color(0xFF9CAAA1),
          ),
        ),
      ],
    );
  }
}

/// Custom painter that draws subtle flowing waves at the top & bottom of the screen
class _SubtleBackgroundWavePainter extends CustomPainter {
  final double animationValue;

  _SubtleBackgroundWavePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Top Wave Layer 1
    final paint1 = Paint()
      ..color = const Color(0xFF138568).withOpacity(0.045)
      ..style = PaintingStyle.fill;

    final path1 = Path();
    path1.moveTo(0, 0);
    path1.lineTo(0, height * 0.18);
    for (double x = 0; x <= width; x += 10) {
      final y = height * 0.18 +
          18 * math.sin((x / width * 2 * math.pi) + (animationValue * 2 * math.pi));
      path1.lineTo(x, y);
    }
    path1.lineTo(width, 0);
    path1.close();
    canvas.drawPath(path1, paint1);

    // Top Wave Layer 2 (Offset phase)
    final paint2 = Paint()
      ..color = const Color(0xFF71B6AA).withOpacity(0.035)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, 0);
    path2.lineTo(0, height * 0.14);
    for (double x = 0; x <= width; x += 10) {
      final y = height * 0.14 +
          14 * math.cos((x / width * 2.5 * math.pi) - (animationValue * 2 * math.pi));
      path2.lineTo(x, y);
    }
    path2.lineTo(width, 0);
    path2.close();
    canvas.drawPath(path2, paint2);

    // Bottom Wave Layer 3
    final paint3 = Paint()
      ..color = const Color(0xFF138568).withOpacity(0.04)
      ..style = PaintingStyle.fill;

    final path3 = Path();
    path3.moveTo(0, height);
    path3.lineTo(0, height * 0.88);
    for (double x = 0; x <= width; x += 10) {
      final y = height * 0.88 +
          16 * math.sin((x / width * 2 * math.pi) - (animationValue * 2 * math.pi));
      path3.lineTo(x, y);
    }
    path3.lineTo(width, height);
    path3.close();
    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(covariant _SubtleBackgroundWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
