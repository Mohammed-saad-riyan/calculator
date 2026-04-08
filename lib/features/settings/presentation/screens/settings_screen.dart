import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import 'package:a_scientific_calculator_application_to_perform_mor/app/app.dart';
import 'package:a_scientific_calculator_application_to_perform_mor/features/settings/providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: settings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading settings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Error: $error',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(settingsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (settingsData) => _buildContent(context, ref, settingsData),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, Map<String, dynamic> settingsData) {
    final theme = Theme.of(context);
    final isDarkTheme = settingsData['theme'] == 'dark';
    final notificationsEnabled = settingsData['notifications'] ?? true;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.palette_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Appearance',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Semantics(
                label: 'Toggle dark theme',
                child: SwitchListTile(
                  title: const Text('Dark Theme'),
                  subtitle: Text(
                    isDarkTheme ? 'Using dark theme' : 'Using light theme',
                  ),
                  value: isDarkTheme,
                  secondary: Icon(
                    isDarkTheme ? Icons.dark_mode : Icons.light_mode,
                  ),
                  onChanged: (bool value) {
                    ref.read(settingsProvider.notifier).updateTheme(
                      value ? 'dark' : 'light',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Notifications',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Semantics(
                label: 'Toggle notifications',
                child: SwitchListTile(
                  title: const Text('Enable Notifications'),
                  subtitle: Text(
                    notificationsEnabled
                        ? 'Notifications are enabled'
                        : 'Notifications are disabled',
                  ),
                  value: notificationsEnabled,
                  secondary: Icon(
                    notificationsEnabled
                        ? Icons.notifications_active
                        : Icons.notifications_off,
                  ),
                  onChanged: (bool value) {
                    ref.read(settingsProvider.notifier).updateNotifications(value);
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'About',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Semantics(
                label: 'View app information',
                child: ListTile(
                  title: const Text('App Information'),
                  subtitle: const Text('Version, licenses, and more'),
                  leading: const Icon(Icons.info),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Scientific Calculator',
                      applicationVersion: '1.0.0',
                      applicationIcon: const Icon(Icons.calculate),
                      children: [
                        const Text(
                          'A powerful scientific calculator application with advanced mathematical functions.',
                        ),
                      ],
                    );
                  },
                ),
              ),
              Semantics(
                label: 'Reset settings to default',
                child: ListTile(
                  title: const Text('Reset Settings'),
                  subtitle: const Text('Reset all settings to default values'),
                  leading: const Icon(Icons.refresh),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showResetDialog(context, ref);
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Settings'),
          content: const Text(
            'Are you sure you want to reset all settings to their default values? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                ref.read(settingsProvider.notifier).resetSettings();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings reset to default values'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}