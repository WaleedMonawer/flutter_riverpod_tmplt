import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/posts_remote_datasource.dart';
import '../datasources/posts_local_datasource.dart';
import '../models/post_model.dart';
import '../../../../core/result.dart';
import '../../../../core/logger.dart';

class PostRepositoryImpl implements PostRepository {
  final PostsRemoteDataSource remoteDataSource;
  final PostsLocalDataSource localDataSource;
  
  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<List<Post>>> getPosts() async {
    try {
      // First, try to get from cache
      Logger.info('Attempting to get posts from cache first...');
      final cachedResult = await localDataSource.getPosts();
      
      return await cachedResult.when(
        success: (cachedPosts) async {
          if (cachedPosts.isNotEmpty) {
            Logger.info('Returning ${cachedPosts.length} posts from cache');
            return Result.success(cachedPosts.map((e) => e.toEntity()).toList());
          }
          
          // If cache is empty, fetch from remote
          Logger.info('Cache is empty, fetching from remote...');
          final remoteResult = await remoteDataSource.getPosts();
          
          return await remoteResult.when(
            success: (remotePosts) async {
              // Cache the remote posts
              await localDataSource.cachePosts(remotePosts);
              Logger.info('Cached ${remotePosts.length} posts from remote');
              return Result.success(remotePosts.map((e) => e.toEntity()).toList());
            },
            failure: (message) {
              Logger.error('Failed to fetch posts from remote: $message');
              return Result.failure(message);
            },
          );
        },
        failure: (message) async {
          Logger.error('Failed to get posts from cache: $message');
          // If cache fails, try remote
          final remoteResult = await remoteDataSource.getPosts();
          return remoteResult.when(
            success: (remotePosts) async {
              // Try to cache the remote posts
              await localDataSource.cachePosts(remotePosts);
              return Result.success(remotePosts.map((e) => e.toEntity()).toList());
            },
            failure: (remoteMessage) {
              return Result.failure('Cache: $message, Remote: $remoteMessage');
            },
          );
        },
      );
    } catch (e) {
      Logger.error('Unexpected error in repository', e);
      return Result.failure('Repository error: $e');
    }
  }

  @override
  Future<Result<Post>> createPost(Post post) async {
    try {
      Logger.info('Creating new post: ${post.title}');
      
      // Convert entity to model
      final postModel = PostModel(
        id: post.id,
        title: post.title,
        body: post.body,
        userId: post.userId,
      );
      
      // Create post via remote data source
      final remoteResult = await remoteDataSource.createPost(postModel);
      
      return remoteResult.when(
        success: (createdPostModel) {
          Logger.info('Successfully created post with ID: ${createdPostModel.id}');
          return Result.success(createdPostModel.toEntity());
        },
        failure: (message) {
          Logger.error('Failed to create post: $message');
          return Result.failure(message);
        },
      );
    } catch (e) {
      Logger.error('Unexpected error creating post', e);
      return Result.failure('Repository error: $e');
    }
  }
} 