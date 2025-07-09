import '../entities/post.dart';
import '../repositories/post_repository.dart';
import '../../../../core/result.dart';

class CreatePost {
  final PostRepository repository;
  CreatePost(this.repository);

  Future<Result<Post>> call({
    required String title,
    required String body,
    required int userId,
  }) async {
    final post = Post(
      id: 0, // سيتم تعيينه من الخادم
      title: title,
      body: body,
      userId: userId,
    );
    return await repository.createPost(post);
  }
} 