import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../controllers/posts_controller.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/adaptive_scaffold.dart';
import '../../../../core/result.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/adaptive_theme.dart';
import '../../../../core/providers.dart';
import 'create_post_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class PostsPage extends ConsumerWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsState = ref.watch(postsControllerProvider);
    final currentTheme = ref.watch(themeControllerProvider);
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;
    
    return AdaptiveScaffold(
      title: l10n.posts,
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
                  // Refresh Button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(postsControllerProvider.notifier).refreshPosts(),
            tooltip: l10n.refresh,
          ),
          // Settings Button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
            tooltip: l10n.settings,
          ),
      ],
      body: postsState.when(
        data: (result) => result.when(
          success: (posts) => posts.isEmpty
              ? Center(child: Text(l10n.noPosts))
              : RefreshIndicator(
                  onRefresh: () => ref.read(postsControllerProvider.notifier).refreshPosts(),
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return _buildPostCard(context, post);
                    },
                  ),
                ),
          failure: (message) => CustomErrorWidget(
            message: message,
            onRetry: () => ref.read(postsControllerProvider.notifier).refreshPosts(),
          ),
        ),
        loading: () => LoadingWidget(message: l10n.loading),
        error: (error, stack) => CustomErrorWidget(
          message: '${l10n.error}: $error',
          onRetry: () => ref.read(postsControllerProvider.notifier).refreshPosts(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePostPage(),
            ),
          );
          
          // If post was created successfully, refresh the list
          if (result == true) {
            ref.read(postsControllerProvider.notifier).refreshPosts();
          }
        },
        tooltip: l10n.createNewPost,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, post) {
    final l10n = AppLocalizations.of(context)!;
    if (AdaptiveTheme.isIOS) {
      return Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                post.body,
                style: const TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.secondaryLabel,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                '${l10n.post} ID: ${post.id}',
                style: const TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.tertiaryLabel,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Card(
        margin: const EdgeInsets.all(8),
        child: ListTile(
          title: Text(
            post.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            post.body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            '${l10n.post} ID: ${post.id}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      );
    }
  }
} 