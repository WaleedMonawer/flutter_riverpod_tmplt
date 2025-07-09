import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/get_posts.dart';
import '../../domain/usecases/create_post.dart';
import '../../data/datasources/posts_remote_datasource.dart';
import '../../data/datasources/posts_local_datasource.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../../../core/result.dart';
import '../../../../core/logger.dart';
import '../../../../core/providers.dart';

final postsControllerProvider = StateNotifierProvider<PostsController, AsyncValue<Result<List<Post>>>>(
  (ref) => PostsController(ref),
);

class PostsController extends StateNotifier<AsyncValue<Result<List<Post>>>> {
  final Ref ref;
  PostsController(this.ref) : super(const AsyncLoading()) {
    Logger.info('PostsController initialized');
    _loadSavedPosts();
  }

  Future<void> _loadSavedPosts() async {
    try {
      final persistence = ref.read(statePersistenceServiceProvider);
      final savedPosts = await persistence.loadState('posts', (json) {
        final postsList = json['posts'] as List;
        return postsList.map((postJson) => Post.fromJson(postJson)).toList();
      });
      
      if (savedPosts != null && savedPosts.isNotEmpty) {
        state = AsyncData(Result.success(savedPosts));
        Logger.info('Loaded ${savedPosts.length} posts from persistence');
      }
    } catch (e) {
      Logger.warning('Failed to load saved posts: $e');
    }
    
    // Always fetch fresh data
    await getPosts();
  }

  Future<void> _savePosts(List<Post> posts) async {
    try {
      final persistence = ref.read(statePersistenceServiceProvider);
      await persistence.saveState('posts', {
        'posts': posts.map((post) => post.toJson()).toList(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      Logger.info('Saved ${posts.length} posts to persistence');
    } catch (e) {
      Logger.warning('Failed to save posts: $e');
    }
  }

  Future<void> getPosts() async {
    Logger.info('Starting to fetch posts...');
    state = const AsyncLoading();
    try {
      final usecase = ref.read(getPostsUseCaseProvider);
      final result = await usecase();
      
      if (result.isSuccess) {
        await _savePosts(result.data!);
      }
      
      state = AsyncData(result);
      Logger.info('Posts fetched successfully');
    } catch (e, st) {
      Logger.error('Error fetching posts', e, st);
      state = AsyncError(e, st);
    }
  }

  Future<void> refreshPosts() async {
    Logger.info('Refreshing posts...');
    await getPosts();
  }

  Future<Result<Post>> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      Logger.info('Creating new post: $title');
      final usecase = ref.read(createPostUseCaseProvider);
      final result = await usecase(
        title: title,
        body: body,
        userId: userId,
      );
      
      // If successful, refresh the posts list
      if (result.isSuccess) {
        await refreshPosts();
      }
      
      return result;
    } catch (e, st) {
      Logger.error('Error creating post', e, st);
      return Result.failure('Failed to create post: $e');
    }
  }
}

final getPostsUseCaseProvider = Provider<GetPosts>((ref) {
  final repo = ref.read(postRepositoryProvider);
  return GetPosts(repo);
});

final createPostUseCaseProvider = Provider<CreatePost>((ref) {
  final repo = ref.read(postRepositoryProvider);
  return CreatePost(repo);
});

final postRepositoryProvider = Provider((ref) {
  final remote = PostsRemoteDataSourceImpl();
  final local = PostsLocalDataSourceImpl(ref.read(localStorageProvider));
  return PostRepositoryImpl(
    remoteDataSource: remote,
    localDataSource: local,
  );
});




