import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_model.dart';
import '../../../../core/api/api_service.dart';
import '../../../../core/api/api_providers.dart';
import '../../../../core/result.dart';
import '../../../../core/logger.dart';

abstract class PostsRemoteDataSource {
  Future<Result<List<PostModel>>> getPosts();
  Future<Result<PostModel>> createPost(PostModel post);
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
} 