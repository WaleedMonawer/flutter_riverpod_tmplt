import 'package:flutter_riverpod_tmplt/core/domain/entities/post.dart';
import 'package:flutter_riverpod_tmplt/features/posts/domain/repositories/post_repository.dart';
import 'package:flutter_riverpod_tmplt/core/domain/entities/result.dart';

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