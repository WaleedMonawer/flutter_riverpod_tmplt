import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_tmplt/features/posts/presentation/controllers/create_post_state.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/create_post.dart';
import '../../../../core/result.dart';
import '../../../../core/logger.dart';
import '../../posts_provider.dart';

// Provider for CreatePostController
final createPostControllerProvider = StateNotifierProvider<CreatePostController, CreatePostState>(
  (ref) => CreatePostController(ref),
);

class CreatePostController extends StateNotifier<CreatePostState> {
  final Ref ref;

  CreatePostController(this.ref) : super(const CreatePostState());

  /// إنشاء منشور جديد
  Future<void> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      Logger.info('Creating new post: $title');
      
      // تحديث الحالة إلى التحميل
      state = state.copyWith(isLoading: true, error: null, isSuccess: false);
      
      // استدعاء UseCase
      final usecase = ref.read(createPostUseCaseProvider);
      final result = await usecase(
        title: title,
        body: body,
        userId: userId,
      );
      
      // معالجة النتيجة
      result.when(
        success: (post) {
          Logger.info('Post created successfully with ID: ${post.id}');
          state = state.copyWith(
            isLoading: false,
            createdPost: post,
            isSuccess: true,
            error: null,
          );
        },
        failure: (error) {
          Logger.error('Failed to create post: $error');
          state = state.copyWith(
            isLoading: false,
            error: error,
            isSuccess: false,
          );
        },
      );
    } catch (e, stackTrace) {
      Logger.error('Unexpected error creating post', e, stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: 'حدث خطأ غير متوقع: $e',
        isSuccess: false,
      );
    }
  }

  /// إعادة تعيين الحالة
  void reset() {
    state = const CreatePostState();
  }

  /// مسح الخطأ
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// مسح النجاح
  void clearSuccess() {
    state = state.copyWith(isSuccess: false, createdPost: null);
  }
} 