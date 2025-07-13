import 'package:flutter_riverpod_tmplt/core/domain/entities/post.dart';

class CreatePostState {
  final bool isLoading;
  final String? error;
  final Post? createdPost;
  final bool isSuccess;

  const CreatePostState({
    this.isLoading = false,
    this.error,
    this.createdPost,
    this.isSuccess = false,
  });

  CreatePostState copyWith({
    bool? isLoading,
    String? error,
    Post? createdPost,
    bool? isSuccess,
  }) {
    return CreatePostState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      createdPost: createdPost ?? this.createdPost,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
