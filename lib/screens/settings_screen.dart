import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _targetGpa = 3.90;
  bool _liveSyncEnabled = true;
  bool _notificationAlerts = true;
  bool _aiAutonomousInterventions = true;
  String _selectedModel = 'Random Forest Regressor v2.4 (Active)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Profile Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.tertiary],
                      ),
                      border: Border.all(color: AppColors.primaryContainer, width: 2),
                    ),
                    child: const Center(
                      child: Text(
                        'SK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Shivam Kumar Suman', style: AppTypography.headlineSm),
                        Text('ID: CS21B042 • B.Tech CS & AI', style: AppTypography.bodySm),
                        SizedBox(height: 4),
                        Text(
                          'Indian Institute of Technology • Batch 2026',
                          style: TextStyle(
                            fontFamily: AppTypography.fontBody,
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Academic Target Settings
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Academic Targets & Benchmarks', style: AppTypography.titleMd),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Target Semester GPA', style: AppTypography.labelMd),
                      Text(
                        _targetGpa.toStringAsFixed(2),
                        style: AppTypography.labelLg.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _targetGpa,
                    min: 3.0,
                    max: 4.0,
                    divisions: 20,
                    onChanged: (val) {
                      setState(() {
                        _targetGpa = val;
                      });
                    },
                  ),
                  const Text(
                    'Institutional minimum for Dean\'s List is 3.75.',
                    style: AppTypography.labelSm,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // AI Model Configuration
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('AI Predictive Model Engine', style: AppTypography.titleMd),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedModel,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surfaceContainerLow,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Random Forest Regressor v2.4 (Active)',
                        child: Text('Random Forest Regressor v2.4 (Active)',
                            style: AppTypography.labelMd),
                      ),
                      DropdownMenuItem(
                        value: 'Gradient Boosted Tree (XGBoost)',
                        child: Text('Gradient Boosted Tree (XGBoost)',
                            style: AppTypography.labelMd),
                      ),
                      DropdownMenuItem(
                        value: 'Bayesian Neural Network Ensemble',
                        child: Text('Bayesian Neural Network Ensemble',
                            style: AppTypography.labelMd),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedModel = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Live Model Sync', style: AppTypography.labelMd),
                    subtitle: const Text('Auto-sync grades from LMS daily',
                        style: AppTypography.bodySm),
                    value: _liveSyncEnabled,
                    activeColor: AppColors.primaryContainer,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _liveSyncEnabled = val),
                  ),
                  SwitchListTile(
                    title: const Text('Autonomous Interventions', style: AppTypography.labelMd),
                    subtitle: const Text('Generate automatic recovery schedules',
                        style: AppTypography.bodySm),
                    value: _aiAutonomousInterventions,
                    activeColor: AppColors.primaryContainer,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _aiAutonomousInterventions = val),
                  ),
                  SwitchListTile(
                    title: const Text('Early Warning Push Alerts', style: AppTypography.labelMd),
                    subtitle: const Text('Notify when attendance or quiz dips below 75%',
                        style: AppTypography.bodySm),
                    value: _notificationAlerts,
                    activeColor: AppColors.primaryContainer,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _notificationAlerts = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Export & Institutional Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Institutional Integration', style: AppTypography.titleMd),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.cloud_sync_outlined, color: AppColors.primary),
                    title: const Text('Sync with Canvas LMS', style: AppTypography.labelLg),
                    subtitle: const Text('Last synced today at 09:15 AM', style: AppTypography.bodySm),
                    trailing: const Icon(Icons.chevron_right),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('LMS API synchronization completed successfully!')),
                      );
                    },
                  ),
                  const Divider(color: AppColors.borderSubtle),
                  ListTile(
                    leading: const Icon(Icons.download_for_offline_outlined, color: AppColors.tertiary),
                    title: const Text('Export Transcripts & Analytics (PDF)', style: AppTypography.labelLg),
                    subtitle: const Text('Official institutional grade prediction docket', style: AppTypography.bodySm),
                    trailing: const Icon(Icons.chevron_right),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Generating PDF docket...')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

