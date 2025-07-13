import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_tmplt/core/providers/api_providers.dart';
import 'package:flutter_riverpod_tmplt/core/domain/entities/result.dart';
import 'package:flutter_riverpod_tmplt/core/providers/local_providers.dart';
import 'package:flutter_riverpod_tmplt/features/posts/data/datasources/posts_local_datasource.dart';
  import 'package:flutter_riverpod_tmplt/core/domain/entities/post.dart';
  import 'package:flutter_riverpod_tmplt/features/posts/data/datasources/posts_remote_datasource.dart';
import 'package:flutter_riverpod_tmplt/features/posts/data/repositories/post_repository_impl.dart';
import 'package:flutter_riverpod_tmplt/features/posts/domain/repositories/post_repository.dart';
import 'package:flutter_riverpod_tmplt/features/posts/domain/usecases/get_posts.dart';
import 'package:flutter_riverpod_tmplt/features/posts/domain/usecases/create_post.dart';
import 'package:flutter_riverpod_tmplt/features/posts/presentation/controllers/posts_controller.dart';

final postRemoteDSProvider = Provider((ref) => PostsRemoteDataSourceImpl(apiService: ref.read(apiServiceProvider)));
final postLocalDSProvider = Provider((ref) => PostsLocalDataSourceImpl(ref.read(localStorageProvider)));
final postRepoProvider = Provider((ref) => PostRepositoryImpl(remoteDataSource: ref.read(postRemoteDSProvider), localDataSource: ref.read(postLocalDSProvider)));
final getPostsProvider = Provider((ref) => GetPosts(ref.read(postRepoProvider)));

final postsControllerProvider = StateNotifierProvider<PostsController, AsyncValue<Result<List<Post>>>>(
  (ref) => PostsController(ref),
);

final getPostsUseCaseProvider = Provider<GetPosts>((ref) {
  final repo = ref.read(postRepositoryProvider);
  return GetPosts(repo);
});

final createPostUseCaseProvider = Provider<CreatePost>((ref) {
  final repo = ref.read(postRepositoryProvider);
  return CreatePost(repo);
});

final postRepositoryProvider = Provider<PostRepository>((ref) {
  final remote = PostsRemoteDataSourceImpl(apiService: ref.read(apiServiceProvider));
  final local = PostsLocalDataSourceImpl(ref.read(localStorageProvider));
  return PostRepositoryImpl(
    remoteDataSource: remote,
    localDataSource: local,
  );
});


