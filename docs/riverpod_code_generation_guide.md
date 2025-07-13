# دليل استخدام @riverpod للتوليد التلقائي للكود

## مقدمة

`@riverpod` هو annotation جديد في Riverpod 2.0+ يسمح بتوليد الكود تلقائياً للـ providers والـ controllers، مما يقلل من الكود المكرر ويجعل الكود أكثر أماناً وسهولة في القراءة.

## المميزات الرئيسية

### 1. **توليد تلقائي للكود**
- توليد providers تلقائياً
- توليد state classes
- توليد methods للـ controllers
- توليد type-safe references

### 2. **Type Safety**
- فحص الأخطاء في وقت الترجمة
- IntelliSense محسن
- Refactoring آمن

### 3. **أقل كود مكرر**
- لا حاجة لكتابة provider definitions يدوياً
- توليد تلقائي للـ state management
- تكوين مبسط

## الإعداد المطلوب

### 1. إضافة Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  freezed_annotation: ^3.1.0

dev_dependencies:
  build_runner: ^2.5.4
  freezed: ^3.1.0
  riverpod_generator: ^2.3.0
```

### 2. إعداد build.yaml

```yaml
targets:
  $default:
    builders:
      riverpod_generator:
        options:
          provider_name_suffix: "Provider"
```

## أنواع @riverpod

### 1. **Stateful Provider (Controller)**

```dart
@riverpod
class CounterController extends _$CounterController {
  @override
  int build() {
    return 0; // Initial state
  }

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }
}
```

**المميزات:**
- يدير state محلي
- يمكن تعديل state عبر methods
- مناسب للـ forms والـ interactive widgets

### 2. **Stateless Provider**

```dart
@riverpod
String counterText(CounterTextRef ref) {
  final count = ref.watch(counterControllerProvider);
  return 'العداد: $count';
}
```

**المميزات:**
- لا يدير state
- يعتمد على providers أخرى
- مناسب للـ computed values

### 3. **Async Provider**

```dart
@riverpod
Future<List<Post>> posts(PostsRef ref) async {
  final apiClient = ref.watch(apiClientProvider);
  return await apiClient.getPosts();
}
```

**المميزات:**
- يدير async operations
- يدعم loading و error states
- مناسب للـ API calls

### 4. **Family Provider**

```dart
@riverpod
Future<Post> postById(PostByIdRef ref, int id) async {
  final apiClient = ref.watch(apiClientProvider);
  return await apiClient.getPostById(id);
}
```

**المميزات:**
- يقبل parameters
- مناسب للـ data fetching حسب ID
- يدعم caching تلقائي

## أمثلة عملية

### مثال 1: Counter Controller

```dart
// counter_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

@riverpod
class CounterController extends _$CounterController {
  @override
  int build() {
    return 0;
  }

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
  void setValue(int value) => state = value;
}
```

```dart
// counter_page.dart
class CounterPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterControllerProvider);
    
    return Scaffold(
      body: Column(
        children: [
          Text('العداد: $count'),
          ElevatedButton(
            onPressed: () => ref.read(counterControllerProvider.notifier).increment(),
            child: Text('زيادة'),
          ),
        ],
      ),
    );
  }
}
```

### مثال 2: User Profile Controller

```dart
// user_profile_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_controller.freezed.dart';

@freezed
class UserProfileState with _$UserProfileState {
  const factory UserProfileState({
    @Default(false) bool isLoading,
    @Default('') String name,
    @Default('') String email,
    String? error,
  }) = _UserProfileState;
}

@riverpod
class UserProfileController extends _$UserProfileController {
  @override
  UserProfileState build() {
    return const UserProfileState();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // API call simulation
      await Future.delayed(Duration(seconds: 2));
      
      state = state.copyWith(
        isLoading: false,
        name: 'أحمد محمد',
        email: 'ahmed@example.com',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'فشل في تحميل البيانات: $e',
      );
    }
  }

  Future<void> updateProfile({required String name, required String email}) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // API call simulation
      await Future.delayed(Duration(seconds: 1));
      
      state = state.copyWith(
        isLoading: false,
        name: name,
        email: email,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'فشل في تحديث البيانات: $e',
      );
    }
  }
}
```

### مثال 3: Posts Repository

```dart
// posts_repository.dart
@riverpod
Future<List<Post>> posts(PostsRef ref) async {
  final apiClient = ref.watch(apiClientProvider);
  return await apiClient.getPosts();
}

@riverpod
Future<Post> postById(PostByIdRef ref, int id) async {
  final apiClient = ref.watch(apiClientProvider);
  return await apiClient.getPostById(id);
}

@riverpod
Future<void> createPost(CreatePostRef ref, Post post) async {
  final apiClient = ref.watch(apiClientProvider);
  await apiClient.createPost(post);
  ref.invalidate(postsProvider); // Refresh posts list
}
```

## توليد الكود

### 1. تشغيل build_runner

```bash
# توليد الكود مرة واحدة
flutter packages pub run build_runner build

# مراقبة التغييرات وتوليد الكود تلقائياً
flutter packages pub run build_runner watch
```

### 2. الملفات المُولدة

عند استخدام `@riverpod`، سيتم توليد الملفات التالية:

- `*.g.dart` - يحتوي على providers المُولدة
- `*.freezed.dart` - يحتوي على state classes (إذا استخدمت Freezed)

## أفضل الممارسات

### 1. **تنظيم الكود**

```
lib/
  features/
    posts/
      presentation/
        controllers/
          posts_controller.dart
          posts_controller.g.dart
        pages/
          posts_page.dart
```

### 2. **تسمية الملفات**

- `*_controller.dart` للـ stateful providers
- `*_repository.dart` للـ data providers
- `*_service.dart` للـ business logic

### 3. **استخدام Freezed للـ State**

```dart
@freezed
class PostsState with _$PostsState {
  const factory PostsState({
    @Default(false) bool isLoading,
    @Default([]) List<Post> posts,
    String? error,
  }) = _PostsState;
}
```

### 4. **Error Handling**

```dart
@riverpod
class PostsController extends _$PostsController {
  @override
  PostsState build() {
    return const PostsState();
  }

  Future<void> loadPosts() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final posts = await ref.read(postsRepositoryProvider.future);
      state = state.copyWith(isLoading: false, posts: posts);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'فشل في تحميل المنشورات: $e',
      );
    }
  }
}
```

## الفوائد مقارنة بالطريقة التقليدية

### الطريقة التقليدية:

```dart
// تعريف provider يدوياً
final counterProvider = StateNotifierProvider<CounterController, int>((ref) {
  return CounterController();
});

// تعريف controller يدوياً
class CounterController extends StateNotifier<int> {
  CounterController() : super(0);
  
  void increment() => state++;
  void decrement() => state--;
}
```

### مع @riverpod:

```dart
// توليد تلقائي للكود
@riverpod
class CounterController extends _$CounterController {
  @override
  int build() => 0;
  
  void increment() => state++;
  void decrement() => state--;
}
```

## الخلاصة

`@riverpod` annotation يوفر:

1. **أقل كود مكرر** - توليد تلقائي للـ providers
2. **Type safety محسن** - فحص الأخطاء في وقت الترجمة
3. **سهولة الصيانة** - كود أكثر وضوحاً وقابلية للقراءة
4. **أداء محسن** - تحسينات تلقائية للـ caching والـ disposal
5. **تجربة مطور أفضل** - IntelliSense محسن وrefactoring آمن

## الخطوات التالية

1. تحديث المشروع لاستخدام `@riverpod`
2. إعادة كتابة الـ controllers الموجودة
3. إضافة `build_runner` إلى workflow التطوير
4. تدريب الفريق على الاستخدام الجديد 