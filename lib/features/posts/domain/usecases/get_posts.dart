import 'package:flutter_riverpod_tmplt/core/domain/entities/post.dart';
import 'package:flutter_riverpod_tmplt/features/posts/domain/repositories/post_repository.dart';
import 'package:flutter_riverpod_tmplt/core/domain/entities/result.dart';

class GetPosts {
  final PostRepository repository;
  GetPosts(this.repository);

  Future<Result<List<Post>>> call() async {
    return await repository.getPosts();
  }
} 