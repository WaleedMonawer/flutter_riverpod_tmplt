import 'package:dio/dio.dart';
import 'package:flutter_riverpod_tmplt/core/common/constants/app_constants.dart';
import 'package:flutter_riverpod_tmplt/core/common/utils/logger.dart';
import 'package:flutter_riverpod_tmplt/core/data/datasources/remote/http_client.dart';
import 'package:flutter_riverpod_tmplt/core/data/models/post_model.dart';
import 'package:flutter_riverpod_tmplt/core/domain/entities/result.dart';


abstract class ApiService {
  Future<Result<List<PostModel>>> getPosts();
  Future<Result<PostModel>> getPost(int id);
  Future<Result<PostModel>> createPost(PostModel post);
  Future<Result<PostModel>> updatePost(int id, PostModel post);
  Future<Result<bool>> deletePost(int id);
  Future<Result<List<PostModel>>> getPostsByUserId(int userId);
}

class ApiServiceImpl implements ApiService {
  final HttpClient _dio;
  static const String _baseUrl = AppConstants.baseUrl;

  ApiServiceImpl({HttpClient? apiClient}) : _dio = apiClient ?? HttpClient(
    baseUrl: _baseUrl,
    timeout: const Duration(seconds: 10),
    
  );

  @override
  Future<Result<List<PostModel>>> getPosts() async {
    try {
      Logger.info('API: Fetching posts from $_baseUrl/posts');
      final response = await _dio.get<List<PostModel>>('/posts',fromJson: (json) => (json as List).map((e) => PostModel.fromJson(e as Map<String, dynamic>)).toList());
      if (response.isSuccess  && response.data != null) {
        final posts = response.data ;
        Logger.info('API: Successfully fetched ${posts?.length} posts');
        return Result.success(posts??[]);
      } else {
        Logger.error('API: Failed to fetch posts with status ${response.statusCode}');
        return Result.failure(response.errors?.values.first.toString()??'Failed to fetch posts');
      }
      
      
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
      final response = await _dio.post<PostModel>('/posts', data: post.toJson(),fromJson: (json) => PostModel.fromJson(json as Map<String, dynamic>));
      if (response.isSuccess  && response.data != null) {
        final createdPost = response.data;
        Logger.info('API: Successfully created post ${createdPost?.id}');
        return Result.success(createdPost??PostModel(id: 0, title: '', body: '', userId: 0));
      } else {
        Logger.error('API: Failed to create post with status ${response.statusCode}');
        return Result.failure(response.errors?.toString()??'Failed to create post');
      }
      
      
      
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
      return Result.success(true);
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
      return Result.failure('Connection timeout. Please check your internet connection.');
    } else if (e.response?.statusCode == 404) {
      return Result.failure('Resource not found.');
    } else if (e.response?.statusCode == 500) {
      return Result.failure('Server error. Please try again later.');
    } else if (e.response?.statusCode == 401) {
      return Result.failure('Unauthorized. Please check your credentials.');
    } else if (e.response?.statusCode == 403) {
      return Result.failure('Forbidden. You don\'t have permission to access this resource.');
    } else {
      return Result.failure('Network error: ${e.message}');
    }
  }
} 