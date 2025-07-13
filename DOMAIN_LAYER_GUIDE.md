# 🏗️ دليل Domain Layer الشامل

## 📋 نظرة عامة

تم إنشاء Domain Layer متقدم وشامل يتبع مبادئ Domain-Driven Design (DDD) و Clean Architecture. هذا الطبقة تحتوي على منطق الأعمال الأساسي والمستقل عن أي تقنيات خارجية.

## 🏛️ هيكل Domain Layer

```
lib/features/posts/domain/
├── entities/                    # الكيانات الأساسية
│   ├── post.dart               # كيان المنشور
│   ├── user.dart               # كيان المستخدم
│   ├── comment.dart            # كيان التعليق
│   └── value_objects.dart      # كيانات القيم
├── repositories/               # واجهات المستودعات
│   └── post_repository.dart    # واجهة مستودع المنشورات
├── usecases/                   # حالات الاستخدام
│   ├── get_posts.dart          # جلب المنشورات
│   ├── create_post.dart        # إنشاء منشور
│   ├── update_post.dart        # تحديث منشور
│   ├── delete_post.dart        # حذف منشور
│   ├── get_post_by_id.dart     # جلب منشور بواسطة المعرف
│   └── search_posts.dart       # البحث في المنشورات
├── services/                   # خدمات Domain
│   └── post_validation_service.dart  # خدمة التحقق من الصحة
├── events/                     # أحداث Domain
│   └── post_events.dart        # أحداث المنشورات
└── exceptions/                 # استثناءات Domain
    └── post_exceptions.dart    # استثناءات المنشورات
```

## 🎯 الكيانات (Entities)

### 📝 كيان المنشور (Post)
```dart
@freezed
class Post with _$Post {
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
}
```

#### 🏷️ حالات المنشور
```dart
enum PostStatus {
  draft,      // مسودة
  published,  // منشور
  archived,   // مؤرشف
  deleted,    // محذوف
}
```

#### 🔧 Extensions المفيدة
```dart
extension PostExtensions on Post {
  bool get isPublic => status == PostStatus.published && isPublished;
  bool get isEditable => status != PostStatus.deleted;
  String get summary => body.length <= 100 ? body : '${body.substring(0, 100)}...';
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  int get wordCount => body.split(' ').length;
  bool get isLongPost => wordCount > 500;
  int get estimatedReadingTime => (wordCount / 200).ceil();
}
```

### 👤 كيان المستخدم (User)
```dart
@freezed
class User with _$User {
  const factory User({
    required int id,
    required String name,
    required String email,
    String? username,
    String? avatarUrl,
    String? bio,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    @Default(false) bool isVerified,
    @Default(UserRole.user) UserRole role,
    @Default(0) int postCount,
    @Default(0) int followerCount,
    @Default(0) int followingCount,
    @Default(UserStatus.active) UserStatus status,
  }) = _User;
}
```

#### 🎭 أدوار المستخدم
```dart
enum UserRole {
  admin,      // مدير
  moderator,  // مشرف
  user,       // مستخدم عادي
  guest,      // ضيف
}
```

#### 📊 حالات المستخدم
```dart
enum UserStatus {
  active,     // نشط
  inactive,   // غير نشط
  suspended,  // معلق
  banned,     // محظور
}
```

### 💬 كيان التعليق (Comment)
```dart
class Comment {
  final int id;
  final String content;
  final int postId;
  final int userId;
  final String? authorName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? parentId; // للردود المتداخلة
  final int likeCount;
  final bool isEdited;
  final bool isDeleted;
}
```

## 💎 كيانات القيم (Value Objects)

### 🔑 المعرف الفريد
```dart
class UniqueId {
  final String value;
  const UniqueId(this.value);
}
```

### 📝 عنوان المنشور
```dart
class PostTitle {
  final String value;
  
  PostTitle(this.value) : assert(value.isNotEmpty, 'العنوان لا يمكن أن يكون فارغاً');
  
  bool get isValid => value.length >= 3 && value.length <= 200;
  String? get errorMessage {
    if (value.isEmpty) return 'العنوان مطلوب';
    if (value.length < 3) return 'العنوان يجب أن يكون 3 أحرف على الأقل';
    if (value.length > 200) return 'العنوان يجب أن يكون أقل من 200 حرف';
    return null;
  }
}
```

### 📄 محتوى المنشور
```dart
class PostContent {
  final String value;
  
  PostContent(this.value) : assert(value.isNotEmpty, 'المحتوى لا يمكن أن يكون فارغاً');
  
  bool get isValid => value.length >= 10 && value.length <= 10000;
  int get wordCount => value.split(' ').length;
  int get estimatedReadingTime => (wordCount / 200).ceil();
}
```

### 📧 البريد الإلكتروني
```dart
class Email {
  final String value;
  
  bool get isValid {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }
}
```

### 🔒 كلمة المرور
```dart
class Password {
  final String value;
  
  bool get isStrong {
    return value.length >= 8 && 
           RegExp(r'[A-Z]').hasMatch(value) && 
           RegExp(r'[a-z]').hasMatch(value) && 
           RegExp(r'[0-9]').hasMatch(value);
  }
}
```

## 🔄 حالات الاستخدام (Use Cases)

### 📋 جلب المنشورات
```dart
class GetPosts {
  final PostRepository repository;
  
  GetPosts(this.repository);
  
  Future<Result<List<Post>>> call() async {
    try {
      return await repository.getPosts();
    } catch (e) {
      return Result.failure('فشل في جلب المنشورات: $e');
    }
  }
}
```

### ➕ إنشاء منشور
```dart
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
```

### ✏️ تحديث منشور
```dart
class UpdatePost {
  final PostRepository repository;
  
  Future<Result<Post>> call({
    required int postId,
    required String title,
    required String body,
    int? userId,
    bool? isPublished,
    List<String>? tags,
    String? imageUrl,
  }) async {
    // التحقق من صحة البيانات
    if (title.trim().isEmpty) {
      return Result.failure('العنوان مطلوب');
    }
    
    final updatedPost = Post(
      id: postId,
      title: title.trim(),
      body: body.trim(),
      userId: userId ?? 0,
      isPublished: isPublished ?? false,
      tags: tags,
      imageUrl: imageUrl,
      updatedAt: DateTime.now(),
    );
    
    return await repository.updatePost(updatedPost);
  }
}
```

### 🗑️ حذف منشور
```dart
class DeletePost {
  final PostRepository repository;
  
  Future<Result<void>> call(int postId) async {
    if (postId <= 0) {
      return Result.failure('معرف المنشور غير صحيح');
    }
    
    return await repository.deletePost(postId);
  }
}
```

### 🔍 البحث في المنشورات
```dart
class SearchPosts {
  final PostRepository repository;
  
  Future<Result<List<Post>>> call(String query) async {
    if (query.trim().isEmpty) {
      return Result.failure('استعلام البحث مطلوب');
    }
    
    if (query.trim().length < 2) {
      return Result.failure('استعلام البحث يجب أن يكون حرفين على الأقل');
    }
    
    return await repository.searchPosts(query.trim());
  }
}
```

## 🔧 خدمات Domain

### ✅ خدمة التحقق من الصحة
```dart
class PostValidationService {
  /// التحقق من صحة عنوان المنشور
  static ValidationResult validateTitle(String title) {
    if (title.trim().isEmpty) {
      return ValidationResult.failure('العنوان مطلوب');
    }
    
    if (title.trim().length < 3) {
      return ValidationResult.failure('العنوان يجب أن يكون 3 أحرف على الأقل');
    }
    
    if (title.trim().length > 200) {
      return ValidationResult.failure('العنوان يجب أن يكون أقل من 200 حرف');
    }
    
    return ValidationResult.success();
  }
  
  /// التحقق من صحة محتوى المنشور
  static ValidationResult validateContent(String content) {
    if (content.trim().isEmpty) {
      return ValidationResult.failure('المحتوى مطلوب');
    }
    
    if (content.trim().length < 10) {
      return ValidationResult.failure('المحتوى يجب أن يكون 10 أحرف على الأقل');
    }
    
    if (content.trim().length > 10000) {
      return ValidationResult.failure('المحتوى يجب أن يكون أقل من 10000 حرف');
    }
    
    return ValidationResult.success();
  }
}
```

## 📡 أحداث Domain

### 🎉 حدث إنشاء منشور
```dart
class PostCreatedEvent extends DomainEvent {
  final Post post;
  
  const PostCreatedEvent(this.post, DateTime occurredOn) : super(occurredOn);
}
```

### ✏️ حدث تحديث منشور
```dart
class PostUpdatedEvent extends DomainEvent {
  final Post oldPost;
  final Post newPost;
  
  const PostUpdatedEvent(this.oldPost, this.newPost, DateTime occurredOn) : super(occurredOn);
}
```

### 🗑️ حدث حذف منشور
```dart
class PostDeletedEvent extends DomainEvent {
  final int postId;
  final int userId;
  
  const PostDeletedEvent(this.postId, this.userId, DateTime occurredOn) : super(occurredOn);
}
```

### 👁️ حدث مشاهدة منشور
```dart
class PostViewedEvent extends DomainEvent {
  final int postId;
  final int userId;
  
  const PostViewedEvent(this.postId, this.userId, DateTime occurredOn) : super(occurredOn);
}
```

## ⚠️ استثناءات Domain

### 🔍 استثناء عدم العثور على منشور
```dart
class PostNotFoundException extends PostException {
  final int postId;
  
  const PostNotFoundException(this.postId) 
    : super('المنشور برقم $postId غير موجود', 'POST_NOT_FOUND');
}
```

### 🚫 استثناء عدم وجود صلاحية
```dart
class PostAccessDeniedException extends PostException {
  final int postId;
  final int userId;
  
  const PostAccessDeniedException(this.postId, this.userId) 
    : super('لا توجد صلاحية للوصول للمنشور برقم $postId', 'POST_ACCESS_DENIED');
}
```

### ❌ استثناء عدم صحة البيانات
```dart
class PostValidationException extends PostException {
  final List<String> errors;
  
  PostValidationException(this.errors) 
    : super('بيانات المنشور غير صحيحة: ${errors.join(', ')}', 'POST_VALIDATION_ERROR');
}
```

## 🏗️ واجهات المستودعات

### 📚 واجهة مستودع المنشورات
```dart
abstract class PostRepository {
  Future<Result<List<Post>>> getPosts();
  Future<Result<Post>> createPost(Post post);
  Future<Result<Post>> updatePost(Post post);
  Future<Result<void>> deletePost(int id);
  Future<Result<Post>> getPostById(int id);
  Future<Result<List<Post>>> getPostsByUserId(int userId);
  Future<Result<List<Post>>> searchPosts(String query);
}
```

## 🎯 أفضل الممارسات المطبقة

### 🏗️ **مبادئ Domain-Driven Design**
- **Entities**: كيانات مع هوية فريدة
- **Value Objects**: كيانات القيم الثابتة
- **Use Cases**: منطق الأعمال المنظم
- **Domain Services**: خدمات منطق الأعمال
- **Domain Events**: أحداث تغيير الحالة
- **Domain Exceptions**: استثناءات مخصصة

### 🔒 **التحقق من الصحة**
- **Validation في Use Cases**: التحقق من صحة المدخلات
- **Value Objects**: التحقق من صحة القيم
- **Domain Services**: خدمات التحقق المتخصصة
- **Error Messages**: رسائل خطأ واضحة بالعربية

### 📊 **إدارة الحالة**
- **Immutable Entities**: كيانات ثابتة
- **Status Enums**: حالات محددة وواضحة
- **Extensions**: منطق إضافي للكيانات
- **Calculated Properties**: خصائص محسوبة

### 🧪 **قابلية الاختبار**
- **Pure Functions**: دوال نقية
- **Dependency Injection**: حقن التبعيات
- **Interface Segregation**: فصل الواجهات
- **Single Responsibility**: مسؤولية واحدة

## 🚀 كيفية الاستخدام

### 1. **استخدام Use Cases**
```dart
// في Controller
final getPostsUseCase = ref.read(getPostsUseCaseProvider);
final result = await getPostsUseCase();

result.when(
  success: (posts) => // معالجة النجاح
  failure: (error) => // معالجة الخطأ
);
```

### 2. **استخدام Value Objects**
```dart
// التحقق من صحة العنوان
final title = PostTitle('عنوان المنشور');
if (!title.isValid) {
  print(title.errorMessage);
}
```

### 3. **استخدام Domain Services**
```dart
// التحقق من صحة البيانات
final validation = PostValidationService.validateTitle(title);
if (!validation.isValid) {
  print(validation.errorMessage);
}
```

### 4. **معالجة الاستثناءات**
```dart
try {
  // منطق الأعمال
} on PostNotFoundException catch (e) {
  // معالجة عدم العثور على المنشور
} on PostValidationException catch (e) {
  // معالجة عدم صحة البيانات
}
```

## 📈 المزايا

### ✅ **قابلية الصيانة**
- كود منظم ومفهوم
- فصل واضح للمسؤوليات
- سهولة إضافة ميزات جديدة

### 🧪 **قابلية الاختبار**
- منطق أعمال نقي
- اختبار منفصل لكل مكون
- Mocking سهل

### 🔒 **الأمان**
- التحقق من صحة البيانات
- معالجة الأخطاء الشاملة
- حماية من المدخلات غير الصحيحة

### 🌍 **الدعم العربي**
- رسائل خطأ بالعربية
- تعليقات بالعربية
- واجهات مستخدم محلية

---

**ملاحظة**: هذا Domain Layer يوفر أساساً قوياً لتطبيقات Flutter الإنتاجية مع مرونة عالية للتوسع والتخصيص. 