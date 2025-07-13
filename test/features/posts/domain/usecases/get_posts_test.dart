import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod_tmplt/core/domain/entities/post.dart';
import 'package:flutter_riverpod_tmplt/features/posts/domain/repositories/post_repository.dart';
import 'package:flutter_riverpod_tmplt/features/posts/domain/usecases/get_posts.dart';
import 'package:flutter_riverpod_tmplt/core/domain/entities/result.dart';

import 'get_posts_test.mocks.dart';

void main() {
  late GetPosts usecase;
  late MockPostRepository mockRepository;

  setUp(() {
    mockRepository = MockPostRepository();
    usecase = GetPosts(mockRepository as PostRepository);
  });

  const tPosts = [
    Post(id: 1, title: 'Test Post 1', body: 'Test Body 1', userId: 1),
    Post(id: 2, title: 'Test Post 2', body: 'Test Body 2', userId: 1),
  ];

  test('should get posts from repository', () async {
    // arrange
    when(mockRepository.getPosts()).thenAnswer((_) async => Result.success(tPosts));

    // act
    final result = await usecase();

    // assert
    expect(result.isSuccess, true);
    expect(result.data, tPosts);
    verify(mockRepository.getPosts());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    const errorMessage = 'Network error';
    when(mockRepository.getPosts()).thenAnswer((_) async => Result.failure(errorMessage));

    // act
    final result = await usecase();

    // assert
    expect(result.isFailure, true);
    expect(result.errorMessage, errorMessage);
    verify(mockRepository.getPosts());
    verifyNoMoreInteractions(mockRepository);
  });
} 