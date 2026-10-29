import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../widgets/app_header.dart';
import 'dashboard_screen.dart';
import 'ml_predictor_screen.dart';
import 'academic_tracker_screen.dart';
import 'study_buddy_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<String> _subtitles = const [
    'Dashboard',
    'ML Predict',
    'Academic Tracker',
    'AI Study Buddy',
    'Settings',
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        subtitle: _subtitles[_currentIndex],
        onProfileTap: () {
          setState(() {
            _currentIndex = 4; // Switch to settings
          });
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardScreen(onNavigateToTab: _onTabSelected),
          const MlPredictorScreen(),
          const AcademicTrackerScreen(),
          const StudyBuddyScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.95),
          border: const Border(
            top: BorderSide(color: AppColors.borderSubtle, width: 1),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, 'Home', Icons.dashboard_outlined, Icons.dashboard),
                _buildNavItem(1, 'Predict', Icons.batch_prediction_outlined, Icons.batch_prediction),
                _buildNavItem(2, 'Tracker', Icons.bar_chart, Icons.bar_chart),
                _buildNavItem(3, 'Buddy', Icons.psychology_outlined, Icons.psychology),
                _buildNavItem(4, 'Settings', Icons.manage_accounts_outlined, Icons.manage_accounts),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon, IconData activeIcon) {
    final bool isSelected = _currentIndex == index;
    final color = isSelected ? AppColors.primary : AppColors.onSurfaceVariant;

    return Expanded(
      child: InkWell(
        onTap: () => _onTabSelected(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: color,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTypography.fontBody,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


