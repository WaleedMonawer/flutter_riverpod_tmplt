import 'package:flutter_riverpod_tmplt/core/common/utils/logger.dart';
import 'package:flutter_riverpod_tmplt/core/domain/entities/result.dart';
import 'package:flutter_riverpod_tmplt/core/domain/entities/post.dart';
import 'package:flutter_riverpod_tmplt/core/data/models/post_model.dart';
import 'package:flutter_riverpod_tmplt/features/posts/domain/repositories/post_repository.dart';
import 'package:flutter_riverpod_tmplt/features/posts/data/datasources/posts_remote_datasource.dart';
import 'package:flutter_riverpod_tmplt/features/posts/data/datasources/posts_local_datasource.dart';

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

  @override
  Future<Result<Post>> updatePost(Post post) async {
    try {
      Logger.info('Updating post: ${post.id}');
      
      final postModel = PostModel(
        id: post.id,
        title: post.title,
        body: post.body,
        userId: post.userId,
      );
      
      final remoteResult = await remoteDataSource.updatePost(postModel);
      
      return remoteResult.when(
        success: (updatedPostModel) {
          Logger.info('Successfully updated post with ID: ${updatedPostModel.id}');
          return Result.success(updatedPostModel.toEntity());
        },
        failure: (message) {
          Logger.error('Failed to update post: $message');
          return Result.failure(message);
        },
      );
    } catch (e) {
      Logger.error('Unexpected error updating post', e);
      return Result.failure('Repository error: $e');
    }
  }

  @override
  Future<Result<void>> deletePost(int id) async {
    try {
      Logger.info('Deleting post: $id');
      
      final remoteResult = await remoteDataSource.deletePost(id);
      
      return remoteResult.when(
        success: (_) {
          Logger.info('Successfully deleted post with ID: $id');
          return Result.success(null);
        },
        failure: (message) {
          Logger.error('Failed to delete post: $message');
          return Result.failure(message);
        },
      );
    } catch (e) {
      Logger.error('Unexpected error deleting post', e);
      return Result.failure('Repository error: $e');
    }
  }

  @override
  Future<Result<Post>> getPostById(int id) async {
    try {
      Logger.info('Getting post by ID: $id');
      
      final remoteResult = await remoteDataSource.getPostById(id);
      
      return remoteResult.when(
        success: (postModel) {
          Logger.info('Successfully retrieved post with ID: ${postModel.id}');
          return Result.success(postModel.toEntity());
        },
        failure: (message) {
          Logger.error('Failed to get post by ID: $message');
          return Result.failure(message);
        },
      );
    } catch (e) {
      Logger.error('Unexpected error getting post by ID', e);
      return Result.failure('Repository error: $e');
    }
  }

  @override
  Future<Result<List<Post>>> getPostsByUserId(int userId) async {
    try {
      Logger.info('Getting posts by user ID: $userId');
      
      final remoteResult = await remoteDataSource.getPostsByUserId(userId);
      
      return remoteResult.when(
        success: (postModels) {
          Logger.info('Successfully retrieved ${postModels.length} posts for user: $userId');
          return Result.success(postModels.map((e) => e.toEntity()).toList());
        },
        failure: (message) {
          Logger.error('Failed to get posts by user ID: $message');
          return Result.failure(message);
        },
      );
    } catch (e) {
      Logger.error('Unexpected error getting posts by user ID', e);
      return Result.failure('Repository error: $e');
    }
  }

  @override
  Future<Result<List<Post>>> searchPosts(String query) async {
    try {
      Logger.info('Searching posts with query: $query');
      
      final remoteResult = await remoteDataSource.searchPosts(query);
      
      return remoteResult.when(
        success: (postModels) {
          Logger.info('Successfully found ${postModels.length} posts for query: $query');
          return Result.success(postModels.map((e) => e.toEntity()).toList());
        },
        failure: (message) {
          Logger.error('Failed to search posts: $message');
          return Result.failure(message);
        },
      );
    } catch (e) {
      Logger.error('Unexpected error searching posts', e);
      return Result.failure('Repository error: $e');
    }
  }
} 