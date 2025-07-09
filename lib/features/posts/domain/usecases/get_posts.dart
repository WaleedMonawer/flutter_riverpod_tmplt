import '../entities/post.dart';
import '../repositories/post_repository.dart';
import '../../../../core/result.dart';

class GetPosts {
  final PostRepository repository;
  GetPosts(this.repository);

  Future<Result<List<Post>>> call() async {
    return await repository.getPosts();
  }
} 