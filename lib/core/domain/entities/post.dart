import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
abstract class Post with _$Post {
  const factory Post({
    required int id,
    required String title,
    required String body,
    required int userId,
    String? authorName,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(false) bool isPublished,
    @Default(0) int viewCount,
    @Default(0) int likeCount,
    @Default(0) int commentCount,
    List<String>? tags,
    String? imageUrl,
    @Default(PostStatus.draft) PostStatus status,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}

enum PostStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('published')
  published,
  @JsonValue('archived')
  archived,
  @JsonValue('deleted')
  deleted,
}

extension PostExtensions on Post {
  /// التحقق من أن المنشور منشور ومتاح للعرض
  bool get isPublic => status == PostStatus.published && isPublished;
  
  /// التحقق من أن المنشور يمكن تعديله
  bool get isEditable => status != PostStatus.deleted;
  
  /// الحصول على ملخص المنشور
  String get summary {
    if (body.length <= 100) return body;
    return '${body.substring(0, 100)}...';
  }
  
  /// التحقق من أن المنشور يحتوي على صورة
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  
  /// الحصول على عدد الكلمات في المنشور
  int get wordCount => body.split(' ').length;
  
  /// التحقق من أن المنشور طويل
  bool get isLongPost => wordCount > 500;
  
  /// الحصول على وقت القراءة التقريبي (بالدقائق)
  int get estimatedReadingTime => (wordCount / 200).ceil(); // 200 كلمة في الدقيقة
} 