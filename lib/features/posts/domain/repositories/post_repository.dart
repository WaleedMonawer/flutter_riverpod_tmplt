import '../entities/post.dart';
import 'package:flutter_riverpod_tmplt/core/domain/entities/result.dart';

abstract class PostRepository {
  Future<Result<List<Post>>> getPosts();
  Future<Result<Post>> createPost(Post post);
  Future<Result<Post>> updatePost(Post post);
  Future<Result<void>> deletePost(int id);
  Future<Result<Post>> getPostById(int id);
  Future<Result<List<Post>>> getPostsByUserId(int userId);
  Future<Result<List<Post>>> searchPosts(String query);
} 