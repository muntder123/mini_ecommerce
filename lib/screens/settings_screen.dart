import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/language_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageNotifier = ref.read(languageProvider.notifier);
    final currentLocale = ref.watch(languageProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.language,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('English'),
                    subtitle: const Text('English'),
                    leading: Radio<String>(
                      value: 'en',
                      groupValue: currentLocale.languageCode,
                      onChanged: (value) {
                        if (value != null) {
                          languageNotifier.setLanguage(value);
                        }
                      },
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tileColor: currentLocale.languageCode == 'en'
                        ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    title: const Text('العربية'),
                    subtitle: const Text('Arabic'),
                    leading: Radio<String>(
                      value: 'ar',
                      groupValue: currentLocale.languageCode,
                      onChanged: (value) {
                        if (value != null) {
                          languageNotifier.setLanguage(value);
                        }
                      },
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tileColor: currentLocale.languageCode == 'ar'
                        ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}