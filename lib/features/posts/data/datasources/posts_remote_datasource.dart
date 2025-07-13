import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_tmplt/core/data/models/post_model.dart';
import 'package:flutter_riverpod_tmplt/core/data/datasources/remote/api_service.dart';
import 'package:flutter_riverpod_tmplt/core/providers/api_providers.dart';
import 'package:flutter_riverpod_tmplt/core/domain/entities/result.dart';
import 'package:flutter_riverpod_tmplt/core/common/utils/logger.dart';

abstract class PostsRemoteDataSource {
  Future<Result<List<PostModel>>> getPosts();
  Future<Result<PostModel>> createPost(PostModel post);
  Future<Result<PostModel>> updatePost(PostModel post);
  Future<Result<void>> deletePost(int id);
  Future<Result<PostModel>> getPostById(int id);
  Future<Result<List<PostModel>>> getPostsByUserId(int userId);
  Future<Result<List<PostModel>>> searchPosts(String query);
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final ApiService _apiService;
  
  PostsRemoteDataSourceImpl({ApiService? apiService}) 
      : _apiService = apiService ?? ApiServiceImpl();

  // Factory constructor for Riverpod
  factory PostsRemoteDataSourceImpl.fromRef(Ref ref) {
    final apiService = ref.read(apiServiceProvider);
    return PostsRemoteDataSourceImpl(apiService: apiService);
  }

  @override
  Future<Result<List<PostModel>>> getPosts() async {
    Logger.info('RemoteDataSource: Fetching posts from API service');
    return await _apiService.getPosts();
  }

  @override
  Future<Result<PostModel>> createPost(PostModel post) async {
    Logger.info('RemoteDataSource: Creating post via API service');
    return await _apiService.createPost(post);
  }

  @override
  Future<Result<PostModel>> updatePost(PostModel post) async {
    Logger.info('RemoteDataSource: Updating post via API service');
    return await _apiService.updatePost(post.id, post);
  }

  @override
  Future<Result<void>> deletePost(int id) async {
    Logger.info('RemoteDataSource: Deleting post via API service');
    final result = await _apiService.deletePost(id);
    return result.when(
      success: (_) => Result.success(null),
      failure: (error) => Result.failure(error),
    );
  }

  @override
  Future<Result<PostModel>> getPostById(int id) async {
    Logger.info('RemoteDataSource: Getting post by ID via API service');
    return await _apiService.getPost(id);
  }

  @override
  Future<Result<List<PostModel>>> getPostsByUserId(int userId) async {
    Logger.info('RemoteDataSource: Getting posts by user ID via API service');
    return await _apiService.getPostsByUserId(userId);
  }

  @override
  Future<Result<List<PostModel>>> searchPosts(String query) async {
    Logger.info('RemoteDataSource: Searching posts via API service');
    // For now, return empty list since search is not implemented in API service
    // This can be implemented later when the API supports search
    return Result.success([]);
  }
} 