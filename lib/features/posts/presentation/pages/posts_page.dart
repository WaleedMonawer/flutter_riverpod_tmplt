import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod_tmplt/core/domain/entities/result.dart';
import 'package:flutter_riverpod_tmplt/core/presentation/widgets/common/loading_widget.dart';
import 'package:flutter_riverpod_tmplt/core/presentation/widgets/common/error_widget.dart';
import 'package:flutter_riverpod_tmplt/core/presentation/widgets/adaptive/adaptive_scaffold.dart';
import 'package:flutter_riverpod_tmplt/core/presentation/theme/adaptive_theme.dart';
import 'package:flutter_riverpod_tmplt/core/providers/local_providers.dart';
import 'package:flutter_riverpod_tmplt/features/posts/presentation/controllers/posts_controller.dart';
import 'create_post_page.dart';

class PostsPage extends ConsumerWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsState = ref.watch(postsControllerProvider);
    final l10n = AppLocalizations.of(context)!;
    
    return AdaptiveScaffold(
      title: l10n.posts,
      actions: [
        // Refresh Button
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => ref.read(postsControllerProvider.notifier).refreshPosts(),
          tooltip: l10n.refresh,
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