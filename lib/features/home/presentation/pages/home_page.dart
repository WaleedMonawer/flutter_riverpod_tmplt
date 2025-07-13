// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod_tmplt/core/presentation/theme/theme_controller.dart';
import 'package:flutter_riverpod_tmplt/core/presentation/theme/app_theme.dart';
import 'package:flutter_riverpod_tmplt/core/presentation/theme/adaptive_theme.dart';
import 'package:flutter_riverpod_tmplt/core/providers/local_providers.dart';
import 'package:flutter_riverpod_tmplt/core/presentation/navigation/app_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeControllerProvider);
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          // Language Toggle Button
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              ref.read(localeProvider.notifier).toggleLocale();
            },
            tooltip: l10n.language,
          ),
          // Theme Toggle Button
          IconButton(
            icon: Icon(
              currentTheme == AppThemeType.light ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () {
              ref.read(themeControllerProvider.notifier).toggleTheme();
            },
            tooltip: l10n.themeSettings,
          ),
          // Settings Button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              NavigationService.goToSettings(context);
            },
            tooltip: l10n.settings,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(context, l10n),
            const SizedBox(height: 24),
            
            // Navigation Grid
            Expanded(
              child: _buildNavigationGrid(context, l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.home,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.welcomeMessage,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.chooseScreenMessage,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationGrid(BuildContext context, AppLocalizations l10n) {
    final navigationItems = [
      NavigationItem(
        title: l10n.posts,
        subtitle: l10n.postsManagement,
        icon: Icons.article,
        color: Colors.blue,
        onTap: () => NavigationService.goToPosts(context),
      ),
      NavigationItem(
        title: l10n.counter,
        subtitle: l10n.counterExample,
        icon: Icons.calculate,
        color: Colors.green,
        onTap: () => NavigationService.goToCounter(context),
      ),
      NavigationItem(
        title: l10n.profile,
        subtitle: l10n.profileManagement,
        icon: Icons.person,
        color: Colors.orange,
        onTap: () => NavigationService.goToProfile(context),
      ),
      NavigationItem(
        title: l10n.todos,
        subtitle: l10n.todoManagement,
        icon: Icons.check_circle,
        color: Colors.purple,
        onTap: () => NavigationService.goToTodos(context),
      ),
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: navigationItems.length,
      itemBuilder: (context, index) {
        final item = navigationItems[index];
        return _buildNavigationCard(context, item);
      },
    );
  }

  Widget _buildNavigationCard(BuildContext context, NavigationItem item) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                item.color.withOpacity(0.1),
                item.color.withOpacity(0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item.icon,
                    size: 32,
                    color: item.color,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: item.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NavigationItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  NavigationItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
} 