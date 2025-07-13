import 'package:dio/dio.dart';
import 'package:flutter_riverpod_tmplt/core/domain/entities/result.dart';
import '../../../features/posts/data/models/post_model.dart';

import '../../logger.dart';
import '../../constants.dart';

abstract class ApiService {
  Future<Result<List<PostModel>>> getPosts();
  Future<Result<PostModel>> getPost(int id);
  Future<Result<PostModel>> createPost(PostModel post);
  Future<Result<PostModel>> updatePost(int id, PostModel post);
  Future<Result<bool>> deletePost(int id);
  Future<Result<List<PostModel>>> getPostsByUserId(int userId);
}

class ApiServiceImpl implements ApiService {
  final Dio _dio;
  static const String _baseUrl = AppConstants.baseUrl;

  ApiServiceImpl({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  @override
  Future<Result<List<PostModel>>> getPosts() async {
    try {
      Logger.info('API: Fetching posts from $_baseUrl/posts');
      final response = await _dio.get('/posts');
      final data = response.data as List;
      final posts = data.map((json) => PostModel.fromJson(json)).toList();
      Logger.info('API: Successfully fetched ${posts.length} posts');
      return Result.success(posts);
    } on DioException catch (e) {
      Logger.error('API: DioException in getPosts', e);
      return _handleDioException(e);
    } catch (e) {
      Logger.error('API: Unexpected error in getPosts', e);
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<PostModel>> getPost(int id) async {
    try {
      Logger.info('API: Fetching post with ID $id');
      final response = await _dio.get('/posts/$id');
      final post = PostModel.fromJson(response.data);
      Logger.info('API: Successfully fetched post $id');
      return Result.success(post);
    } on DioException catch (e) {
      Logger.error('API: DioException in getPost', e);
      return _handleDioException(e);
    } catch (e) {
      Logger.error('API: Unexpected error in getPost', e);
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<PostModel>> createPost(PostModel post) async {
    try {
      Logger.info('API: Creating new post');
      final response = await _dio.post('/posts', data: post.toJson());
      final createdPost = PostModel.fromJson(response.data);
      Logger.info('API: Successfully created post ${createdPost.id}');
      return Result.success(createdPost);
    } on DioException catch (e) {
      Logger.error('API: DioException in createPost', e);
      return _handleDioException(e);
    } catch (e) {
      Logger.error('API: Unexpected error in createPost', e);
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<PostModel>> updatePost(int id, PostModel post) async {
    try {
      Logger.info('API: Updating post $id');
      final response = await _dio.put('/posts/$id', data: post.toJson());
      final updatedPost = PostModel.fromJson(response.data);
      Logger.info('API: Successfully updated post $id');
      return Result.success(updatedPost);
    } on DioException catch (e) {
      Logger.error('API: DioException in updatePost', e);
      return _handleDioException(e);
    } catch (e) {
      Logger.error('API: Unexpected error in updatePost', e);
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<bool>> deletePost(int id) async {
    try {
      Logger.info('API: Deleting post $id');
      await _dio.delete('/posts/$id');
      Logger.info('API: Successfully deleted post $id');
      return const Result.success(true);
    } on DioException catch (e) {
      Logger.error('API: DioException in deletePost', e);
      return _handleDioException(e);
    } catch (e) {
      Logger.error('API: Unexpected error in deletePost', e);
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<List<PostModel>>> getPostsByUserId(int userId) async {
    try {
      Logger.info('API: Fetching posts for user $userId');
      final response = await _dio.get('/posts', queryParameters: {'userId': userId});
      final data = response.data as List;
      final posts = data.map((json) => PostModel.fromJson(json)).toList();
      Logger.info('API: Successfully fetched ${posts.length} posts for user $userId');
      return Result.success(posts);
    } on DioException catch (e) {
      Logger.error('API: DioException in getPostsByUserId', e);
      return _handleDioException(e);
    } catch (e) {
      Logger.error('API: Unexpected error in getPostsByUserId', e);
      return Result.failure('Unexpected error: $e');
    }
  }

  Result<T> _handleDioException<T>(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const Result.failure('Connection timeout. Please check your internet connection.');
    } else if (e.response?.statusCode == 404) {
      return const Result.failure('Resource not found.');
    } else if (e.response?.statusCode == 500) {
      return const Result.failure('Server error. Please try again later.');
    } else if (e.response?.statusCode == 401) {
      return const Result.failure('Unauthorized. Please check your credentials.');
    } else if (e.response?.statusCode == 403) {
      return const Result.failure('Forbidden. You don\'t have permission to access this resource.');
    } else {
      return Result.failure('Network error: ${e.message}');
    }
  }
} 