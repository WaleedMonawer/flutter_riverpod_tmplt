import 'dart:convert';
import '../models/post_model.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/result.dart';
import '../../../../core/logger.dart';

abstract class PostsLocalDataSource {
  Future<Result<List<PostModel>>> getPosts();
  Future<Result<bool>> cachePosts(List<PostModel> posts);
  Future<Result<bool>> clearCache();
}

class PostsLocalDataSourceImpl implements PostsLocalDataSource {
  final LocalStorage storage;
  static const String _postsKey = 'cached_posts';
  
  PostsLocalDataSourceImpl(this.storage);

  @override
  Future<Result<List<PostModel>>> getPosts() async {
    try {
      Logger.info('Fetching posts from local storage...');
      final result = await storage.get<String>(_postsKey);
      
      return result.when(
        success: (jsonString) {
          if (jsonString == null) {
            Logger.info('No cached posts found');
            return const Result.success([]);
          }
          
          final List<dynamic> jsonList = jsonDecode(jsonString);
          final posts = jsonList.map((json) => PostModel.fromJson(json)).toList();
          Logger.info('Successfully loaded ${posts.length} posts from cache');
          return Result.success(posts);
        },
        failure: (message) {
          Logger.error('Failed to load posts from cache: $message');
          return Result.failure(message);
        },
      );
    } catch (e) {
      Logger.error('Error loading posts from cache', e);
      return Result.failure('Failed to load cached posts: $e');
    }
  }

  @override
  Future<Result<bool>> cachePosts(List<PostModel> posts) async {
    try {
      Logger.info('Caching ${posts.length} posts...');
      final jsonList = posts.map((post) => post.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      
      final result = await storage.set(_postsKey, jsonString);
      return result.when(
        success: (success) {
          Logger.info('Posts cached successfully');
          return Result.success(success);
        },
        failure: (message) {
          Logger.error('Failed to cache posts: $message');
          return Result.failure(message);
        },
      );
    } catch (e) {
      Logger.error('Error caching posts', e);
      return Result.failure('Failed to cache posts: $e');
    }
  }

  @override
  Future<Result<bool>> clearCache() async {
    try {
      Logger.info('Clearing posts cache...');
      final result = await storage.remove(_postsKey);
      return result.when(
        success: (success) {
          Logger.info('Posts cache cleared successfully');
          return Result.success(success);
        },
        failure: (message) {
          Logger.error('Failed to clear posts cache: $message');
          return Result.failure(message);
        },
      );
    } catch (e) {
      Logger.error('Error clearing posts cache', e);
      return Result.failure('Failed to clear posts cache: $e');
    }
  }
} 