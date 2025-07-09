import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod_tmplt/features/settings/presentation/controllers/settings_state.dart';
import '../../../../core/providers.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/adaptive_theme.dart';
import '../../../../core/widgets/adaptive_scaffold.dart';
import '../../../../core/widgets/adaptive_button.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/result.dart';
import '../controllers/settings_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsState = ref.watch(settingsControllerProvider);
    
    return AdaptiveScaffold(
      title: l10n.settings,
      body: settingsState.when(
        data: (settings) => _buildSettingsContent(context, ref, l10n, settings),
        loading: () => LoadingWidget(message: l10n.loadingSettings),
        error: (error, stack) => CustomErrorWidget(
          message: '${l10n.failedToLoadSettings}: $error',
          onRetry: () => ref.read(settingsControllerProvider.notifier).refresh(),
        ),
      ),
    );
  }

  Widget _buildSettingsContent(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    SettingsState settings,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Show error if any
          if (settings.error != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      settings.error!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => ref.read(settingsControllerProvider.notifier).clearError(),
                    color: Colors.red.shade700,
                  ),
                ],
              ),
            ),
          
          _buildSection(
            title: l10n.themeSettings,
            children: [
              _buildThemeOption(
                context,
                ref,
                l10n,
                AppThemeType.light,
                settings.currentTheme,
                Icons.light_mode,
              ),
              _buildThemeOption(
                context,
                ref,
                l10n,
                AppThemeType.dark,
                settings.currentTheme,
                Icons.dark_mode,
              ),
              _buildThemeOption(
                context,
                ref,
                l10n,
                AppThemeType.system,
                settings.currentTheme,
                Icons.settings_system_daydream,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: l10n.languageSettings,
            children: [
              _buildLanguageOption(
                context,
                ref,
                l10n,
                'en',
                settings.currentLanguage,
                '🇺🇸',
              ),
              _buildLanguageOption(
                context,
                ref,
                l10n,
                'ar',
                settings.currentLanguage,
                '🇸🇦',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: l10n.dataManagement,
            children: [
              AdaptiveButton(
                text: l10n.clearAllData,
                onPressed: settings.isLoading ? null : () => _showClearDataDialog(context, ref, l10n),
                backgroundColor: Colors.red,
                isLoading: settings.isLoading,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    AppThemeType themeType,
    AppThemeType currentTheme,
    IconData icon,
  ) {
    final isSelected = currentTheme == themeType;
    final title = _getThemeTitle(themeType, l10n);
    
    return _buildOptionTile(
      context: context,
      title: title,
      icon: icon,
      isSelected: isSelected,
      onTap: () => ref.read(settingsControllerProvider.notifier).updateTheme(themeType),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String languageCode,
    String currentLanguage,
    String flag,
  ) {
    final isSelected = currentLanguage == languageCode;
    final title = languageCode == 'en' ? l10n.english : l10n.arabic;
    
    return _buildOptionTile(
      context: context,
      title: '$flag $title',
      icon: Icons.language,
      isSelected: isSelected,
      onTap: () => ref.read(settingsControllerProvider.notifier).updateLanguage(languageCode),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    if (AdaptiveTheme.isIOS) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? CupertinoColors.activeBlue : CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? CupertinoColors.activeBlue : CupertinoColors.separator,
          ),
        ),
        child: CupertinoButton(
          padding: const EdgeInsets.all(16),
          onPressed: onTap,
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? CupertinoColors.white : CupertinoColors.label,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? CupertinoColors.white : CupertinoColors.label,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  CupertinoIcons.check_mark,
                  color: CupertinoColors.white,
                ),
            ],
          ),
        ),
      );
    } else {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        color: isSelected ? Theme.of(context).primaryColor : null,
        child: ListTile(
          leading: Icon(
            icon,
            color: isSelected ? Colors.white : null,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : null,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: isSelected
              ? const Icon(Icons.check, color: Colors.white)
              : null,
          onTap: onTap,
        ),
      );
    }
  }

  String _getThemeTitle(AppThemeType themeType, AppLocalizations l10n) {
    switch (themeType) {
      case AppThemeType.light:
        return l10n.lightTheme;
      case AppThemeType.dark:
        return l10n.darkTheme;
      case AppThemeType.system:
        return l10n.systemTheme;
    }
  }

  void _showClearDataDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    if (AdaptiveTheme.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(l10n.clearDataConfirmation),
          content: Text(l10n.clearDataMessage),
          actions: [
            CupertinoDialogAction(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text(l10n.delete),
              onPressed: () {
                Navigator.pop(context);
                _clearAllData(ref, l10n);
              },
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.clearDataConfirmation),
          content: Text(l10n.clearDataMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _clearAllData(ref, l10n);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.delete),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _clearAllData(WidgetRef ref, AppLocalizations l10n) async {
    final result = await ref.read(settingsControllerProvider.notifier).clearAllData();
    
    if (result.isSuccess) {
      // Show success message
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(
            content: Text(l10n.dataClearedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      // Show error message
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(
            content: Text('${l10n.failedToClearData}: ${result.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
} 