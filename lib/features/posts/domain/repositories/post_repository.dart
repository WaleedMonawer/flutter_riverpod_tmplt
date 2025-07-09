import '../entities/post.dart';
import '../../../../core/result.dart';

abstract class PostRepository {
  Future<Result<List<Post>>> getPosts();
  Future<Result<Post>> createPost(Post post);
} 