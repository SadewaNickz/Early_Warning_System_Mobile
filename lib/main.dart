import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/stations_screen.dart';
import 'screens/cctv_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';
import 'services/ews_data_service.dart';
import 'theme/app_theme.dart';
import 'widgets/animated_bottom_nav_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const EwsApp());
}

class EwsApp extends StatelessWidget {
  const EwsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = EwsDataService();

    return MaterialApp(
      title: 'EWS Kota Semarang',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: ListenableBuilder(
        listenable: dataService,
        builder: (context, _) {
          if (!dataService.isAuthenticated) {
            return const LoginScreen();
          }
          return const MainNavigationShell();
        },
      ),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<NavItemData> _navItems = const [
    NavItemData(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard_rounded,
      label: 'Ringkasan',
    ),
    NavItemData(
      icon: Icons.location_on_outlined,
      activeIcon: Icons.location_on_rounded,
      label: 'Lokasi',
    ),
    NavItemData(
      icon: Icons.videocam_outlined,
      activeIcon: Icons.videocam_rounded,
      label: 'CCTV',
    ),
    NavItemData(
      icon: Icons.history_outlined,
      activeIcon: Icons.history_rounded,
      label: 'Riwayat',
    ),
    NavItemData(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Akun',
    ),
  ];

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onNavigateTab: _navigateToTab),
      const StationsScreen(),
      const CctvScreen(),
      const HistoryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: AnimatedEwsNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _navItems,
      ),
    );
  }
}
